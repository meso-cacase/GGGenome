#!/usr/bin/perl

# GGGenome (ゲゲゲノム)： 塩基配列を高速に検索するサービス
# http://GGGenome.dbcls.jp/
#
# 曖昧検索サーバに問い合わせを行い、結果を HTML, TXT, JSON 形式で出力する
#
# 必要なモジュール：
# LWP::Simple
# JSON::XS
# ./Align2seq.pm (by Yuki Naito)
#
# 2012-07-03 Yuki Naito (@meso_cacase) 実装開始
# 2012-11-30 Yuki Naito (@meso_cacase) index.html と search.cgi とを統合
# 2012-12-21 Yuki Naito (@meso_cacase) 出力フォーマットの切り替えに対応
# 2013-02-08 Yuki Naito (@meso_cacase) 英語版HTMLの出力に対応
# 2013-02-22 Yuki Naito (@meso_cacase) URIルーティングを本スクリプトに実装

#- ▼ モジュール読み込みと変数の初期化
use warnings ;
use strict ;
use Time::HiRes ;

eval 'use LWP::Simple ; 1' or   # 曖昧検索サーバとの接続に使用
	printresult('ERROR : cannot load LWP::Simple') ;

eval 'use JSON::XS ; 1' or      # 曖昧検索サーバとの接続に使用
	printresult('ERROR : cannot load JSON::XS') ;

my @timer ;                     # 実行時間計測用
my $timestamp = timestamp() ;   # CGIを実行した時刻
my $min_query_length = 6 ;      # クエリの最低塩基長
my $max_k            = 20 ;     # 許容するミスマッチ/ギャップ数の上限、％
my $max_hit_html     = 50 ;     # 検索を打ち切るヒット数、HTMLの場合
my $max_hit_api      = 10000 ;  # 検索を打ち切るヒット数、TXTまたはJSONの場合

my %db_fullname = (             # データベースの正式名
	'hg19'   => 'Human genome, GRCh37/hg19 (Feb, 2009)',
	'mm10'   => 'Mouse genome, GRCm38/mm10 (Dec, 2011)',
	'rn5'    => 'Rat genome, RGSC 5.0/rn5 (Mar, 2012)',
	'dm3'    => 'Drosophila genome, BDGP Rel. 5/dm3 (Apr, 2006)',
	'ce10'   => 'C. elegans genome, WS220/ce10 (Oct, 2010)',
	'rice'   => 'Rice genome, Os-Nipponbare-Reference-IRGSP-1.0 (Oct, 2011)',
	'bmor1'  => 'Silkworm genome, Bmor1 (Apr, 2008)',
	'refseq' => 'RefSeq complete RNA, release 57 (Jan, 2013)',
	'ddbj'   => 'DDBJ release 89.0 (Jun, 2012)'
) ;
#- ▲ モジュール読み込みと変数の初期化

#- ▼ リクエストからパラメータを取得
push @timer, [Time::HiRes::time(), 'start;'] ;                       #===== 実行時間計測 =====

#-- ▽ 使用するパラメータ一覧
my $lang         = '' ;  # HTMLの場合の日本語/英語: ja, en
my $db           = '' ;  # 生物種 (データベース): hg19, mm10, ...
my $k            = '' ;  # 許容するミスマッチ/ギャップの数: 0, 1, 2, ...
my $query_string = '' ;  # 塩基配列
my $format       = '' ;  # 出力フォーマット: html, txt, json
#-- △ 使用するパラメータ一覧

#-- ▽ URIからパラメータを取得
# 例：/en/mm10/2/GCAAGAGAGATTGCTTAGCG.txt
#
my $request_uri = $ENV{'REQUEST_URI'} // '' ;
$request_uri =~ s/\?.*// ;  # '?' 以降のQUERY_STRING部分を除去

#--- ▽ スラッシュ間 (/value/) のパラメーターを処理
my @path = split m{/}, $request_uri ;
foreach (@path){
	($_ =~ /^(ja|en)$/i) ?
		$lang = lc $1 :
	($_ =~ /^(hg19|mm10|rn5|dm3|ce10|rice|bmor1|refseq|ddbj)$/i) ?
		$db = lc $1 :
	($_ =~ /^(\d+)$/) ?
		$k = $1 :
	() ;  # 解釈できないものは無視
}
#--- △ スラッシュ間 (/value/) のパラメーターを処理

#--- ▽ パスの最後の要素 (query.format) を処理
$request_uri =~ m{([^/]*)$} and $query_string = $1 ;
if ($query_string =~ s/(?:\.(html|txt|json))+$//i){
	$1 and $format   = lc $1 ;
}
#--- △ パスの最後の要素 (query.format) を処理
#-- △ URIからパラメータを取得

#-- ▽ QUERY_STRINGからパラメータを取得
my %query = get_query_parameters() ;  # HTTPリクエストからクエリを取得

$query_string =                       # 塩基配列
	$query{'query'} //                # 1) QUERY_STRINGから
	$query_string   //                # 2) QUERY_STRING未指定 → URIから
	'' ;                              # 3) URI未指定 → 空欄

$lang =                               # HTMLの場合の日本語/英語
	(defined $query{'lang'} and $query{'lang'} =~ /^(ja|en)?$/i) ?
	lc($query{'lang'}) :              # 1) QUERY_STRINGから
	$lang //                          # 2) QUERY_STRING未指定 → URIから
	'' ;                              # 3) URI未指定 → 空欄

$db = lc(                             # 生物種 (データベース)
	$query{'db'} //                   # 1) QUERY_STRINGから
	$db          //                   # 2) QUERY_STRING未指定 → URIから
	'') ;                             # 3) URI未指定 → 空欄

$k =                                  # 許容するミスマッチ/ギャップの数
	(defined $query{'k'} and $query{'k'} =~ /^\d+$/) ?
	$query{'k'} :                     # 1) QUERY_STRINGから
	$k //                             # 2) QUERY_STRING未指定 → URIから
	'' ;                              # 3) URI未指定 → 空欄

$format =                             # 出力フォーマット
	(defined $query{'format'} and $query{'format'} =~ /^(html|txt|json)?$/i) ?
	lc($query{'format'}) :            # 1) QUERY_STRINGから
	$format //                        # 2) QUERY_STRING未指定 → URIから
	'' ;                              # 3) URI未指定 → 空欄
#-- △ QUERY_STRINGからパラメータを取得
#- ▲ リクエストからパラメータを取得

#- ▼ パラメータからURIを生成してリダイレクト
my $redirect_uri = '/' ;
$redirect_uri .= ($request_uri =~ m{^/test/}) ? 'test/' : '' ;  # テストページ /test/ 対応
$redirect_uri .= $lang ? "$lang/" : '' ;
$redirect_uri .= $db   ? "$db/"   : '' ;
$redirect_uri .= $k    ? "$k/"    : '' ;  # 値が 0 の場合は /0/ を省略
$redirect_uri .= $query_string ;
$redirect_uri .= $format   ? ".$format"  : '' ;

if ($ENV{'HTTP_HOST'} and              # HTTP経由のリクエストで、かつ
	($request_uri ne $redirect_uri or  # 現在のURIと異なる場合にリダイレクト
	 $ENV{'QUERY_STRING'})
){
	redirect_page("http://$ENV{'HTTP_HOST'}$redirect_uri") ;
}
#- ▲ パラメータからURIを生成してリダイレクト

#- ▼ defaultパラメータ設定
$lang     ||= ($0 =~ /ja$/) ? 'ja' :  # lang が未定義で実行ファイルが index.cgi.ja の場合
	          ($0 =~ /en$/) ? 'en' :  # lang が未定義で実行ファイルが index.cgi.en の場合
	                          'en' ;  # default: en
$db       ||= 'hg19' ;
$k        ||= 0 ;
$format   ||= 'html' ;
#- ▲ defaultパラメータ設定

#- ▼ クエリの内容をチェック
my $queryseq = flatsequence($query_string) ;  # 塩基構成文字以外を除去

# クエリが空欄の場合はトップページを表示
(length($queryseq)) or
	printresult() ;

# クエリの最低塩基長をチェック
(length($queryseq) >= $min_query_length) or
	printresult("ERROR : query sequence should be $min_query_length nt or more") ;

# k(許容するミスマッチ/ギャップの数)の上限をチェック
(length($queryseq) * $max_k / 100 >= $k) or
	printresult("ERROR : number of mismatches/gaps should be ${max_k}% or less") ;
#- ▲ クエリの内容をチェック

#- ▼ 塩基配列の検索と結果出力
#-- ▽ 生物種 $db により切り替えるパラメータ
my $db_fullname = $db_fullname{$db} //  # データベースの正式名
	$db_fullname{'hg19'} ;              # default: Human genome (hg19)
my $port =                              # 曖昧検索サーバのポート
	($db eq 'mm10'  ) ? 22253 :
	($db eq 'rn5'   ) ? 22263 :
	($db eq 'dm3'   ) ? 22273 :
	($db eq 'ce10'  ) ? 22283 :
	($db eq 'rice'  ) ? 22293 :
	($db eq 'bmor1' ) ? 22303 :
	($db eq 'refseq') ? 22243 :
	($db eq 'ddbj'  ) ? 32313 :
	                    22233 ;         # default: Human genome (hg19)
#-- △ 生物種 $db により切り替えるパラメータ

push @timer, [Time::HiRes::time(), 'search_start;'] ;                #===== 実行時間計測 =====

my $hits ;        # 曖昧検索サーバから取得したJSON形式の結果
my $uri ;         # 曖昧検索サーバへのリクエストURI
my $hit_num ;     # ヒット件数
my $hit_approx ;  # ヒット件数が概算かどうか
my @summary ;     # 検索結果のヘッダ情報 (データベース名、ヒット件数など)
my @hit_list ;    # 検索結果のリスト

#-- ▽ TXT(タブ区切りテキスト)形式
if ($format eq 'txt'){
	my $limit = $max_hit_api ;  # 検索を打ち切るヒット数
	push @summary, "# [GGGenome | $timestamp ]" ;
	push @summary, "# database:	$db_fullname" ;

	#--- ▽ (+)鎖の検索実行と結果出力
	($hits, $uri) = approx_q(uc(rna2dna($queryseq)), $port, $k, $limit) or
		printresult('ERROR : searcher error') ;

	push @timer, [Time::HiRes::time(), "search_plus_done; $uri"] ;   #===== 実行時間計測 =====

	foreach (@{$hits->{hits}}){
		push @hit_list, show_hit_txt($_) ;
	}

	# ヒット数を出力、予測値の場合は有効2桁で先頭に'>'を付加
	$hit_num    = $hits->{total_hit_num}           // '' ;
	$hit_approx = $hits->{total_hit_num_is_approx} // '' ;
	$hit_approx and $hit_num =~ s/^(\d{2})(\d*)/'>' . $1 . 0 x length($2)/e ;

	push @summary, "# query:	$queryseq" ;
	push @summary, "# count:	$hit_num" ;
	#--- △ (+)鎖の検索実行と結果出力

	#--- ▽ (-)鎖の検索実行と結果出力
	$queryseq = comp($queryseq) ;
	($hits, $uri) = approx_q(uc(rna2dna($queryseq)), $port, $k, $limit) or
		printresult('ERROR : searcher error') ;

	push @timer, [Time::HiRes::time(), "search_minus_done; $uri"] ;  #===== 実行時間計測 =====

	foreach (@{$hits->{hits}}){
		push @hit_list, show_hit_txt($_) ;
	}

	# ヒット数を出力、予測値の場合は有効2桁で先頭に'>'を付加
	$hit_num    = $hits->{total_hit_num}           // '' ;
	$hit_approx = $hits->{total_hit_num_is_approx} // '' ;
	$hit_approx and $hit_num =~ s/^(\d{2})(\d*)/'>' . $1 . 0 x length($2)/e ;

	push @summary, "# query:	$queryseq" ;
	push @summary, "# count:	$hit_num" ;
	#--- △ (-)鎖の検索実行と結果出力

	push @summary, '# name	start	end	snippet' ;
	@hit_list or push @hit_list, '### No items found. ###' ;  # ヒットがゼロ件
	print_txt(join "\n", (@summary, @hit_list)) ;
#-- △ TXT(タブ区切りテキスト)形式

#-- ▽ JSON形式
} elsif ($format eq 'json'){
	my $limit = $max_hit_api ;  # 検索を打ち切るヒット数

	#--- ▽ (+)鎖の検索実行と結果出力
	($hits, $uri) = approx_q(uc(rna2dna($queryseq)), $port, $k, $limit) or
		printresult('ERROR : searcher error') ;

	push @timer, [Time::HiRes::time(), "search_plus_done; $uri"] ;   #===== 実行時間計測 =====

	foreach (@{$hits->{hits}}){
		push @hit_list, @{ show_hit_json($_) } ;
	}

	# ヒット数、ヒット数が概算かどうかを出力
	$hit_num    = $hits->{total_hit_num}           // '' ;
	$hit_approx = $hits->{total_hit_num_is_approx} // '' ;

	push @summary, {
		query => $queryseq,
		count => $hit_num,
		count_is_approx => $hit_approx
	} ;
	#--- △ (+)鎖の検索実行と結果出力

	#--- ▽ (-)鎖の検索実行と結果出力
	$queryseq = comp($queryseq) ;
	($hits, $uri) = approx_q(uc(rna2dna($queryseq)), $port, $k, $limit) or
		printresult('ERROR : searcher error') ;

	push @timer, [Time::HiRes::time(), "search_minus_done; $uri"] ;  #===== 実行時間計測 =====

	foreach (@{$hits->{hits}}){
		push @hit_list, @{ show_hit_json($_) } ;
	}

	# ヒット数、ヒット数が概算かどうかを出力
	$hit_num    = $hits->{total_hit_num}           // '' ;
	$hit_approx = $hits->{total_hit_num_is_approx} // '' ;

	push @summary, {
		query => $queryseq,
		count => $hit_num,
		count_is_approx => $hit_approx
	} ;
	#--- △ (-)鎖の検索実行と結果出力

	my $json_result = JSON::XS->new->canonical->utf8->encode(
		{time => $timestamp,
		database => $db_fullname,
		summary => \@summary,
		results => \@hit_list,
		error => 'none'}
	) ;
	print_json($json_result) ;
#-- △ JSON形式

#-- ▽ HTML形式
} else {  # default: html
	my $limit = $max_hit_html ;  # 検索を打ち切るヒット数
	eval 'require Align2seq ; 1' or  # ミスマッチ/ギャップのある配列のハイライトに使用
		printresult('ERROR : cannot load Align2seq') ;

	#--- ▽ (+)鎖の検索実行と結果出力
	($hits, $uri) = approx_q(uc(rna2dna($queryseq)), $port, $k, $limit) or
		printresult('ERROR : searcher error') ;

	push @timer, [Time::HiRes::time(), "search_plus_done; $uri"] ;   #===== 実行時間計測 =====

	foreach (@{$hits->{hits}}){
		push @hit_list, show_hit_html($_) ;
	}

	# ヒット数を出力、予測値の場合は有効2桁で先頭に'>'を付加
	$hit_num    = $hits->{total_hit_num}           // '' ;
	$hit_approx = $hits->{total_hit_num_is_approx} // '' ;
	$hit_approx and $hit_num =~ s/^(\d{2})(\d*)/'&gt;' . $1 . 0 x length($2)/e ;

	push @summary,
		"	<li><a href='./?query=$queryseq&amp;db=$db&amp;k=$k'>$queryseq ($hit_num)</a>" ;
	#--- △ (+)鎖の検索実行と結果出力

	#--- ▽ (-)鎖の検索実行と結果出力
	$queryseq = comp($queryseq) ;
	($hits, $uri) = approx_q(uc(rna2dna($queryseq)), $port, $k, $limit) or
		printresult('ERROR : searcher error') ;

	push @timer, [Time::HiRes::time(), "search_minus_done; $uri"] ;  #===== 実行時間計測 =====

	foreach (@{$hits->{hits}}){
		push @hit_list, show_hit_html($_) ;
	}

	# ヒット数を出力、予測値の場合は有効2桁で先頭に'>'を付加
	$hit_num    = $hits->{total_hit_num}           // '' ;
	$hit_approx = $hits->{total_hit_num_is_approx} // '' ;
	$hit_approx and $hit_num =~ s/^(\d{2})(\d*)/'&gt;' . $1 . 0 x length($2)/e ;

	push @summary,
		"	<li><a href='./?query=$queryseq&amp;db=$db&amp;k=$k'>$queryseq ($hit_num)</a>" ;
	#--- △ (-)鎖の検索実行と結果出力

	@hit_list or
		push @hit_list, '<div class=gene><p>No items found.</p></div>' ;  # ヒットがゼロ件

	push @timer, [Time::HiRes::time(), 'cgi_end;'] ;                 #===== 実行時間計測 =====

	#--- ▽ 実行時間計測データの処理
	my @timelog ;
	my $start_time = ${shift @timer}[0] ;
	my $last_time = $start_time ;  # 初期値
	foreach (@timer){
		push @timelog,
			sprintf("%.3f", $$_[0] - $start_time) . ' | ' .  # 累積タイム
			sprintf("%.3f", $$_[0] - $last_time ) . ' | ' .  # 区間タイム
			$$_[1] ;  # コメント
		$last_time = $$_[0] ;
	}
	#--- △ 実行時間計測データの処理

	$query_string = escape_char($query_string // '') ;  # 結果ページに表示するためXSS対策
	$query_string =~ s/(^\s+|\s+$)//g ;                 # 先頭または末尾の空白文字を除去
	$" = "\n" ;
	my $html = ($lang eq 'ja') ?
	#--- ▽ +++++++++++++++++ Japanese HTML ++++++++++++++++++
"<p class=g>$timestamp, GGGenome : $db_fullname</p>

<h4>Summary:</h4>
<div>
<ul>
@summary
</ul>
</div>

<h4>Results:</h4>
<p>＋鎖および－鎖それぞれ${max_hit_html}件まで表示。
検索語に<em>色がつきます（<strong>ミスマッチ</strong>・<ins>挿入</ins><del>欠失</del>）</em>。</p>
@hit_list

<h4>Data Export:</h4>

<p>下記より最大${max_hit_api}件まで検索結果を取得できます。</p>

<div>
<ul>
	<li>タブ区切りテキスト &rarr;
		<a href='?format=txt'>表示</a> |
		<a hret=''>ダウンロード</a><br>
		エクセル等の表計算ソフトに直接コピペできます。
	<li>JSON形式 &rarr;
		<a href='?format=json'>表示</a> |
		<a hret=''>ダウンロード</a>
</ul>
</div>

<h4 class=s>デバッグ用データ:</h4>

<p class=s>
<!--
Request URI  : http://<font color='#808080'>$ENV{'HTTP_HOST'}</font>$request_uri<br>
-->
Redirect URI : http://<font color='#808080'>$ENV{'HTTP_HOST'}</font>$redirect_uri<br>
lang         : <font color='#808080'>$lang</font>         |
db           : <font color='#ffb280'>$db</font>           |
k            : <font color='#7f7fff'>$k</font>            |
query_string : <font color='#6bb36b'>$query_string</font> |
format       : <font color='#ff80bf'>$format</font>
</p>

<pre class=s>
@timelog
</pre>" :
	#--- △ +++++++++++++++++ Japanese HTML ++++++++++++++++++
	#--- ▽ +++++++++++++++++ English HTML +++++++++++++++++++
"<p class=g>$timestamp, GGGenome : $db_fullname</p>

<h4>Summary:</h4>
<div>
<ul>
@summary
</ul>
</div>

<h4>Results:</h4>
<p>Showing first ${max_hit_html} results for each strand of the query sequence.<br>
Matches are <em>highlighted with blue background.
<strong>Mismatches</strong> and <ins>in</ins><del>dels</del></em> are marked in red.</p>
@hit_list

<h4>Data Export:</h4>

<p>Maximum ${max_hit_api} results can be retrieved as Tab-delimited text or JSON format.</p>

<div>
<ul>
	<li>Tab-delimited text:
		<a href='?format=txt'>Open in new window</a> |
		<a hret=''>Download</a><br>
		You can copy-paste the result into spreadsheet softwares
		(<i>e.g.</i> Excel) or text editors.
	<li>JSON format:
		<a href='?format=json'>Open in new window</a> |
		<a hret=''>Download</a>
</ul>
</div>

<h4 class=s>Debug Info:</h4>

<p class=s>
<!--
Request URI  : http://<font color='#808080'>$ENV{'HTTP_HOST'}</font>$request_uri<br>
-->
Redirect URI : http://<font color='#808080'>$ENV{'HTTP_HOST'}</font>$redirect_uri<br>
lang         : <font color='#808080'>$lang</font>         |
db           : <font color='#ffb280'>$db</font>           |
k            : <font color='#7f7fff'>$k</font>            |
query_string : <font color='#6bb36b'>$query_string</font> |
format       : <font color='#ff80bf'>$format</font>
</p>

<pre class=s>
@timelog
</pre>" ;
	#--- △ +++++++++++++++++ English HTML +++++++++++++++++++
	($lang eq 'ja') ? print_html_ja($html) :  # Japanese HTML
	                  print_html_en($html) ;  # default: English HTML
}
#-- △ HTML形式
#- ▲ 塩基配列の検索と結果出力

exit ;

# ====================
sub timestamp {  # タイムスタンプを 2000-01-01 00:00:00 の形式で出力
my ($sec, $min, $hour, $mday, $mon, $year) = localtime ;
return sprintf("%04d-%02d-%02d %02d:%02d:%02d",
	$year+1900, $mon+1, $mday, $hour, $min, $sec) ;
} ;
# ====================
sub get_query_parameters {  # CGIが受け取ったパラメータの処理
my $buffer = '' ;
if (defined $ENV{'REQUEST_METHOD'} and
	$ENV{'REQUEST_METHOD'} eq 'POST' and
	defined $ENV{'CONTENT_LENGTH'}
){
	eval 'read(STDIN, $buffer, $ENV{"CONTENT_LENGTH"})' or
		printresult('ERROR : get_query_parameters() : read failed') ;
} elsif (defined $ENV{'QUERY_STRING'}){
	$buffer = $ENV{'QUERY_STRING'} ;
}
my %query ;
my @query = split /&/, $buffer ;
foreach (@query){
	my ($name, $value) = split /=/ ;
	if (defined $name and defined $value){
		$value =~ tr/+/ / ;
		$value =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack('C', hex($1))/eg ;
		$name  =~ s/%([a-fA-F0-9][a-fA-F0-9])/pack('C', hex($1))/eg ;
		$query{$name} = $value ;
	}
}
return %query ;
} ;
# ====================
sub redirect_page {  # リダイレクトする
my $uri = $_[0] // '' ;
print "Location: $uri\n\n" ;

exit ;
} ;
# ====================
sub flatsequence {  # 塩基構成文字以外を除去
my $seq = $_[0] // '' ;
$seq =~ s/[^ATGCUNRYMKSWHBVD-]//gi ;
return $seq ;
} ;
# ====================
sub rna2dna {  # 塩基配列中のUをTに置換
my $seq = $_[0] // '' ;
$seq =~ tr/Uu/Tt/ ;
return $seq ;
} ;
# ====================
sub comp {  # 相補鎖を求める
# DNA配列(A,T,G,C)を出力するが、もとの配列にUが含まれるときはRNA配列(A,U,G,C)を出力
my $seq = flatsequence($_[0]) ;
my $comp = '' ;
if ($seq =~ /U/i){  # 配列にUが含まれる → RNAの場合
	($comp = reverse $seq) =~
		tr/GATUCRYMKSWHBVDNgatucrymkswhbvdn/CUAAGYRKMSWDVBHNcuaagyrkmswdvbhn/ ;
} else {  # それ以外 → DNAの場合
	($comp = reverse $seq) =~
		tr/GATUCRYMKSWHBVDNgatucrymkswhbvdn/CTAAGYRKMSWDVBHNctaagyrkmswdvbhn/ ;
}
return $comp ;
} ;
# ====================
sub approx_q {  # 曖昧検索サーバに問い合わせを行う
my $q     = $_[0] or return () ;
my $port  = $_[1] or return () ;
my $k     = $_[2] // 0  ;
my $limit = $_[3] // '' ;
my $host  = '172.17.1.21' ;  # ssd.dbcls.jp (曖昧検索サーバ)
my $uri   = "http://$host:$port/match?q=$q&k=$k&offset=0&limit=$limit" ;
my $json  = get($uri) or return () ;
return (decode_json($json) // '', $uri) ;
} ;
# ====================
sub show_hit_txt {  # ヒットした遺伝子をタブ区切りテキストで出力
my $gene = $_[0] or return '' ;

my $name     = $gene->{docname} // '' ;
my $length   = $gene->{length}  // 0  ;
my $position = $gene->{pos} + 1 // '' ;
my $snippet  = $gene->{snippet} // '' ;

my $position_end = $position + $length - 1 ;

$name =~ s/^>// ;
my $txt = "$name	$position	$position_end	$snippet" ;
return $txt ;
} ;
# ====================
sub show_hit_json {  # ヒットした遺伝子をJSONで出力
my $gene = $_[0] or return '' ;

my $name     = $gene->{docname} // '' ;
my $length   = $gene->{length}  // 0  ;
my $position = $gene->{pos} + 1 // '' ;
my $snippet  = $gene->{snippet} // '' ;

my $position_end = $position + $length - 1 ;

$name =~ s/^>// ;
my $json = [{
	name         => $name,
	position     => $position,
	position_end => $position_end,
	snippet      => $snippet
}] ;
return $json ;
} ;
# ====================
sub show_hit_html {  # ヒットした遺伝子をHTMLで出力
my $gene = $_[0] or return '' ;

my $name        = $gene->{docname}         // '' ;
my $length      = $gene->{length}          // 0  ;
my $position    = $gene->{pos} + 1         // '' ;
my $snippet     = $gene->{snippet}         // '' ;
my $snippet_pos = $gene->{snippet_pos} + 1 // '' ;

my $position_end = $position + $length - 1 ;

my $snippet_5prime = substr($snippet, 0, $position - $snippet_pos) ;
my $sbjct = substr($snippet, $position - $snippet_pos, $length) ;
my $snippet_3prime = substr($snippet, $position - $snippet_pos + $length) ;

# スニペットは前後30塩基を表示する
$snippet_5prime = substr($snippet_5prime, -30) ;
$snippet_3prime = substr($snippet_3prime, 0, 30) ;

# クエリ文字列とヒット文字列とを比較し、ミスマッチ/ギャップをハイライト
my $align = Align2seq::diffseq(uc($queryseq), uc($sbjct)) ;

my $snippet_html =
	$snippet_5prime .
	'<em style="position:relative">' .
	"<span class=position>▼$position</span>" .
	"$align</em>$snippet_3prime" ;

#【TODO】NCBI等へのリンクを設定
$name =~ s/^>// ;
my $html =
"<div class=gene><!-- ==================== -->
<div class=t>
$name:$position-$position_end
</div>
<div class=b>
$snippet_html
</div>
<!--
<div class=b>
<cite>version_html</cite> -
<cite>species</cite> -
<a target=\"_blank\" href=\"http://www.ncbi.nlm.nih.gov/nuccore/version\" class=a>NCBI</a>
</div>
-->
</div>" ;
return $html ;
} ;
# ====================
sub escape_char {  # < > & ' " の5文字を実態参照に変換
my $string = $_[0] // '' ;
$string =~ s/\&/&amp;/g ;
$string =~ s/</&lt;/g ;
$string =~ s/>/&gt;/g ;
$string =~ s/\'/&apos;/g ;
$string =~ s/\"/&quot;/g ;
return $string ;
} ;
# ====================
sub printresult {  # $format (global) にあわせて結果を出力
($format eq 'txt' ) ? print_txt($_[0])     :
($format eq 'json') ? print_json($_[0])    :
($lang   eq 'ja'  ) ? print_html_ja($_[0]) :  # default format: html
                      print_html_en($_[0]) ;  # default lang  : en
exit ;
} ;
# ====================
sub print_txt {  # TXTを出力

#- ▼ メモ
# ・検索結果をタブ区切りテキストで出力
# ・引数が ERROR で始まる場合はエラーを出力
# ・引数がない場合はREST APIの仕様を出力
#- ▲ メモ

my $txt = $_[0] // '' ;

#- ▼ 検索結果を出力：default
# 引数をそのまま出力するので何もしなくてよい
#- ▲ 検索結果を出力：default

#- ▼ エラーを出力：引数が ERROR で始まる場合
$txt =~ s/^(ERROR.*)$/### $1 ###/s ;
#- ▲ エラーを出力：引数が ERROR で始まる場合

#- ▼ REST API仕様を出力：引数がない場合
(not $txt) and $txt =
#-- ▽ ++++++++++++++++++++++++++++++++++++++++++++++++++
"GGGenome REST API

Query format:

http://GGGenome.dbcls.jp/DATABASE/K/SEQUENCE[.FORMAT]
  DATABASE (optional):
    'hg19' - $db_fullname{'hg19'} or
    'mm10' - $db_fullname{'mm10'} or
    'rn5'  - $db_fullname{'rn5'} or
    'dm3'  - $db_fullname{'dm3'} or
    'ce10' - $db_fullname{'ce10'} or
    'rice' - $db_fullname{'rice'} or
    'bmor1' - $db_fullname{'bmor1'} or
    'refseq' - $db_fullname{'refseq'} or
    'ddbj' - $db_fullname{'ddbj'}
    Default: hg19
  K (optional):
    Maximun number of mismatches and gaps.
    Default: 0
  SEQUENCE:
    Nucleotide sequence.
  FORMAT (optional):
    'html' - HTML
    'txt' - Tab delimited text
    'json' - JSON object
    Default: html

Examples:

http://GGGenome.dbcls.jp/GCAAGAAGAGATTGC
  Search 'GCAAGAAGAGATTGC' in human genome hg19. (default)
  Search only perfect match sequences. (default)
  Output in HTML format. (default)

http://GGGenome.dbcls.jp/mm10/2/GCAAGAGAGATTGCTTAGCG.txt
  Search 'GCAAGAGAGATTGCTTAGCG' in mouse genome mm10.
  Search sequences within two mismatches and gaps.
  Output in tab delimited text format.
" ;
#-- △ ++++++++++++++++++++++++++++++++++++++++++++++++++
#- ▲ REST API仕様を出力：引数がない場合

#- ▼ TXT出力
print "Content-type: text/plain; charset=utf-8\n\n" ;
print "$txt\n" ;
#- ▲ TXT出力

return ;
} ;
# ====================
sub print_json {  # JSONを出力

#- ▼ メモ
# ・検索結果をJSONで出力
# ・引数が ERROR で始まる場合はエラーをJSONで出力
# ・引数がない場合 → ERROR : query is empty
#- ▲ メモ

my $json_txt = $_[0] // '' ;

#- ▼ 検索結果を出力：default
# 引数をそのまま出力するので何もしなくてよい
#【TODO】{error: none} を付加
#- ▲ 検索結果を出力：default

#- ▼ 引数がない場合 → ERROR : query is empty
(not $json_txt) and $json_txt = 'ERROR : query is empty' ;
#- ▲ 引数がない場合 → ERROR : query is empty

#- ▼ エラーを出力：引数が ERROR で始まる場合
($json_txt =~ /^ERROR[:\s]*(.*)$/s) and
$json_txt = JSON::XS->new->canonical->utf8->encode(
	{error => $1}
) ;
#- ▲ エラーを出力：引数が ERROR で始まる場合

#- ▼ JSON出力
print "Content-type: application/json; charset=utf-8\n\n" ;
print "$json_txt\n" ;
#- ▲ JSON出力

return ;
} ;
# ====================
sub print_html_ja {  # HTMLを出力 (日本語)

#- ▼ メモ
# ・検索結果ページをHTMLで出力
# ・引数が ERROR で始まる場合はエラーページを出力
# ・引数がない場合はトップページを出力
#- ▲ メモ

my $html = $_[0] // '' ;

#- ▼ 検索結果ページを出力：default
my $title  = 'GGGenome | Results' ;
my $robots = "<meta name=robots content=none>\n" ;  # トップページ以外はロボット回避

#-- ▽ プルダウンメニュー
my $select =
"	<option value=hg19>$db_fullname{'hg19'}</option>
	<option value=mm10>$db_fullname{'mm10'}</option>
	<option value=rn5>$db_fullname{'rn5'}</option>
	<option value=dm3>$db_fullname{'dm3'}</option>
	<option value=ce10>$db_fullname{'ce10'}</option>
	<option value=rice>$db_fullname{'rice'}</option>
	<option value=bmor1>$db_fullname{'bmor1'}</option>
	<option disabled>----------</option>
	<option value=refseq>$db_fullname{'refseq'}</option>
	<option value=ddbj>$db_fullname{'ddbj'}</option>" ;
$db and $select =~ s/(?<=option value=$db)/ selected/ or  # 種を選択
	$select =~ s/(?<=option value=hg19)/ selected/ ;      # default: Human genome (hg19)
#-- △ プルダウンメニュー
#- ▲ 検索結果ページを出力：default

#- ▼ エラーページを出力：引数が ERROR で始まる場合
$html =~ s{^(ERROR.*)$}{<p><font color=red>$1</font></p>}s and
$title  = 'GGGenome | Error' and
$robots = "<meta name=robots content=none>\n" ;  # トップページ以外はロボット回避
#- ▲ エラーページを出力：引数が ERROR で始まる場合

#- ▼ トップページ：引数がない場合
(not $html) and $html =
#-- ▽ ++++++++++++++++++++++++++++++++++++++++++++++++++
"<div>
検索例：
<ul>
	<li><font color=purple>[</font>
		<a href='GCAAGAAGAGATTGC'>GCAAGAAGAGATTGC</a>
		<font color=purple>]</font> ...... 塩基配列を検索
</ul>
</div>

<div>
ひとこと：
<ul>
	<li>塩基配列を高速に検索するサイトです。
	<li>大文字・小文字は区別しません。
	<li>U は T とまったく同じです。
	<li>ATGCU 以外の塩基 (R,Y等) は N とみなします。
	<li>それ以外の文字は除去して検索されます。
	<li>＋鎖および－鎖それぞれ${max_hit_html}件まで結果を表示します。
	<li>TXT, JSON形式ではそれぞれ${max_hit_api}件まで取得できます。</font>
</ul>
</div>

<div>
検索結果へのリンク：
<ul>
	<li>http://GGGenome.dbcls.jp/<!--
		--><span style='color:#ff6600'>db</span>/<!--
		--><span style='color:#0000ff'>k</span>/<!--
		--><span style='color:#008000'>sequence</span><!--
		-->[.<span style='color:#FF0080'>format</span>]
	<ul>
		<li><span style='color:#ff6600'>db</span> &rarr;
			hg19, mm10, rn5, dm3, ce10, rice, bmor1, refseq, ddbj。省略時は hg19
		<li><span style='color:#0000ff'>k</span> &rarr;
			許容するミスマッチ/ギャップの数。あまり大きいとしぼうする。省略時は 0
		<li><span style='color:#008000'>sequence</span> &rarr;
			塩基配列。大文字・小文字は区別しない
		<li><span style='color:#FF0080'>format</span> &rarr;
			html, txt, json。省略時は html
	</ul>
	<li>例1：<a href='http://GGGenome.dbcls.jp/GCAAGAAGAGATTGC'><!--
		-->http://GGGenome.dbcls.jp/<!--
		--><span style='color:#008000'>GCAAGAAGAGATTGC</span><!--
		--></a>
	<ul>
		<li>ヒトゲノム <span style='color:#ff6600'>hg19</span> (省略可) で
		<li>ミスマッチ/ギャップを許容せず (省略可)
		<li><span style='color:#008000'>GCAAGAAGAGATTGC</span> を検索し
		<li><span style='color:#FF0080'>html</span> 形式 (省略可) で結果を返す
	</ul>
	<li>例2：<a href='http://GGGenome.dbcls.jp/mm10/2/GCAAGAGAGATTGCTTAGCG.txt'><!--
		-->http://GGGenome.dbcls.jp/<!--
		--><span style='color:#ff6600'>mm10</span>/<!--
		--><span style='color:#0000ff'>2</span>/<!--
		--><span style='color:#008000'>GCAAGAGAGATTGCTTAGCG</span><!--
		-->.<span style='color:#FF0080'>txt</span><!--
		--></a>
	<ul>
		<li>マウスゲノム <span style='color:#ff6600'>mm10</span> で
		<li><span style='color:#0000ff'>2</span> ミスマッチ/ギャップまで許容して
		<li><span style='color:#008000'>GCAAGAGAGATTGCTTAGCG</span> を検索し
		<li><span style='color:#FF0080'>txt</span> 形式 (タブ区切りテキスト) で結果を返す
	</ul>
</ul>
</div>

<div>
新着情報：
<ul>
	<li>2013-02-12 カイコゲノムを追加。
	<li>2013-02-08 <a class=a href='en/'>英語版</a> を公開。
	<li>2013-02-08 イネゲノムを追加。
	<li>2013-02-06 ソースを公開 -
		<a class=a target='_blank' href='https://github.com/meso-cacase/GGGenome'>GitHub</a>
	<li>2013-01-16 RefSeq rel. 57 (Jan, 2013) に更新。
	<li>2012-12-21 GGGenome REST APIを公開。
	<li>2012-12-21 ラット、ショウジョウバエ、線虫のゲノムを追加。
	<li>2012-11-15 RefSeq rel. 56 (Nov, 2012) に更新。
	<li>2012-07-26 マウスゲノムを追加。
	<li>2012-07-25 RefSeq rel. 54 (Jul, 2012) に更新。
	<li>2012-07-04 ゲゲゲノムのテストサイトを構築
</ul>
</div>" and
#-- △ ++++++++++++++++++++++++++++++++++++++++++++++++++
$title  = '超絶高速ゲノム配列検索 GGGenome' and
$robots = '' ;
#- ▲ トップページ：引数がない場合

#- ▼ HTML出力
print
#-- ▽ ++++++++++++++++++++++++++++++++++++++++++++++++++
"Content-type: text/html; charset=utf-8

<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>
<html lang=ja>

<head>
<meta http-equiv='Content-Type' content='text/html; charset=utf-8'>
<meta http-equiv='Content-Style-Type' content='text/css'>
$robots<meta name=author content='Yuki Naito'>
<title>$title</title>
<style type='text/css'>
<!--
	* { font-family:verdana,arial,helvetica,sans-serif }
	p,ol,pre,div,small,cite { font-size:9pt }
	cite { color:#0E774A; font-style:normal }
	a { color:black; font-style:normal }
	em { font-style:normal;
		border:1px solid #00BCFF;
		background-color:#DDF6FF }
	strong { font-style:normal;
		font-weight:bold;
		color:red;
		background-color:#DDF6FF }
	ins,del { font-style:normal;
		font-weight:bold;
		text-decoration:none;
		background-color:pink }
	.position { position:absolute;
		top:-1.2em;
		color:#0E774A;
		font-size:80%;
		user-select:none　}
	.gene { margin:10pt }
	.a { color:#3366CC }
	.t { font-size:10pt; width:90% }
	.b { word-wrap:break-word; width:90% }
	.g { color:gray; width:90% }
	.s { color:silver; width:90% }
-->
</style>
</head>

<body>

<a href='.'><img src='GGGlogo_ja.png' alt='GGGenome' height=71 width=257 border=0></a>

<small style='vertical-align:top'>
<a style='vertical-align:top' class=k href='?lang=en'>English</a>
</small>

<form name=gggenome method=GET action='.'>
<p>
<input type=text name=query size=70 value='$query_string'>
<input type=submit value='検索'>
<select id=db name=db>
$select
</select>
<br>
許容するミスマッチ/ギャップの数：<input type=text name=k size=3 value='$k'>
(検索する塩基配列の長さの20%まで)
</p>
</form>

$html

<hr><!-- __________________________________________________ -->

<p class=g>by
<a target='_blank' class=a href='http://twitter.com/meso_cacase'>\@meso_cacase</a> at 
<a target='_blank' class=a href='http://dbcls.rois.ac.jp/'>DBCLS</a><br>
This page is licensed under a
<a target='_blank' class=a href='http://creativecommons.org/licenses/by/2.1/jp/'>
Creative Commons Attribution 2.1 Japan License</a>.</p>

</body>
</html>
" ;
#-- △ ++++++++++++++++++++++++++++++++++++++++++++++++++
#- ▲ HTML出力

return ;
} ;
# ====================
sub print_html_en {  # HTMLを出力 (English)

#- ▼ メモ
# ・検索結果ページをHTMLで出力
# ・引数が ERROR で始まる場合はエラーページを出力
# ・引数がない場合はトップページを出力
#- ▲ メモ

my $html = $_[0] // '' ;

#- ▼ 検索結果ページを出力：default
my $title  = 'GGGenome | Results' ;
my $robots = "<meta name=robots content=none>\n" ;  # トップページ以外はロボット回避

#-- ▽ プルダウンメニュー
my $select =
"	<option value=hg19>$db_fullname{'hg19'}</option>
	<option value=mm10>$db_fullname{'mm10'}</option>
	<option value=rn5>$db_fullname{'rn5'}</option>
	<option value=dm3>$db_fullname{'dm3'}</option>
	<option value=ce10>$db_fullname{'ce10'}</option>
	<option value=rice>$db_fullname{'rice'}</option>
	<option value=bmor1>$db_fullname{'bmor1'}</option>
	<option disabled>----------</option>
	<option value=refseq>$db_fullname{'refseq'}</option>
	<option value=ddbj>$db_fullname{'ddbj'}</option>" ;
$db and $select =~ s/(?<=option value=$db)/ selected/ or  # 種を選択
	$select =~ s/(?<=option value=hg19)/ selected/ ;      # default: Human genome (hg19)
#-- △ プルダウンメニュー
#- ▲ 検索結果ページを出力：default

#- ▼ エラーページを出力：引数が ERROR で始まる場合
$html =~ s{^(ERROR.*)$}{<p><font color=red>$1</font></p>}s and
$title  = 'GGGenome | Error' and
$robots = "<meta name=robots content=none>\n" ;  # トップページ以外はロボット回避
#- ▲ エラーページを出力：引数が ERROR で始まる場合

#- ▼ トップページ：引数がない場合
(not $html) and $html =
#-- ▽ ++++++++++++++++++++++++++++++++++++++++++++++++++
"<div>
Search example:
<ul>
	<li><font color=purple>[</font>
		<a href='GCAAGAAGAGATTGC'>GCAAGAAGAGATTGC</a>
		<font color=purple>]</font> ...... Search for a nucleotide sequence
</ul>
</div>

<div>
Search tips:
<ul>
	<li>GGGenome is an ultrafast search engine for nucleotide sequences.
	<li>Searches are always case insensitive.
	<li>U and T will be treated identically.
	<li>Ambiguous nucleotide characters (R,Y etc.) are converted to N's.
	<li>All other characters are ignored.
	<li>GGGenome shows first ${max_hit_html} results for each strand of the query sequence.
	<li>Maximum ${max_hit_api} results can be retrieved as TXT or JSON format.
</ul>
</div>

<div>
URIs:
<ul>
	<li>http://GGGenome.dbcls.jp/<!--
		--><span style='color:#ff6600'>db</span>/<!--
		--><span style='color:#0000ff'>k</span>/<!--
		--><span style='color:#008000'>sequence</span><!--
		-->[.<span style='color:#FF0080'>format</span>]
	<ul>
		<li><span style='color:#ff6600'>db</span>:
			hg19, mm10, rn5, dm3, ce10, rice, bmor1, refseq, ddbj. (default: hg19)
		<li><span style='color:#0000ff'>k</span>:
			Maximum number of mismatches/gaps. (default: 0)
		<li><span style='color:#008000'>sequence</span>:
			Nucleotide sequence, case insensitive.
		<li><span style='color:#FF0080'>format</span>:
			html, txt, json. (default: html)
	</ul>
	<li>Example 1: <a href='http://GGGenome.dbcls.jp/GCAAGAAGAGATTGC'><!--
		-->http://GGGenome.dbcls.jp/<!--
		--><span style='color:#008000'>GCAAGAAGAGATTGC</span><!--
		--></a>
	<ul>
		<li>Search <span style='color:#008000'>GCAAGAAGAGATTGC</span> in
		<li>human genome <span style='color:#ff6600'>hg19</span> (default),
		<li>with perfect matches (default),
		<li>output in <span style='color:#FF0080'>html</span> format (default).
	</ul>
	<li>Example 2: <a href='http://GGGenome.dbcls.jp/mm10/2/GCAAGAGAGATTGCTTAGCG.txt'><!--
		-->http://GGGenome.dbcls.jp/<!--
		--><span style='color:#ff6600'>mm10</span>/<!--
		--><span style='color:#0000ff'>2</span>/<!--
		--><span style='color:#008000'>GCAAGAGAGATTGCTTAGCG</span><!--
		-->.<span style='color:#FF0080'>txt</span><!--
		--></a>
	<ul>
		<li>Search <span style='color:#008000'>GCAAGAGAGATTGCTTAGCG</span> in
		<li>mouse genome <span style='color:#ff6600'>mm10</span>,
		<li>allowing <span style='color:#0000ff'>2</span> mismatches/gaps,
		<li>output in tab-delimited <span style='color:#FF0080'>txt</span> format.
	</ul>
</ul>
</div>

<div>
What's new:
<ul>
	<li>2013-02-12 Silkworm genome is available.
	<li>2013-02-08 English page has launched.
	<li>2013-02-08 Rice genome is available.
	<li>2013-02-06 Source code available via
		<a class=a target='_blank' href='https://github.com/meso-cacase/GGGenome'>GitHub</a>.
	<li>2013-01-16 Database updated to RefSeq rel. 57 (Jan, 2013).
	<li>2012-12-21 GGGenome REST API is available.
	<li>2012-12-21 Rat, <i>Drosophila</i> and <i>C. elegans</i> genomes are available.
	<li>2012-11-15 Database updated to RefSeq rel. 56 (Nov, 2012).
	<li>2012-07-26 Mouse genome is available.
	<li>2012-07-25 Database updated to RefSeq rel. 54 (Jul, 2012).
	<li>2012-07-04 GGGenome launched.
</ul>
</div>" and
#-- △ ++++++++++++++++++++++++++++++++++++++++++++++++++
$title  = 'GGGenome | ultrafast DNA search' and
$robots = '' ;
#- ▲ トップページ：引数がない場合

#- ▼ HTML出力
print
#-- ▽ ++++++++++++++++++++++++++++++++++++++++++++++++++
"Content-type: text/html; charset=utf-8

<!DOCTYPE HTML PUBLIC '-//W3C//DTD HTML 4.01 Transitional//EN'>
<html lang=ja>

<head>
<meta http-equiv='Content-Type' content='text/html; charset=utf-8'>
<meta http-equiv='Content-Style-Type' content='text/css'>
$robots<meta name=author content='Yuki Naito'>
<title>$title</title>
<style type='text/css'>
<!--
	* { font-family:verdana,arial,helvetica,sans-serif }
	p,ol,pre,div,small,cite { font-size:9pt }
	cite { color:#0E774A; font-style:normal }
	a { color:black; font-style:normal }
	em { font-style:normal;
		border:1px solid #00BCFF;
		background-color:#DDF6FF }
	strong { font-style:normal;
		font-weight:bold;
		color:red;
		background-color:#DDF6FF }
	ins,del { font-style:normal;
		font-weight:bold;
		text-decoration:none;
		background-color:pink }
	.position { position:absolute;
		top:-1.2em;
		color:#0E774A;
		font-size:80%;
		user-select:none　}
	.gene { margin:10pt }
	.a { color:#3366CC }
	.t { font-size:10pt; width:90% }
	.b { word-wrap:break-word; width:90% }
	.g { color:gray; width:90% }
	.s { color:silver; width:90% }
-->
</style>
</head>

<body>

<a href='.'><img src='GGGlogo_en.png' alt='GGGenome' height=71 width=257 border=0></a>

<small style='vertical-align:top'>
<a style='vertical-align:top' class=k href='?lang=ja'>Japanese</a>
</small>

<form name=gggenome method=GET action='.'>
<p>
<input type=text name=query size=70 value='$query_string'>
<input type=submit value='Search'>
<select id=db name=db>
$select
</select>
<br>
Max number of mismatches/gaps: <input type=text name=k size=3 value='$k'>
(no more than 20% of the query length)
</p>
</form>

$html

<hr><!-- __________________________________________________ -->

<p class=g>by
<a target='_blank' class=a href='http://twitter.com/meso_cacase'>\@meso_cacase</a> at 
<a target='_blank' class=a href='http://dbcls.rois.ac.jp/'>DBCLS</a><br>
This page is licensed under a
<a target='_blank' class=a href='http://creativecommons.org/licenses/by/2.1/jp/'>
Creative Commons Attribution 2.1 Japan License</a>.</p>

</body>
</html>
" ;
#-- △ ++++++++++++++++++++++++++++++++++++++++++++++++++
#- ▲ HTML出力

return ;
} ;
# ====================
