#!/usr/bin/perl

# GGGenome (ゲゲゲノム)： 塩基配列を高速に検索するサービス
# http://GGGenome.dbcls.jp/
#
# 曖昧検索サーバに問い合わせを行い、結果を HTML, TXT, JSON 等の形式で出力する
#
# 必要なモジュール：
# HTML::Template
# ./Approx.pm    (by Yuki Naito)
# ./DBlist.pm    (by Yuki Naito)
#   LWP::Simple  (Approx.pm内で使用)
#   JSON::XS     (Approx.pm内で使用)
# ./Align2seq.pm (by Yuki Naito)
#
# 2012-07-03 Yuki Naito (@meso_cacase) 実装開始
# 2012-11-30 Yuki Naito (@meso_cacase) index.html と search.cgi とを統合
# 2012-12-21 Yuki Naito (@meso_cacase) 出力フォーマットの切り替えに対応
# 2013-02-08 Yuki Naito (@meso_cacase) 英語版HTMLの出力に対応
# 2013-02-22 Yuki Naito (@meso_cacase) URIルーティングを本スクリプトに実装
# 2013-02-25 Yuki Naito (@meso_cacase) 検索結果のダウンロードに対応
# 2013-02-26 Yuki Naito (@meso_cacase) HTMLをテンプレート化
# 2013-08-16 Yuki Naito (@meso_cacase) 曖昧検索サーバへの問い合わせをモジュール化

#- ▼ モジュール読み込みと変数の初期化
use warnings ;
use strict ;
use Time::HiRes ;

eval 'use HTML::Template ; 1' or  # HTMLをテンプレート化
	printresult('ERROR : cannot load HTML::Template') ;

eval 'use Approx ; 1' or          # 曖昧検索サーバに問い合わせを行うためのモジュール
	printresult('ERROR : cannot load Approx') ;

eval 'use DBlist ; 1' or          # 曖昧検索データベースの正式名およびホスト名/ポート番号の一覧
	printresult('ERROR : cannot load DBlist') ;

my @timer ;                       # 実行時間計測用
my $timestamp = timestamp() ;     # CGIを実行した時刻
my $min_query_length = 6 ;        # クエリの最低塩基長
my $max_k            = 25 ;       # 許容するミスマッチ/ギャップ数の上限、％
my $max_hit_html     = 50 ;       # 検索を打ち切るヒット数、HTMLの場合
my $max_hit_api      = 100000 ;   # 検索を打ち切るヒット数、TXT,CSV,BED,GFF,JSONの場合
my $timeout          = 20 ;       # タイムアウト時間、秒

my $dbconf = $DBlist::dbconf ;    # データベースの正式名およびホスト名/ポート番号のリスト

my %host ;
my %port ;
my %db_fullname ;
foreach (split /\n/, $dbconf){
	chomp ;
	map {$_ =~ s/\s*$//g}         # 後方のスペースを除去
		my ($db, $host, $port, $fullname) = split /\t/ ;
	$host{$db}        = $host ;
	$port{$db}        = $port ;
	$db_fullname{$db} = $fullname ;
}
#- ▲ モジュール読み込みと変数の初期化

#- ▼ リクエストからパラメータを取得
push @timer, [Time::HiRes::time(), 'start;'] ;                       #===== 実行時間計測 =====

#-- ▽ 使用するパラメータ一覧
my $lang         = '' ;  # HTMLの場合の日本語/英語: ja, en
my $db           = '' ;  # 生物種 (データベース): hg19, mm10, ...
my $k            = '' ;  # 許容するミスマッチ/ギャップの数: 0, 1, 2, ...
my $query_string = '' ;  # 塩基配列
my $format       = '' ;  # 出力フォーマット: html, txt, csv, bed, gff, json
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
	($param =~ /^(hg19|mm10|rn5|calJac3|susScr3|galGal4|xenTro3|Xenla7|danRer7|ci2|dm3|ce10|
	              TAIR10|rice|sorBic|bmor1|sacCer3|pombe|refseq|hs_refseq|mm_refseq|prok|ddbj)$/xi) ?
		$db = lc $1 :
	($param =~ /^(\d+)$/) ?
		$k = $1 :
	(not $slash) ?  # 上記に当てはまらず最後の要素: $query_string へ
		$query_string = $param :
	() ;  # 解釈できないものは無視
}
#--- △ スラッシュ間 (/param/) のパラメーターを処理

#--- ▽ パスの最後の要素 (query.format) を処理
if ($query_string =~ s/(?:\.(html|txt|csv|bed|gff|json)|\.(download))+$//i){
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
$db =~ s/calJac3/calJac3/i ;          # 大文字小文字を正規化
$db =~ s/susScr3/susScr3/i ;          # 大文字小文字を正規化
$db =~ s/galGal4/galGal4/i ;          # 大文字小文字を正規化
$db =~ s/xenTro3/xenTro3/i ;          # 大文字小文字を正規化
$db =~ s/Xenla7/Xenla7/i ;            # 大文字小文字を正規化
$db =~ s/danRer7/danRer7/i ;          # 大文字小文字を正規化
$db =~ s/TAIR10/TAIR10/i ;            # 大文字小文字を正規化
$db =~ s/sorBic/sorBic/i ;            # 大文字小文字を正規化
$db =~ s/sacCer3/sacCer3/i ;          # 大文字小文字を正規化

$k =                                  # 許容するミスマッチ/ギャップの数
	(defined $query{'k'} and $query{'k'} =~ /^\d+$/) ?
	$query{'k'} :                     # 1) QUERY_STRINGから
	$k //                             # 2) QUERY_STRING未指定 → URIから
	'' ;                              # 3) URI未指定 → 空欄

$format =                             # 出力フォーマット
	(defined $query{'format'} and $query{'format'} =~ /^(html|txt|csv|bed|gff|json)?$/i) ?
	lc($query{'format'}) :            # 1) QUERY_STRINGから
	$format //                        # 2) QUERY_STRING未指定 → URIから
	'' ;                              # 3) URI未指定 → 空欄

$download =                           # ファイルとしてダウンロードするか
	($format =~ /^(txt|csv|bed|gff|json)$/) ?  # ダウンロードはtxt,csv,bed,gff,jsonの場合に限る
	$query{'download'} //             # 1) QUERY_STRINGから
	$download //                      # 2) QUERY_STRING未指定 → URIから
	'' :                              # 3) URI未指定 → 空欄
	'' ;                              # txt,csv,bed,gff,json以外 → 空欄
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
#- ▽ タイムアウト処理を行う部分
eval {
	local $SIG{ALRM} = sub { die } ;
	alarm $timeout ;

#-- ▽ 生物種 $db により切り替えるパラメータ
my $db_fullname = $db_fullname{$db} //    # データベースの正式名
                  $db_fullname{'hg19'} ;  # default: Human genome (hg19)
my $host        = $host{$db} //           # 曖昧検索サーバ
                  $host{'hg19'} ;         # default: Human genome (hg19)
my $port        = $port{$db} //           # 曖昧検索サーバのポート
                  $port{'hg19'} ;         # default: Human genome (hg19)
#-- △ 生物種 $db により切り替えるパラメータ

push @timer, [Time::HiRes::time(), 'search_start;'] ;                #===== 実行時間計測 =====

my $hits ;        # 曖昧検索サーバから取得したJSON形式の結果
my $uri ;         # 曖昧検索サーバへのリクエストURI
my $hit_num ;     # ヒット件数
my $hit_approx ;  # ヒット件数が概算かどうか
my $ds_hit_num ;  # 両鎖のヒット件数の合計
my $ds_approx ;   # 両鎖のヒット件数が概算かどうか
my @summary ;     # 検索結果のヘッダ情報 (データベース名、ヒット件数など)
my @hit_list ;    # 検索結果のリスト

#-- ▽ TXT(タブ区切りテキスト)形式
if ($format eq 'txt'){
	my $limit = $max_hit_api ;  # 検索を打ち切るヒット数
	push @summary, "# [ GGGenome | $timestamp ]" ;
	push @summary, "# database:	$db_fullname" ;

	#--- ▽ (+)鎖の検索実行と結果出力
	($hits, $uri) = Approx::approx_q(uc(rna2dna($queryseq)), $host, $port, $k, $limit) or
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
	($hits, $uri) = Approx::approx_q(uc(rna2dna($queryseq)), $host, $port, $k, $limit) or
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

#-- ▽ CSV形式
} elsif ($format eq 'csv'){
	my $limit = $max_hit_api ;  # 検索を打ち切るヒット数
	push @summary, "# [ GGGenome | $timestamp ]" ;
	push @summary, "# database,\"$db_fullname\"" ;

	#--- ▽ (+)鎖の検索実行と結果出力
	($hits, $uri) = Approx::approx_q(uc(rna2dna($queryseq)), $host, $port, $k, $limit) or
		printresult('ERROR : searcher error') ;

	push @timer, [Time::HiRes::time(), "search_plus_done; $uri"] ;   #===== 実行時間計測 =====

	foreach (@{$hits->{hits}}){
		push @hit_list, show_hit_csv($_, '+') ;
	}

	# ヒット数を出力、予測値の場合は有効2桁で先頭に'>'を付加
	$hit_num    = $hits->{total_hit_num}           // '' ;
	$hit_approx = $hits->{total_hit_num_is_approx} // '' ;
	$hit_approx and $hit_num =~ s/^(\d{2})(\d*)/'>' . $1 . 0 x length($2)/e ;

	push @summary, "# query,$queryseq" ;
	push @summary, "# count,$hit_num" ;
	#--- △ (+)鎖の検索実行と結果出力

	#--- ▽ (-)鎖の検索実行と結果出力
	$queryseq = comp($queryseq) ;
	($hits, $uri) = Approx::approx_q(uc(rna2dna($queryseq)), $host, $port, $k, $limit) or
		printresult('ERROR : searcher error') ;

	push @timer, [Time::HiRes::time(), "search_minus_done; $uri"] ;  #===== 実行時間計測 =====

	foreach (@{$hits->{hits}}){
		push @hit_list, show_hit_csv($_, '-') ;
	}

	# ヒット数を出力、予測値の場合は有効2桁で先頭に'>'を付加
	$hit_num    = $hits->{total_hit_num}           // '' ;
	$hit_approx = $hits->{total_hit_num_is_approx} // '' ;
	$hit_approx and $hit_num =~ s/^(\d{2})(\d*)/'>' . $1 . 0 x length($2)/e ;

	push @summary, "# query,$queryseq" ;
	push @summary, "# count,$hit_num" ;
	#--- △ (-)鎖の検索実行と結果出力

	push @summary, '# name,strand,start,end,snippet,snippet_pos,snippet_end' ;
	@hit_list or push @hit_list, '### No items found. ###' ;  # ヒットがゼロ件
	print_txt(join "\n", (@summary, @hit_list)) ;
#-- △ CSV形式

#-- ▽ BED形式
} elsif ($format eq 'bed'){
	my $limit = $max_hit_api ;  # 検索を打ち切るヒット数
	push @summary, "track name=GGGenome description=\"GGGenome matches\"" ;

	#--- ▽ (+)鎖の検索実行と結果出力
	($hits, $uri) = Approx::approx_q(uc(rna2dna($queryseq)), $host, $port, $k, $limit) or
		printresult('ERROR : searcher error') ;

	push @timer, [Time::HiRes::time(), "search_plus_done; $uri"] ;   #===== 実行時間計測 =====

	foreach (@{$hits->{hits}}){
		push @hit_list, show_hit_bed($_, '+') ;
	}
	#--- △ (+)鎖の検索実行と結果出力

	#--- ▽ (-)鎖の検索実行と結果出力
	$queryseq = comp($queryseq) ;
	($hits, $uri) = Approx::approx_q(uc(rna2dna($queryseq)), $host, $port, $k, $limit) or
		printresult('ERROR : searcher error') ;

	push @timer, [Time::HiRes::time(), "search_minus_done; $uri"] ;  #===== 実行時間計測 =====

	foreach (@{$hits->{hits}}){
		push @hit_list, show_hit_bed($_, '-') ;
	}
	#--- △ (-)鎖の検索実行と結果出力

	@hit_list or push @hit_list, '### No items found. ###' ;  # ヒットがゼロ件
	print_txt(join "\n", (@summary, @hit_list)) ;
#-- △ BED形式

#-- ▽ GFF形式
} elsif ($format eq 'gff'){
	my $limit = $max_hit_api ;  # 検索を打ち切るヒット数
	push @summary, "##gff-version 3" ;
	push @summary, "##source-version GGGenome v1" ;
	push @summary, "track name=GGGenome description=\"GGGenome matches\"" ;

	#--- ▽ (+)鎖の検索実行と結果出力
	($hits, $uri) = Approx::approx_q(uc(rna2dna($queryseq)), $host, $port, $k, $limit) or
		printresult('ERROR : searcher error') ;

	push @timer, [Time::HiRes::time(), "search_plus_done; $uri"] ;   #===== 実行時間計測 =====

	foreach (@{$hits->{hits}}){
		push @hit_list, show_hit_gff($_, '+') ;
	}
	#--- △ (+)鎖の検索実行と結果出力

	#--- ▽ (-)鎖の検索実行と結果出力
	$queryseq = comp($queryseq) ;
	($hits, $uri) = Approx::approx_q(uc(rna2dna($queryseq)), $host, $port, $k, $limit) or
		printresult('ERROR : searcher error') ;

	push @timer, [Time::HiRes::time(), "search_minus_done; $uri"] ;  #===== 実行時間計測 =====

	foreach (@{$hits->{hits}}){
		push @hit_list, show_hit_gff($_, '-') ;
	}
	#--- △ (-)鎖の検索実行と結果出力

	@hit_list or push @hit_list, '### No items found. ###' ;  # ヒットがゼロ件
	print_txt(join "\n", (@summary, @hit_list)) ;
#-- △ GFF形式

#-- ▽ JSON形式
} elsif ($format eq 'json'){
	my $limit = $max_hit_api ;  # 検索を打ち切るヒット数

	#--- ▽ (+)鎖の検索実行と結果出力
	($hits, $uri) = Approx::approx_q(uc(rna2dna($queryseq)), $host, $port, $k, $limit) or
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
	($hits, $uri) = Approx::approx_q(uc(rna2dna($queryseq)), $host, $port, $k, $limit) or
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
	($hits, $uri) = Approx::approx_q(uc(rna2dna($queryseq)), $host, $port, $k, $limit) or
		printresult('ERROR : searcher error') ;

	push @timer, [Time::HiRes::time(), "search_plus_done; $uri"] ;   #===== 実行時間計測 =====

	foreach (@{$hits->{hits}}){
		push @hit_list, show_hit_html($_) ;
	}

	# ヒット数を出力、予測値の場合は有効2桁で先頭に'>'を付加
	$hit_num    = $hits->{total_hit_num}           // '' ;
	$hit_approx = $hits->{total_hit_num_is_approx} // '' ;
	$ds_hit_num += $hit_num ;
	$hit_approx and $hit_num =~ s/^(\d{2})(\d*)/'&gt;' . $1 . 0 x length($2)/e ;
	$hit_approx and $ds_approx = 1 ;

	push @summary,
		"	<li><a href='./?query=$queryseq&amp;db=$db&amp;k=$k'>" . "\n" .
		"		<span class=mono>$queryseq</span> ($hit_num)</a>" ;
	#--- △ (+)鎖の検索実行と結果出力

	#--- ▽ (-)鎖の検索実行と結果出力
	$queryseq = comp($queryseq) ;
	($hits, $uri) = Approx::approx_q(uc(rna2dna($queryseq)), $host, $port, $k, $limit) or
		printresult('ERROR : searcher error') ;

	push @timer, [Time::HiRes::time(), "search_minus_done; $uri"] ;  #===== 実行時間計測 =====

	foreach (@{$hits->{hits}}){
		push @hit_list, show_hit_html($_) ;
	}

	# ヒット数を出力、予測値の場合は有効2桁で先頭に'>'を付加
	$hit_num    = $hits->{total_hit_num}           // '' ;
	$hit_approx = $hits->{total_hit_num_is_approx} // '' ;
	$ds_hit_num += $hit_num ;
	$hit_approx and $hit_num =~ s/^(\d{2})(\d*)/'&gt;' . $1 . 0 x length($2)/e ;
	$hit_approx and $ds_approx = 1 ;

	push @summary,
		"	<li><a href='./?query=$queryseq&amp;db=$db&amp;k=$k'>" . "\n" .
		"		<span class=mono>$queryseq</span> ($hit_num)</a>" ;
	#--- △ (-)鎖の検索実行と結果出力

	#--- ▽ 両鎖の合計数を出力
	$ds_approx and $ds_hit_num =~ s/^(\d{2})(\d*)/'&gt;' . $1 . 0 x length($2)/e ;
	push @summary,
		"	<li><font color=maroon><b>TOTAL ($ds_hit_num)</b></font>" ;
	#--- △ 両鎖の合計数を出力

	@hit_list or
		push @hit_list, '<div class=gene><p>No items found.</p></div>' ;  # ヒットがゼロ件

	#--- ▽ TXT/CSV/BED/GFF/JSON出力のbase URIを生成
	my $linkbase_uri = '/' ;
	$linkbase_uri .= ($request_uri =~ m{^/test/}) ? 'test/' : '' ;  # テストページ /test/ 対応
	$linkbase_uri .= $db ? "$db/" : '' ;
	$linkbase_uri .= $k  ? "$k/"  : '' ;  # 値が 0 の場合は /0/ を省略
	$linkbase_uri .= $query_string ;
	#--- △ TXT/CSV/BED/GFF/JSON出力のbase URIを生成

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
		LINKBASE_URI => $linkbase_uri,
		HTTP_HOST    => $ENV{'HTTP_HOST'},
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

	alarm 0 ;
} ;
#- △ タイムアウト処理を行う部分

# タイムアウトの有無をチェック
$@ and printresult("ERROR : searcher timed out") ;
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
my $seq = $_[0] or return '' ;
$seq =~ s/[^ATGCUNRYMKSWHBVD-]//gi ;
return $seq ;
} ;
# ====================
sub rna2dna {  # 塩基配列中のUをTに置換
my $seq = $_[0] or return '' ;
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
sub show_hit_csv {  # ヒットした遺伝子をCSV形式で出力
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

return join ',', (
	"\"$name\"",
	$strand,
	$position,
	$position_end,
	$snippet,
	$snippet_pos,
	$snippet_end
) ;
} ;
# ====================
sub show_hit_bed {  # ヒットした遺伝子をBED形式で出力
my $gene   = $_[0] or return '' ;
my $strand = $_[1] // '' ;

my $name        = $gene->{docname}     // '' ;
my $length      = $gene->{length}      // '' ;
my $position    = $gene->{pos}         // '' ;

my $position_end = ($position and $length) ?
                   $position + $length - 1 :
                   '' ;

$name =~ s/^>// ;
$position -- ;      # BEDの座標は0-basedのため変換
$position_end -- ;  # BEDの座標は0-basedのため変換

return join "\t", (
	$name,
	$position,
	$position_end,
	'.',
	0,
	$strand,
) ;
} ;
# ====================
sub show_hit_gff {  # ヒットした遺伝子をGFF形式で出力
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
	'GGGenome',
	'match',
	$position,
	$position_end,
	'.',
	$strand,
	'.',
	"snippet=$snippet;"         .
	"snippet_pos=$snippet_pos;" .
	"snippet_end=$snippet_end"
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

return [
	parse_seqname_json({
		name         => $name,
		strand       => $strand,
		position     => $position,
		position_end => $position_end,
		snippet      => $snippet,
		snippet_pos  => $snippet_pos,
		snippet_end  => $snippet_end
	})
] ;
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
	$snippet_5prime                         .
	'<em style="position:relative">'        .
	'<span class=pointer></span>'           .
	"<span class=position>$position</span>" .
	"$align</em>$snippet_3prime" ;

$name =~ s/^>// ;

return
"<div class=gene><!-- ==================== -->
	<div class=t>
	@{[ link_seqname($name, $position, $position_end, $db) ]}
	</div>
	<div class='b mono'>
	$snippet_html
	</div>
</div>" ;
} ;
# ====================
sub parse_seqname_json {  # 配列名に含まれるtaxonomy ID等をJSONに展開
my $json = $_[0] or return $_[0] ;
if ($db eq 'prok' and $json->{name} =~ s/^(.*?)\s*\{(.*)\}/$1/){
	foreach (split /,/, $2){
		$_ =~ /taxonomy:\"(.*?)\"/   and $json->{taxonomy}   = $1 +0 ;  # 数値化
		$_ =~ /bioproject:\"(.*?)\"/ and $json->{bioproject} = $1 ;
		$_ =~ /refseq:\"(.*?)\"/     and $json->{refseq}     = $1 ;
	}
}
return $json ;
} ;
# ====================
sub link_seqname {  # 配列名やヒット位置の情報を整形、NCBIやUCSCへのリンクを設定
my $name    = $_[0] // '' ;
my $pos     = $_[1] // '' ;
my $pos_end = $_[2] // '' ;
my $db      = $_[3] // '' ;

($db =~ /^(hg19|mm10|rn5|calJac3|susScr3|galGal4|xenTro3|danRer7|ci2|dm3|ce10|sacCer3)$/) ?
	return "<a class=a target='_blank' href='" .
	       "http://genome.ucsc.edu/cgi-bin/hgTracks?" .
	       "db=$1&position=$name%3A$pos-$pos_end'>$name:$pos-$pos_end</a>" :
($db eq 'Xenla7') ?
	return "<a class=a target='_blank' href='" .
	       "http://gbrowse.xenbase.org/fgb2/gbrowse/xl7_1/?" .
	       "name=$name%3A$pos..$pos_end'>$name:<br>$pos-$pos_end</a>" :
($db eq 'TAIR10' and $name =~ s/\s*CHROMOSOME dumped from.*// and
	eval '$name =~ s/^chloroplast$/ChrC/ ; $name =~ s/^mitochondria$/ChrM/ ; 1') ?
	# GBrowseにリンクするため chloroplast → ChrC, mitochondria → ChrM に置換
	return "<a class=a target='_blank' href='" .
	       "https://urgi.versailles.inra.fr/gb2/gbrowse/tairv10_pub/?" .
	       "name=$name%3A$pos..$pos_end'>$name:$pos-$pos_end</a>" :
($db eq 'rice') ?
	($name =~ /^chr\d\d$/) ?  # chrで始まるもののみGBrowseにリンク
		return "<a class=a target='_blank' href='" .
		       "http://rapdb.dna.affrc.go.jp/viewer/gbrowse/irgsp1/?" .
		       "name=$name%3A$pos..$pos_end'>$name:$pos-$pos_end</a>" :
		return "$name:$pos-$pos_end" :
($db eq 'sorBic') ?
	return "<a class=a target='_blank' href='" .
	       "http://www.phytozome.net/cgi-bin/gbrowse/sorghum_er/?" .
	       "version=100;name=$name%3A$pos..$pos_end'>$name:$pos-$pos_end</a>" :
($db eq 'pombe') ?
	return "<a class=a target='_blank' href='" .
	       "http://genomebrowser.pombase.org/Schizosaccharomyces_pombe/Location/View?" .
	       "r=$name%3A$pos-$pos_end'>$name:$pos-$pos_end</a>" :
($db =~ /^(hs_|mm_)?refseq$/ and $name =~ /^gi\|\d+\|ref\|(.*?)\|(.*)$/) ?
	return "<a class=a target='_blank' href=" .
	       "http://www.ncbi.nlm.nih.gov/nuccore/$1>$2</a><br>\n" .
	       "<font color='#0E774A'>$1</font>:$pos-$pos_end" :
($db eq 'prok' and $name =~ /^(.*?)\s*\{((?:.*)refseq:"(.*?)"(?:.*))\}$/) ?
	return "<a class=a target='_blank' href=" .
	       "http://www.ncbi.nlm.nih.gov/nuccore/$3>$1</a><br>\n" .
	       "<span class=g>$2</span><br>" .
	       "<font color='#0E774A'>$3</font>:$pos-$pos_end" :
($db eq 'ddbj' and $name =~ /^.*?\|(\S+)\s+(.*)$/) ?
	return "<a class=a target='_blank' href=" .
	       "http://www.ncbi.nlm.nih.gov/nuccore/$1>$2</a><br>\n" .
	       "<font color='#0E774A'>$1</font>:$pos-$pos_end" :
# それ以外の場合 (bmor1)
	return "$name<br>$pos-$pos_end\n" ;
} ;
# ====================
sub escape_char {  # < > & ' " の5文字を実態参照に変換
my $str = $_[0] // '' ;
$str =~ s/\&/&amp;/g ;
$str =~ s/</&lt;/g ;
$str =~ s/>/&gt;/g ;
$str =~ s/\'/&apos;/g ;
$str =~ s/\"/&quot;/g ;
return $str ;
} ;
# ====================
sub printresult {  # $format (global) にあわせて結果を出力
($format =~ /^(txt|csv|bed|gff)$/) ? print_txt($_[0]) :
($format eq 'json') ? print_json($_[0])    :
($lang   eq 'ja'  ) ? print_html_ja($_[0]) :  # default format: html
                      print_html_en($_[0]) ;  # default lang  : en
exit ;
} ;
# ====================
sub print_txt {  # TXTを出力

#- ▼ メモ
# ・検索結果をタブ区切りテキストで出力
# ・CSV, BED, GFFの場合もこれに準ずる
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
#- ▽ ファイルとしてダウンロードする場合
($download and $format eq 'txt') ?
	print "Content-Disposition: attachment; filename=gggenome_result.txt\n" :
($download and $format eq 'csv') ?
	print "Content-Disposition: attachment; filename=gggenome_result.csv\n" :
($download and $format eq 'bed') ?
	print "Content-Disposition: attachment; filename=gggenome_result.bed\n" :
($download and $format eq 'gff') ?
	print "Content-Disposition: attachment; filename=gggenome_result.gff\n" :
() ;
#- △ ファイルとしてダウンロードする場合
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
print "Content-Disposition: attachment; filename=gggenome_result.json\n"
	if $download ;  # ファイルとしてダウンロードする場合
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
"	<option value=hg19     >$db_fullname{'hg19'     }</option>
	<option value=mm10     >$db_fullname{'mm10'     }</option>
	<option value=rn5      >$db_fullname{'rn5'      }</option>
	<option value=calJac3  >$db_fullname{'calJac3'  }</option>
	<option value=susScr3  >$db_fullname{'susScr3'  }</option>
	<option value=galGal4  >$db_fullname{'galGal4'  }</option>
	<option value=xenTro3  >$db_fullname{'xenTro3'  }</option>
	<option value=Xenla7   >$db_fullname{'Xenla7'   }</option>
	<option value=danRer7  >$db_fullname{'danRer7'  }</option>
	<option value=ci2      >$db_fullname{'ci2'      }</option>
	<option value=dm3      >$db_fullname{'dm3'      }</option>
	<option value=ce10     >$db_fullname{'ce10'     }</option>
	<option value=TAIR10   >$db_fullname{'TAIR10'   }</option>
	<option value=rice     >$db_fullname{'rice'     }</option>
	<option value=sorBic   >$db_fullname{'sorBic'   }</option>
	<option value=bmor1    >$db_fullname{'bmor1'    }</option>
	<option value=sacCer3  >$db_fullname{'sacCer3'  }</option>
	<option value=pombe    >$db_fullname{'pombe'    }</option>
	<option disabled>----------</option>
	<option value=refseq   >$db_fullname{'refseq'   }</option>
	<option value=hs_refseq>$db_fullname{'hs_refseq'}</option>
	<option value=mm_refseq>$db_fullname{'mm_refseq'}</option>
	<option value=prok     >$db_fullname{'prok'     }</option>
	<option value=ddbj     >$db_fullname{'ddbj'     }</option>" ;
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

(not $html) and
$html   = $template_top->output and
$title  = '超絶高速ゲノム配列検索GGGenome' and
$robots = '' ;
#- ▲ トップページ：引数がない場合

#- ▼ メンテナンス画面の作成
my $chatafile = 'template/maintenance_ja.txt' ;

my $message = '' ;
if (-f $chatafile and -r $chatafile){
	open FILE, $chatafile ;
	$message = join '', <FILE> ;
	close FILE ;
}

my $chata = ($message =~ /\A\s*\z/) ? '' :  # 空白文字のみの場合
<<"--EOS--" ;
<div><font color=red>
$message
</font></div>

<img src='chata_ja.png' alt='ニャーン' border=0>

<hr> <!-- __________________________________________________ -->
--EOS--
#- ▲ メンテナンス画面の作成

#- ▼ HTML出力
my $template_index = HTML::Template->new(filename => 'template/index_ja.tmpl') ;

$template_index->param(
	ROBOTS => $robots,
	TITLE  => $title,
	QUERY  => $query_string,
	SELECT => $select,
	K      => $k,
	CHATA  => $chata,
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
"	<option value=hg19     >$db_fullname{'hg19'     }</option>
	<option value=mm10     >$db_fullname{'mm10'     }</option>
	<option value=rn5      >$db_fullname{'rn5'      }</option>
	<option value=calJac3  >$db_fullname{'calJac3'  }</option>
	<option value=susScr3  >$db_fullname{'susScr3'  }</option>
	<option value=galGal4  >$db_fullname{'galGal4'  }</option>
	<option value=xenTro3  >$db_fullname{'xenTro3'  }</option>
	<option value=Xenla7   >$db_fullname{'Xenla7'   }</option>
	<option value=danRer7  >$db_fullname{'danRer7'  }</option>
	<option value=ci2      >$db_fullname{'ci2'      }</option>
	<option value=dm3      >$db_fullname{'dm3'      }</option>
	<option value=ce10     >$db_fullname{'ce10'     }</option>
	<option value=TAIR10   >$db_fullname{'TAIR10'   }</option>
	<option value=rice     >$db_fullname{'rice'     }</option>
	<option value=sorBic   >$db_fullname{'sorBic'   }</option>
	<option value=bmor1    >$db_fullname{'bmor1'    }</option>
	<option value=sacCer3  >$db_fullname{'sacCer3'  }</option>
	<option value=pombe    >$db_fullname{'pombe'    }</option>
	<option disabled>----------</option>
	<option value=refseq   >$db_fullname{'refseq'   }</option>
	<option value=hs_refseq>$db_fullname{'hs_refseq'}</option>
	<option value=mm_refseq>$db_fullname{'mm_refseq'}</option>
	<option value=prok     >$db_fullname{'prok'     }</option>
	<option value=ddbj     >$db_fullname{'ddbj'     }</option>" ;
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

(not $html) and
$html   = $template_top->output and
$title  = 'GGGenome | ultrafast DNA search' and
$robots = '' ;
#- ▲ トップページ：引数がない場合

#- ▼ メンテナンス画面の作成
my $chatafile = 'template/maintenance_en.txt' ;

my $message = '' ;
if (-f $chatafile and -r $chatafile){
	open FILE, $chatafile ;
	$message = join '', <FILE> ;
	close FILE ;
}

my $chata = ($message =~ /\A\s*\z/) ? '' :  # 空白文字のみの場合
<<"--EOS--" ;
<div><font color=red>
$message
</font></div>

<img src='chata_en.png' alt='nyaan' border=0>

<hr> --> __________________________________________________ -->
--EOS--
#- ▲ メンテナンス画面の作成

#- ▼ HTML出力
my $template_index = HTML::Template->new(filename => 'template/index_en.tmpl') ;

$template_index->param(
	ROBOTS => $robots,
	TITLE  => $title,
	QUERY  => $query_string,
	SELECT => $select,
	K      => $k,
	CHATA  => $chata,
	HTML   => $html
) ;

print "Content-type: text/html; charset=utf-8\n\n" ;
print $template_index->output ;
#- ▲ HTML出力

return ;
} ;
# ====================
