#!/usr/bin/perl

# GGGenome (ゲゲゲノム)： 塩基配列を高速に検索するサービス
# http://GGGenome.dbcls.jp/
#
# 曖昧検索サーバに問い合わせを行い、結果を HTML, TXT, JSON 形式で出力する
#
# 必要なモジュール：
# HTML::Template
# LWP::Simple
# JSON::XS
# ./Align2seq.pm (by Yuki Naito)
#
# 2012-07-03 Yuki Naito (@meso_cacase) 実装開始
# 2012-11-30 Yuki Naito (@meso_cacase) index.html と search.cgi とを統合
# 2012-12-21 Yuki Naito (@meso_cacase) 出力フォーマットの切り替えに対応
# 2013-02-08 Yuki Naito (@meso_cacase) 英語版HTMLの出力に対応
# 2013-02-22 Yuki Naito (@meso_cacase) URIルーティングを本スクリプトに実装
# 2013-02-25 Yuki Naito (@meso_cacase) 検索結果のダウンロードに対応
# 2013-02-26 Yuki Naito (@meso_cacase) HTMLをテンプレート化

#- ▼ モジュール読み込みと変数の初期化
use warnings ;
use strict ;
use Time::HiRes ;

eval 'use HTML::Template ; 1' or  # HTMLをテンプレート化
	printresult('ERROR : cannot load HTML::Template') ;

eval 'use LWP::Simple ; 1' or     # 曖昧検索サーバとの接続に使用
	printresult('ERROR : cannot load LWP::Simple') ;

eval 'use JSON::XS ; 1' or        # 曖昧検索サーバとの接続に使用
	printresult('ERROR : cannot load JSON::XS') ;

my @timer ;                       # 実行時間計測用
my $timestamp = timestamp() ;     # CGIを実行した時刻
my $min_query_length = 6 ;        # クエリの最低塩基長
my $max_k            = 20 ;       # 許容するミスマッチ/ギャップ数の上限、％
my $max_hit_html     = 50 ;       # 検索を打ち切るヒット数、HTMLの場合
my $max_hit_api      = 10000 ;    # 検索を打ち切るヒット数、TXTまたはJSONの場合

my %db_fullname = (               # データベースの正式名
	'hg19'   => 'Human genome, GRCh37/hg19 (Feb, 2009)',
	'mm10'   => 'Mouse genome, GRCm38/mm10 (Dec, 2011)',
	'rn5'    => 'Rat genome, RGSC 5.0/rn5 (Mar, 2012)',
	'dm3'    => 'Drosophila genome, BDGP Rel. 5/dm3 (Apr, 2006)',
	'ce10'   => 'C. elegans genome, WS220/ce10 (Oct, 2010)',
	'rice'   => 'Rice genome, Os-Nipponbare-Reference-IRGSP-1.0 (Oct, 2011)',
	'bmor1'  => 'Silkworm genome, Bmor1 (Apr, 2008)',
	'refseq' => 'RefSeq complete RNA, release 58 (Mar, 2013)',
	'prok'   => 'Prokaryotic TogoGenome from RefSeq 58 (Mar, 2013)',
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
my $download     = '' ;  # ファイルとしてダウンロードするか: (boolean)
#-- △ 使用するパラメータ一覧

#-- ▽ URIからパラメータを取得
# 例：/en/mm10/2/TTCATTGACAACATTGCGT.txt.download
#
my $request_uri = $ENV{'REQUEST_URI'} // '' ;
$request_uri =~ s/\?.*// ;  # '?' 以降のQUERY_STRING部分を除去

#--- ▽ スラッシュ間 (/param/) のパラメーターを処理
while ($request_uri =~ m{([^/]+)(/?)}g){
	my ($param, $slash) = ($1, $2) ;
	($param =~ /^(ja|en)$/i) ?
		$lang = lc $1 :
	($param =~ /^(hg19|mm10|rn5|dm3|ce10|rice|bmor1|refseq|prok|ddbj)$/i) ?
		$db = lc $1 :
	($param =~ /^(\d+)$/) ?
		$k = $1 :
	(not $slash) ?  # 上記に当てはまらず最後の要素: $query_string へ
		$query_string = $param :
	() ;  # 解釈できないものは無視
}
#--- △ スラッシュ間 (/param/) のパラメーターを処理

#--- ▽ パスの最後の要素 (query.format) を処理
if ($query_string =~ s/(?:\.(html|txt|json)|\.(download))+$//i){
	$1 and $format   = lc $1 ;
	$2 and $download = 'true' ;
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

$download =                           # ファイルとしてダウンロードするか
	($format =~ /^(txt|json)$/) ?     # ダウンロードはtxt,jsonの場合に限る
	$query{'download'} //             # 1) QUERY_STRINGから
	$download //                      # 2) QUERY_STRING未指定 → URIから
	'' :                              # 3) URI未指定 → 空欄
	'' ;                              # txt,json以外 → 空欄
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
$redirect_uri .= $download ? '.download' : '' ;

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
$download ||= '' ;
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
my $db_fullname = $db_fullname{$db} //    # データベースの正式名
                  $db_fullname{'hg19'} ;  # default: Human genome (hg19)
my $port =                                # 曖昧検索サーバのポート
	($db eq 'mm10'  ) ? 42253 :
	($db eq 'rn5'   ) ? 42263 :
	($db eq 'dm3'   ) ? 42273 :
	($db eq 'ce10'  ) ? 42283 :
	($db eq 'rice'  ) ? 42293 :
	($db eq 'bmor1' ) ? 42303 :
	($db eq 'refseq') ? 42243 :
	($db eq 'prok'  ) ? 42323 :
	($db eq 'ddbj'  ) ? 32313 :
	                    42233 ;           # default: Human genome (hg19)
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
	push @summary, "# [ GGGenome | $timestamp ]" ;
	push @summary, "# database:	$db_fullname" ;

	#--- ▽ (+)鎖の検索実行と結果出力
	($hits, $uri) = approx_q(uc(rna2dna($queryseq)), $port, $k, $limit) or
		printresult('ERROR : searcher error') ;

	push @timer, [Time::HiRes::time(), "search_plus_done; $uri"] ;   #===== 実行時間計測 =====

	foreach (@{$hits->{hits}}){
		push @hit_list, show_hit_txt($_, '+') ;
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
		push @hit_list, show_hit_txt($_, '-') ;
	}

	# ヒット数を出力、予測値の場合は有効2桁で先頭に'>'を付加
	$hit_num    = $hits->{total_hit_num}           // '' ;
	$hit_approx = $hits->{total_hit_num_is_approx} // '' ;
	$hit_approx and $hit_num =~ s/^(\d{2})(\d*)/'>' . $1 . 0 x length($2)/e ;

	push @summary, "# query:	$queryseq" ;
	push @summary, "# count:	$hit_num" ;
	#--- △ (-)鎖の検索実行と結果出力

	push @summary, '# name	strand	start	end	snippet	snippet_pos	snippet_end' ;
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
		push @hit_list, @{ show_hit_json($_, '+') } ;
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
		push @hit_list, @{ show_hit_json($_, '-') } ;
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

	my $json_result = JSON::XS->new->canonical->utf8->encode({
		time     => $timestamp,
		database => $db_fullname,
		summary  => \@summary,
		results  => \@hit_list,
		error    => 'none'
	}) ;
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
	my $last_time  = $start_time ;  # 初期値
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

	my $template_search_file = ($lang eq 'ja') ?
	                           'template/search_ja.tmpl' :  # Japanese HTML
	                           'template/search_en.tmpl' ;  # default: English HTML

	my $template_search = HTML::Template->new(filename => $template_search_file) ;

	$" = "\n" ;
	$template_search->param(
		TIMESTAMP    => $timestamp,
		DB_FULLNAME  => $db_fullname,
		SUMMARY      => "@summary",
		MAX_HIT_HTML => $max_hit_html,
		HIT_LIST     => "@hit_list",
		MAX_HIT_API  => $max_hit_api,
		HTTP_HOST    => $ENV{'HTTP_HOST'},
		REQUEST_URI  => $request_uri,
		REDIRECT_URI => $redirect_uri,
		LANG         => $lang,
		DB           => $db,
		K            => $k,
		QUERY        => $query_string,
		FORMAT       => $format,
		DOWNLOAD     => $download,
		TIMELOG      => "@timelog"
	) ;

	($lang eq 'ja') ? print_html_ja($template_search->output) :  # Japanese HTML
	                  print_html_en($template_search->output) ;  # default: English HTML
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
		$query{lc($name)} = $value ;
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
my $gene   = $_[0] or return '' ;
my $strand = $_[1] // '' ;

my $name        = $gene->{docname}     // '' ;
my $length      = $gene->{length}      // '' ;
my $position    = $gene->{pos}         // '' ;
my $snippet     = $gene->{snippet}     // '' ;
my $snippet_pos = $gene->{snippet_pos} // '' ;

my $position_end = ($position and $length) ?
                   $position + $length - 1 :
                   '' ;
my $snippet_end  = ($snippet_pos and $snippet) ?
                   $snippet_pos + length($snippet) - 1 :
                   '' ;

$name =~ s/^>// ;

return join "\t", (
	$name,
	$strand,
	$position,
	$position_end,
	$snippet,
	$snippet_pos,
	$snippet_end
) ;
} ;
# ====================
sub show_hit_json {  # ヒットした遺伝子をJSONで出力
my $gene   = $_[0] or return '' ;
my $strand = $_[1] // '' ;

my $name        = $gene->{docname}     // '' ;
my $length      = $gene->{length}      // '' ;
my $position    = $gene->{pos}         // '' ;
my $snippet     = $gene->{snippet}     // '' ;
my $snippet_pos = $gene->{snippet_pos} // '' ;

my $position_end = ($position and $length) ?
                   $position + $length - 1 :
                   '' ;
my $snippet_end  = ($snippet_pos and $snippet) ?
                   $snippet_pos + length($snippet) - 1 :
                   '' ;

$name =~ s/^>// ;

return [{
	name         => $name,
	strand       => $strand,
	position     => $position,
	position_end => $position_end,
	snippet      => $snippet,
	snippet_pos  => $snippet_pos,
	snippet_end  => $snippet_end
}] ;
} ;
# ====================
sub show_hit_html {  # ヒットした遺伝子をHTMLで出力
my $gene = $_[0] or return '' ;

my $name        = $gene->{docname}     // '' ;
my $length      = $gene->{length}      // '' ;
my $position    = $gene->{pos}         // '' ;
my $snippet     = $gene->{snippet}     // '' ;
my $snippet_pos = $gene->{snippet_pos} // '' ;

my $position_end = ($position and $length) ?
                   $position + $length - 1 :
                   '' ;

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
	"<span class=position>&#9660;$position</span>" .
	"$align</em>$snippet_3prime" ;

$name =~ s/^>// ;

return
"<div class=gene><!-- ==================== -->
	<div class=t>
	@{[ link_seqname($name, $position, $position_end, $db) ]}
	</div>
	<div class=b>
	$snippet_html
	</div>
</div>" ;
} ;
# ====================
sub link_seqname {  # 配列名やヒット位置の情報を整形、NCBIやUCSCへのリンクを設定
my $name    = $_[0] // '' ;
my $pos     = $_[1] // '' ;
my $pos_end = $_[2] // '' ;
my $db      = $_[3] // '' ;

($db =~ /^(hg19|mm10|rn5|dm3|ce10)$/) ?
	return "<a class=a target='_blank' href='" .
	       "http://genome.ucsc.edu/cgi-bin/hgTracks?" .
	       "db=$1&position=$name%3A$pos-$pos_end'>$name:$pos-$pos_end</a>" :
($db eq 'refseq' and $name =~ /^gi\|\d+\|ref\|(.*?)\|(.*)$/) ?
	return "<a class=a target='_blank' href=" .
	       "http://www.ncbi.nlm.nih.gov/nuccore/$1>$2</a><br>\n" .
	       "<font color='#0E774A'>$1</font>:$pos-$pos_end" :
($db eq 'prok' and $name =~ /^rs:(\S+)\s+(.*?)\s*\{((?:.*)refseq:"(.*?)"(?:.*))\}$/) ?
	return "<a class=a target='_blank' href=" .
	       "http://www.ncbi.nlm.nih.gov/nuccore/$4>$2</a><br>\n" .
	       "<span class=g>$3</span><br>" .
	       "<font color='#0E774A'>$4</font>:$pos-$pos_end" :
($db eq 'ddbj' and $name =~ /^.*?\|(\S+)\s+(.*)$/) ?
	return "<a class=a target='_blank' href=" .
	       "http://www.ncbi.nlm.nih.gov/nuccore/$1>$2</a><br>\n" .
	       "<font color='#0E774A'>$1</font>:$pos-$pos_end" :
# それ以外の場合 (rice, bmor1)
	return "$name<br>$pos-$pos_end\n" ;
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
# ・引数がない場合 → ERROR : query is empty
#- ▲ メモ

my $txt = $_[0] // '' ;

#- ▼ 検索結果を出力：default
# 引数をそのまま出力するので何もしなくてよい
#- ▲ 検索結果を出力：default

#- ▼ 引数がない場合 → ERROR : query is empty
(not $txt) and $txt = 'ERROR : query is empty' ;
#- ▲ 引数がない場合 → ERROR : query is empty

#- ▼ エラーを出力：引数が ERROR で始まる場合
$txt =~ s/^(ERROR.*)$/### $1 ###/s ;
#- ▲ エラーを出力：引数が ERROR で始まる場合

#- ▼ TXT出力
print "Content-type: text/plain; charset=utf-8\n" ;
$download and  # ファイルとしてダウンロードする場合
	print "Content-Disposition: attachment; filename=gggenome_result.txt\n" ;
print "\n" ;
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
print "Content-type: application/json; charset=utf-8\n" ;
$download and  # ファイルとしてダウンロードする場合
	print "Content-Disposition: attachment; filename=gggenome_result.json\n" ;
print "\n" ;
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
"	<option value=hg19  >$db_fullname{'hg19'  }</option>
	<option value=mm10  >$db_fullname{'mm10'  }</option>
	<option value=rn5   >$db_fullname{'rn5'   }</option>
	<option value=dm3   >$db_fullname{'dm3'   }</option>
	<option value=ce10  >$db_fullname{'ce10'  }</option>
	<option value=rice  >$db_fullname{'rice'  }</option>
	<option value=bmor1 >$db_fullname{'bmor1' }</option>
	<option disabled>----------</option>
	<option value=refseq>$db_fullname{'refseq'}</option>
	<option value=prok  >$db_fullname{'prok'  }</option>
	<option value=ddbj  >$db_fullname{'ddbj'  }</option>" ;
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
my $template_top = HTML::Template->new(filename => 'template/top_ja.tmpl') ;

$template_top->param(
	MAX_HIT_HTML => $max_hit_html,
	MAX_HIT_API  => $max_hit_api
) ;

(not $html) and
$html   = $template_top->output and
$title  = '超絶高速ゲノム配列検索GGGenome' and
$robots = '' ;
#- ▲ トップページ：引数がない場合

#- ▼ HTML出力
my $template_index = HTML::Template->new(filename => 'template/index_ja.tmpl') ;

$template_index->param(
	ROBOTS => $robots,
	TITLE  => $title,
	QUERY  => $query_string,
	SELECT => $select,
	K      => $k,
	HTML   => $html
) ;

print "Content-type: text/html; charset=utf-8\n\n" ;
print $template_index->output ;
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
"	<option value=hg19  >$db_fullname{'hg19'  }</option>
	<option value=mm10  >$db_fullname{'mm10'  }</option>
	<option value=rn5   >$db_fullname{'rn5'   }</option>
	<option value=dm3   >$db_fullname{'dm3'   }</option>
	<option value=ce10  >$db_fullname{'ce10'  }</option>
	<option value=rice  >$db_fullname{'rice'  }</option>
	<option value=bmor1 >$db_fullname{'bmor1' }</option>
	<option disabled>----------</option>
	<option value=refseq>$db_fullname{'refseq'}</option>
	<option value=prok  >$db_fullname{'prok'  }</option>
	<option value=ddbj  >$db_fullname{'ddbj'  }</option>" ;
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
my $template_top = HTML::Template->new(filename => 'template/top_en.tmpl') ;

$template_top->param(
	MAX_HIT_HTML => $max_hit_html,
	MAX_HIT_API  => $max_hit_api
) ;

(not $html) and
$html   = $template_top->output and
$title  = 'GGGenome | ultrafast DNA search' and
$robots = '' ;
#- ▲ トップページ：引数がない場合

#- ▼ HTML出力
my $template_index = HTML::Template->new(filename => 'template/index_en.tmpl') ;

$template_index->param(
	ROBOTS => $robots,
	TITLE  => $title,
	QUERY  => $query_string,
	SELECT => $select,
	K      => $k,
	HTML   => $html
) ;

print "Content-type: text/html; charset=utf-8\n\n" ;
print $template_index->output ;
#- ▲ HTML出力

return ;
} ;
# ====================
