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
use warnings ; no warnings qw(once) ;
use strict ;
use Time::HiRes ;

eval 'use HTML::Template ; 1' or  # HTMLをテンプレート化
	printresult('ERROR : cannot load HTML::Template') ;

eval 'use Approx ; 1' or          # 曖昧検索サーバに問い合わせを行うためのモジュール
	printresult('ERROR : cannot load Approx') ;

eval 'use DBlist ; 1' or          # データベースの正式名およびホスト名/ポート番号の一覧
	printresult('ERROR : cannot load DBlist') ;

my @timer ;                       # 実行時間計測用
my $timestamp = timestamp() ;     # CGIを実行した時刻
my $min_query_length = 6 ;        # クエリの最低塩基長
my $max_k            = 25 ;       # 許容するミスマッチ/ギャップ数の上限、％
my $max_k_debug      = 50 ;       # 許容するミスマッチ/ギャップ数の上限、％、デバッグモード
my $max_hit_html     = 50 ;       # 検索を打ち切るヒット数、HTMLの場合
my $max_hit_api      = 100000 ;   # 検索を打ち切るヒット数、TXT,CSV,BED,GFF,JSONの場合
my $max_hit_debug    = 10000000 ; # 検索を打ち切るヒット数、デバッグモード
my $timeout          = 20 ;       # タイムアウト時間、秒
my $timeout_debug    = 1800 ;     # タイムアウト時間、秒、デバッグモード

my $dbconf = $DBlist::dbconfig ;  # データベースの正式名およびホスト名/ポート番号のリスト

my %host ;
my %port ;
my %source ;
my %db_fullname ;
my %db_synonym ;	#ADD tyamamot
foreach (split /\n/, $dbconf){
	chomp ;
	map {defined $_ ? ($_ =~ s/\s*$//g) : ($_ = '')}  # 後方のスペースを除去    #CHANGE tyamamot
		my ($db, $host, $port, $source, $fullname, $synonym) = split /\t/ ;  #CHANGE tyamamot
	$host{$db}        = $host ;
	$port{$db}        = $port ;
	$source{$db}      = $source ;
	$db_fullname{$db} = $fullname ;
	$db_synonym{$db}  = $synonym ;	#ADD tyamamot
}
#- ▲ モジュール読み込みと変数の初期化

#- ▼ リクエストからパラメータを取得
push @timer, [Time::HiRes::time(), 'start;'] ;                       #===== 実行時間計測 =====

#-- ▽ 使用するパラメータ一覧
my $lang         = '' ;  # HTMLの場合の日本語/英語: ja, en
my $db           = '' ;  # 生物種 (データベース): hg19, mm10, ...
my $k            = '' ;  # 許容するミスマッチ/ギャップの数: 0, 1, 2, ...
my $strand       = '' ;  # 検索する方向: +, -
my $query_string = '' ;  # 塩基配列
my $format       = '' ;  # 出力フォーマット: html, txt, csv, bed, gff, json
my $download     = '' ;  # ファイルとしてダウンロードするか: (boolean)
my $debug        = '' ;  # デバッグモード
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
	(grep {/^$param$/i} keys(%db_fullname)) ?
		$db = lc $1 :
	($param =~ /^(\d+)$/) ?
		$k = $1 :
	($param =~ /^(\+|\-|plus|minus|both)$/i) ?
		$strand = $1 :
	($param =~ /^(debug)$/i) ?
		$debug = 'true' :
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
grep {$db =~ s/^$_$/$_/i} keys(%db_fullname) ;  # DBの大文字小文字を正規化

$k =                                  # 許容するミスマッチ/ギャップの数
	(defined $query{'k'} and $query{'k'} =~ /^\d+$/) ?
	$query{'k'} :                     # 1) QUERY_STRINGから
	$k //                             # 2) QUERY_STRING未指定 → URIから
	'' ;                              # 3) URI未指定 → 空欄

$strand =                             # 検索する方向
	(defined $query{'strand'} and $query{'strand'} =~ /^(\+|\-|plus|minus|both)?$/i) ?
	$query{'strand'} :                # 1) QUERY_STRINGから
	$strand //                        # 2) QUERY_STRING未指定 → URIから
	'' ;                              # 3) URI未指定 → 空欄
$strand =~ s/^plus$/+/i ;             # plus  -> +
$strand =~ s/^minus$/-/i ;            # minus -> -
$strand =~ s/^both$//i ;              # both  -> 空欄

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

$debug =                              # デバッグモード
	$query{'debug'} //                # 1) QUERY_STRINGから
	$debug          //                # 2) QUERY_STRING未指定 → URIから
	'' ;                              # 3) URI未指定 → 空欄
#-- △ QUERY_STRINGからパラメータを取得
#- ▲ リクエストからパラメータを取得

#- ▼ パラメータからURIを生成してリダイレクト
my $redirect_uri = '/' ;
$redirect_uri .= ($request_uri =~ m{^/(test|bitst)/}) ? "$1/" : '' ;  # テストページ対応
$redirect_uri .= $debug ? "debug/" : '' ;
$redirect_uri .= $lang ? "$lang/" : '' ;
$redirect_uri .= $db   ? "$db/"   : '' ;
$redirect_uri .= $k    ? "$k/"    : '' ;  # 値が 0 の場合は /0/ を省略
$redirect_uri .= $strand   ? "$strand/"  : '' ;
$redirect_uri .= $query_string ;
$redirect_uri .= $format   ? ".$format"  : '' ;
$redirect_uri .= $download ? '.download' : '' ;

my $QUERY_STRING = $ENV{'QUERY_STRING'} // '' ; #ADD tyamamot
$QUERY_STRING =~ s/offset=[0-9]*//g ;           #ADD tyamamot
$QUERY_STRING =~ s/(&){2,}/$1/g ;               #ADD tyamamot
if ($ENV{'HTTP_HOST'} and                       # HTTP経由のリクエストで、かつ
	($request_uri ne $redirect_uri or           # 現在のURIと異なる場合にリダイレクト
	 $QUERY_STRING)                             #CHANGE tyamamot
){
	$ENV{'HTTPS'} ? redirect_page("https://$ENV{'HTTP_HOST'}$redirect_uri") :  # HTTPS経由
	                redirect_page("http://$ENV{'HTTP_HOST'}$redirect_uri")  ;  # HTTP経由
}
#- ▲ パラメータからURIを生成してリダイレクト

#- ▼ defaultパラメータ設定
$lang     ||= ($0 =~ /ja$/) ? 'ja' :  # lang が未定義で実行ファイルが index.cgi.ja の場合
              ($0 =~ /en$/) ? 'en' :  # lang が未定義で実行ファイルが index.cgi.en の場合
                              'en' ;  # default: en
$db       ||= 'hg19' ;
$k        ||= 0 ;
$strand   ||= '' ;
$format   ||= 'html' ;
$download ||= '' ;
$debug    ||= '' ;
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
$debug and $max_k = $max_k_debug ;  # デバッグモード
(length($queryseq) * $max_k / 100 >= $k) or
	printresult("ERROR : number of mismatches/gaps should be ${max_k}% or less") ;
#- ▲ クエリの内容をチェック

#- ▼ 塩基配列の検索と結果出力
#- ▽ タイムアウト処理を行う部分
eval {
	local $SIG{ALRM} = sub { die } ;
	alarm ($debug ? $timeout_debug : $timeout) ;

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
	my $limit = ($debug ? $max_hit_debug : $max_hit_api) ;  # 検索を打ち切るヒット数
	push @summary, "# [ GGGenome | $timestamp ]" ;
	push @summary, "# database:	$db_fullname" ;

	#--- ▽ (+)鎖の検索実行と結果出力
	unless ($strand eq '-'){
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
	}
	#--- △ (+)鎖の検索実行と結果出力

	#--- ▽ (-)鎖の検索実行と結果出力
	unless ($strand eq '+'){
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
	}
	#--- △ (-)鎖の検索実行と結果出力

	push @summary, '# name	strand	start	end	snippet	snippet_pos	snippet_end' ;
	@hit_list or push @hit_list, '### No items found. ###' ;  # ヒットがゼロ件
	print_txt(join "\n", (@summary, @hit_list)) ;
#-- △ TXT(タブ区切りテキスト)形式

#-- ▽ CSV形式
} elsif ($format eq 'csv'){
	my $limit = ($debug ? $max_hit_debug : $max_hit_api) ;  # 検索を打ち切るヒット数
	push @summary, "# [ GGGenome | $timestamp ]" ;
	push @summary, "# database,\"$db_fullname\"" ;

	#--- ▽ (+)鎖の検索実行と結果出力
	unless ($strand eq '-'){
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
	}
	#--- △ (+)鎖の検索実行と結果出力

	#--- ▽ (-)鎖の検索実行と結果出力
	unless ($strand eq '+'){
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
	}
	#--- △ (-)鎖の検索実行と結果出力

	push @summary, '# name,strand,start,end,snippet,snippet_pos,snippet_end' ;
	@hit_list or push @hit_list, '### No items found. ###' ;  # ヒットがゼロ件
	print_txt(join "\n", (@summary, @hit_list)) ;
#-- △ CSV形式

#-- ▽ BED形式
} elsif ($format eq 'bed'){
	my $limit = ($debug ? $max_hit_debug : $max_hit_api) ;  # 検索を打ち切るヒット数
	push @summary, "track name=GGGenome description=\"GGGenome matches\"" ;

	#--- ▽ (+)鎖の検索実行と結果出力
	unless ($strand eq '-'){
		($hits, $uri) = Approx::approx_q(uc(rna2dna($queryseq)), $host, $port, $k, $limit) or
			printresult('ERROR : searcher error') ;

		push @timer, [Time::HiRes::time(), "search_plus_done; $uri"] ;   #===== 実行時間計測 =====

		foreach (@{$hits->{hits}}){
			push @hit_list, show_hit_bed($_, '+') ;
		}
	}
	#--- △ (+)鎖の検索実行と結果出力

	#--- ▽ (-)鎖の検索実行と結果出力
	unless ($strand eq '+'){
		$queryseq = comp($queryseq) ;
		($hits, $uri) = Approx::approx_q(uc(rna2dna($queryseq)), $host, $port, $k, $limit) or
			printresult('ERROR : searcher error') ;

		push @timer, [Time::HiRes::time(), "search_minus_done; $uri"] ;  #===== 実行時間計測 =====

		foreach (@{$hits->{hits}}){
			push @hit_list, show_hit_bed($_, '-') ;
		}
	}
	#--- △ (-)鎖の検索実行と結果出力

	@hit_list or push @hit_list, '### No items found. ###' ;  # ヒットがゼロ件
	print_txt(join "\n", (@summary, @hit_list)) ;
#-- △ BED形式

#-- ▽ GFF形式
} elsif ($format eq 'gff'){
	my $limit = ($debug ? $max_hit_debug : $max_hit_api) ;  # 検索を打ち切るヒット数
	push @summary, "##gff-version 3" ;
	push @summary, "##source-version GGGenome v1" ;
	push @summary, "track name=GGGenome description=\"GGGenome matches\"" ;

	#--- ▽ (+)鎖の検索実行と結果出力
	unless ($strand eq '-'){
		($hits, $uri) = Approx::approx_q(uc(rna2dna($queryseq)), $host, $port, $k, $limit) or
			printresult('ERROR : searcher error') ;

		push @timer, [Time::HiRes::time(), "search_plus_done; $uri"] ;   #===== 実行時間計測 =====

		foreach (@{$hits->{hits}}){
			push @hit_list, show_hit_gff($_, '+') ;
		}
	}
	#--- △ (+)鎖の検索実行と結果出力

	#--- ▽ (-)鎖の検索実行と結果出力
	unless ($strand eq '+'){
		$queryseq = comp($queryseq) ;
		($hits, $uri) = Approx::approx_q(uc(rna2dna($queryseq)), $host, $port, $k, $limit) or
			printresult('ERROR : searcher error') ;

		push @timer, [Time::HiRes::time(), "search_minus_done; $uri"] ;  #===== 実行時間計測 =====

		foreach (@{$hits->{hits}}){
			push @hit_list, show_hit_gff($_, '-') ;
		}
	}
	#--- △ (-)鎖の検索実行と結果出力

	@hit_list or push @hit_list, '### No items found. ###' ;  # ヒットがゼロ件
	print_txt(join "\n", (@summary, @hit_list)) ;
#-- △ GFF形式

#-- ▽ JSON形式
} elsif ($format eq 'json'){
	my $limit = ($debug ? $max_hit_debug : $max_hit_api) ;  # 検索を打ち切るヒット数

	#--- ▽ (+)鎖の検索実行と結果出力
	unless ($strand eq '-'){
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
	}
	#--- △ (+)鎖の検索実行と結果出力

	#--- ▽ (-)鎖の検索実行と結果出力
	unless ($strand eq '+'){
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
	}
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
	my $limit = ($debug ? $max_hit_debug : $max_hit_html) ;  # 検索を打ち切るヒット数
	eval 'require Align2seq ; 1' or  # ミスマッチ/ギャップのある配列のハイライトに使用
		printresult('ERROR : cannot load Align2seq') ;

	my $offset  = $query{'offset'} // 0 ;               #ADD tyamamot offsetの追加
	my $timeout = $debug ? $timeout_debug : $timeout ;  #ADD tyamamot timeoutの追加
	$ds_hit_num = 0;                                    #ADD tyamamot ds_hit_numの初期化

	#--- ▽ (+)鎖の検索実行と結果出力
	unless ($strand eq '-'){
		($hits, $uri) = Approx::approx_q(uc(rna2dna($queryseq)), $host, $port, $k, $limit, $offset, $timeout) or #CHANGE tyamamot
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
	}
	#--- △ (+)鎖の検索実行と結果出力

	#--- ▽ (-)鎖の検索実行と結果出力
	unless ($strand eq '+'){

		#ADD start tyamamot
		if(scalar @hit_list){
			$limit -= (scalar @hit_list);
			$limit = 0 if($limit<0);
		}
		$offset -= ($ds_hit_num || 0);
		$offset = 0 if($offset<0);
		#ADD end tyamamot

		$queryseq = comp($queryseq) ;
		($hits, $uri) = Approx::approx_q(uc(rna2dna($queryseq)), $host, $port, $k, $limit, $offset, $timeout) or #CHANGE tyamamot
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
	}
	#--- △ (-)鎖の検索実行と結果出力

	#--- ▽ 両鎖の合計数を出力
	my $total = $ds_hit_num ;  #ADD tyamamot totalの追加
	$ds_approx and $ds_hit_num =~ s/^(\d{2})(\d*)/'&gt;' . $1 . 0 x length($2)/e ;

	$limit   = ($debug ? $max_hit_debug : $max_hit_html) ;  #ADD tyamamot 検索を打ち切るヒット数を改めてセット
	$offset  = $query{'offset'} // 0 ;                      #ADD tyamamot offsetの追加
	$hit_num = (scalar @hit_list) ;                         #ADD tyamamot 表示する件数

	push @summary,
		"	<li><font color=maroon><b>TOTAL ($ds_hit_num)</b></font>" .
		"<input type=hidden name='total' value='$total' />"   .   #ADD tyamamot <input type=hidden>タグの追記
		"<input type=hidden name='count' value='$hit_num' />" .   #ADD tyamamot <input type=hidden>タグの追記
		"<input type=hidden name='limit' value='$limit' />"   .   #ADD tyamamot <input type=hidden>タグの追記
		"<input type=hidden name='offset' value='$offset' />" ;   #ADD tyamamot <input type=hidden>タグの追記
	#--- △ 両鎖の合計数を出力

	@hit_list or
		push @hit_list, '<div class=gene><p>No items found.</p></div>' ;  # ヒットがゼロ件

	#--- ▽ TXT/CSV/BED/GFF/JSON出力のbase URIを生成
	my $linkbase_uri = '/' ;
	$linkbase_uri .= ($request_uri =~ m{^/(test|bitst)/}) ? "$1/" : '' ;  # テストページ対応
	$linkbase_uri .= $debug ? "debug/" : '' ;
	$linkbase_uri .= $db ? "$db/" : '' ;
	$linkbase_uri .= $k  ? "$k/"  : '' ;  # 値が 0 の場合は /0/ を省略
	$linkbase_uri .= $strand ? "$strand/" : '' ;
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
		HIT_LIST     => "@hit_list",
		MAX_HIT_API  => ($debug ? $max_hit_debug : $max_hit_api),
		LINKBASE_URI => $linkbase_uri,
		HTTP_HOST    => $ENV{'HTTP_HOST'},
		REDIRECT_URI => $redirect_uri,
		LANG         => $lang,
		DB           => $db,
		K            => $k,
		STRAND       => $strand,
		QUERY        => $query_string,
		FORMAT       => $format,
		DOWNLOAD     => $download,
		DEBUG        => $debug,
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

#ADD tyamamot <input type=hidden>タグの追記
return
"<div class=gene><!-- ==================== -->
	<div class=t>
	@{[ link_seqname($name, $position, $position_end, $db) ]}
	</div>
	<div class='b mono'>
	$snippet_html
	</div>
	<input type=hidden name='gene.name' value='$name' />
	<input type=hidden name='gene.length' value='$length' />
	<input type=hidden name='gene.position' value='$position' />
	<input type=hidden name='gene.position_end' value='$position_end' />
	<input type=hidden name='gene.snippet' value='$snippet' />
	<input type=hidden name='gene.snippet_pos' value='$snippet_pos' />
	<input type=hidden name='gene.snippet_5prime' value='$snippet_5prime' />
	<input type=hidden name='gene.snippet_3prime' value='$snippet_3prime' />
	<input type=hidden name='gene.sbjct' value='$sbjct' />
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

(grep {$source{$db} eq 'UCSC'} keys(%source)) ?
	return "<a class=a target='_blank' href='" .
	       "http://genome.ucsc.edu/cgi-bin/hgTracks?" .
	       "db=$db&position=$name%3A$pos-$pos_end'>$name:$pos-$pos_end</a>" :
(grep {$source{$db} eq 'Phytozome'} keys(%source)) ?
	return "<a class=a target='_blank' href='" .
	       "http://phytozome.jgi.doe.gov/jbrowse/?" .
	       "data=genomes%2F@{[(split /_/, $db)[0]]}&loc=$name%3A$pos..$pos_end&" .
	       "tracks=Transcripts%2C"  .
	       "Alt_Transcripts%2C"     .
	       "PASA_assembly%2C"       .
	       "Blastx_protein%2C"      .
	       "Blatx_Plant_protein%2C" .
	       "GeneExpression_GeneAtlas0_1'>$name:$pos-$pos_end</a>" :
($db eq 'ASM15162v1' and $name =~ s/\s.*//) ?
	return "<a class=a target='_blank' href='" .
	       "http://metazoa.ensembl.org/Bombyx_mori/Location/View?" .
	       "r=$name%3A$pos-$pos_end'>$name:$pos-$pos_end</a>" :
($db eq 'Tcas3' and $name =~ s/\s.*//) ?
	return "<a class=a target='_blank' href='" .
	       "http://metazoa.ensembl.org/Tribolium_castaneum/Location/View?" .
	       "r=$name%3A$pos-$pos_end'>$name:$pos-$pos_end</a>" :
($db eq 'Xenla7') ?
	return "<a class=a target='_blank' href='" .
	       "http://gbrowse.xenbase.org/fgb2/gbrowse/xl7_1/?" .
	       "name=$name%3A$pos..$pos_end'>$name:<br>$pos-$pos_end</a>" :
($db eq 'Xentr7') ?
	return "<a class=a target='_blank' href='" .
	       "http://gbrowse.xenbase.org/fgb2/gbrowse/xt7_1/?" .
	       "name=$name%3A$pos..$pos_end'>$name:<br>$pos-$pos_end</a>" :
($db eq 'Xentr8') ?
	return "<a class=a target='_blank' href='" .
	       "http://gbrowse.xenbase.org/fgb2/gbrowse/xt8_0/?" .
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
($db =~ /refseq/ and $name =~ /^gi\|\d+\|ref\|(.*?)\|(.*)$/) ?
	return "<a class=a target='_blank' href=" .
	       "http://www.ncbi.nlm.nih.gov/nuccore/$1>$2</a><br>\n\t" .
	       "<font color='#0E774A'>$1</font>:$pos-$pos_end" :
($db =~ /^(hg19|mm10)_pre_mRNA$/ and $name =~ /^(.*?)\|(.*?)\|(.*?)\|(.*?):(.*?):(.*?):(.*?)\|/) ?
	return "$4:@{[$6+1]}-$7($5), pre-mRNA of " .
	       "<a class=a target='_blank' href=" .
	       "http://www.ncbi.nlm.nih.gov/nuccore/$1>$1</a> " .
	       "($3)<br>\n\t" .
	       "$2<br>\n\t" .
	       "position: $pos-$pos_end" :
($db =~ /^(hg19|mm10)_pre_mRNA_v2$/ and $name =~ /^(.*?)\|(.*?)\|(.*?)\|(.*?)\|(.*?)\|(.*?)$/) ?
	return "$3:$5-$6($4), pre-mRNA of $2 (Gene ID:" .
	       "<a class=a target='_blank' href=" .
	       "http://www.ncbi.nlm.nih.gov/gene/?term=$1>$1</a>)<br>\n\t" .
	       "position: $pos-$pos_end" :
($db =~ /^16SrRNA$/ and $name =~ /^(.*?)\|(.*?)\|(.*?)$/) ?
	return "<a class=a target='_blank' href=" .
	       "http://www.ncbi.nlm.nih.gov/nuccore/@{[join('.', split(/_/, $1))]}>$2, $3</a><br>\n\t" .
	       "<font color='#0E774A'>@{[join('.', split(/_/, $1))]}</font>:$pos-$pos_end" :
($db eq 'prok' and $name =~ /^(.*?)\s*\{((?:.*)refseq:"(.*?)"(?:.*))\}$/) ?
	return "<a class=a target='_blank' href=" .
	       "http://www.ncbi.nlm.nih.gov/nuccore/$3>$1</a><br>\n\t" .
	       "<span class=g>$2</span><br>" .
	       "<font color='#0E774A'>$3</font>:$pos-$pos_end" :
($db =~ /^ddbj/ and $name =~ /^.*?\|(\S+)\s+(.*)$/) ?
	return "<a class=a target='_blank' href=" .
	       "http://www.ncbi.nlm.nih.gov/nuccore/$1>$2</a><br>\n\t" .
	       "<font color='#0E774A'>$1</font>:$pos-$pos_end" :
# それ以外の場合
	return "$name<br>\n\t" .
	       "position: $pos-$pos_end\n" ;
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
#ADD tyamamot synonym属性の追記
my $select = <<"--EOS--" ;
	<option value=\'hg38\'    synonym=\"$db_synonym{'hg38'   }\">$db_fullname{'hg38'   }</option>
	<option value=\'hg19\'    synonym=\"$db_synonym{'hg19'   }\">$db_fullname{'hg19'   }</option>
	<option value=\'hg18\'    synonym=\"$db_synonym{'hg18'   }\">$db_fullname{'hg18'   }</option>
	<option value=\'mm10\'    synonym=\"$db_synonym{'mm10'   }\">$db_fullname{'mm10'   }</option>
	<option value=\'mm9\'     synonym=\"$db_synonym{'mm9'    }\">$db_fullname{'mm9'    }</option>
	<option value=\'rn6\'     synonym=\"$db_synonym{'rn6'    }\">$db_fullname{'rn6'    }</option>
	<option value=\'rn5\'     synonym=\"$db_synonym{'rn5'    }\">$db_fullname{'rn5'    }</option>
	<option value=\'vicPac2\' synonym=\"$db_synonym{'vicPac2'}\">$db_fullname{'vicPac2'}</option>
	<option value=\'dasNov3\' synonym=\"$db_synonym{'dasNov3'}\">$db_fullname{'dasNov3'}</option>
	<option value=\'papAnu2\' synonym=\"$db_synonym{'papAnu2'}\">$db_fullname{'papAnu2'}</option>
	<option value=\'otoGar3\' synonym=\"$db_synonym{'otoGar3'}\">$db_fullname{'otoGar3'}</option>
	<option value=\'felCat5\' synonym=\"$db_synonym{'felCat5'}\">$db_fullname{'felCat5'}</option>
	<option value=\'panTro4\' synonym=\"$db_synonym{'panTro4'}\">$db_fullname{'panTro4'}</option>
	<option value=\'criGri1\' synonym=\"$db_synonym{'criGri1'}\">$db_fullname{'criGri1'}</option>
	<option value=\'bosTau8\' synonym=\"$db_synonym{'bosTau8'}\">$db_fullname{'bosTau8'}</option>
	<option value=\'canFam3\' synonym=\"$db_synonym{'canFam3'}\">$db_fullname{'canFam3'}</option>
	<option value=\'turTru2\' synonym=\"$db_synonym{'turTru2'}\">$db_fullname{'turTru2'}</option>
	<option value=\'loxAfr3\' synonym=\"$db_synonym{'loxAfr3'}\">$db_fullname{'loxAfr3'}</option>
	<option value=\'musFur1\' synonym=\"$db_synonym{'musFur1'}\">$db_fullname{'musFur1'}</option>
	<option value=\'nomLeu3\' synonym=\"$db_synonym{'nomLeu3'}\">$db_fullname{'nomLeu3'}</option>
	<option value=\'gorGor3\' synonym=\"$db_synonym{'gorGor3'}\">$db_fullname{'gorGor3'}</option>
	<option value=\'cavPor3\' synonym=\"$db_synonym{'cavPor3'}\">$db_fullname{'cavPor3'}</option>
	<option value=\'eriEur2\' synonym=\"$db_synonym{'eriEur2'}\">$db_fullname{'eriEur2'}</option>
	<option value=\'equCab2\' synonym=\"$db_synonym{'equCab2'}\">$db_fullname{'equCab2'}</option>
	<option value=\'dipOrd1\' synonym=\"$db_synonym{'dipOrd1'}\">$db_fullname{'dipOrd1'}</option>
	<option value=\'triMan1\' synonym=\"$db_synonym{'triMan1'}\">$db_fullname{'triMan1'}</option>
	<option value=\'calJac3\' synonym=\"$db_synonym{'calJac3'}\">$db_fullname{'calJac3'}</option>
	<option value=\'pteVam1\' synonym=\"$db_synonym{'pteVam1'}\">$db_fullname{'pteVam1'}</option>
	<option value=\'myoLuc2\' synonym=\"$db_synonym{'myoLuc2'}\">$db_fullname{'myoLuc2'}</option>
	<option value=\'balAcu1\' synonym=\"$db_synonym{'balAcu1'}\">$db_fullname{'balAcu1'}</option>
	<option value=\'micMur1\' synonym=\"$db_synonym{'micMur1'}\">$db_fullname{'micMur1'}</option>
	<option value=\'hetGla2\' synonym=\"$db_synonym{'hetGla2'}\">$db_fullname{'hetGla2'}</option>
	<option value=\'monDom5\' synonym=\"$db_synonym{'monDom5'}\">$db_fullname{'monDom5'}</option>
	<option value=\'ponAbe2\' synonym=\"$db_synonym{'ponAbe2'}\">$db_fullname{'ponAbe2'}</option>
	<option value=\'ailMel1\' synonym=\"$db_synonym{'ailMel1'}\">$db_fullname{'ailMel1'}</option>
	<option value=\'susScr3\' synonym=\"$db_synonym{'susScr3'}\">$db_fullname{'susScr3'}</option>
	<option value=\'ochPri3\' synonym=\"$db_synonym{'ochPri3'}\">$db_fullname{'ochPri3'}</option>
	<option value=\'ornAna1\' synonym=\"$db_synonym{'ornAna1'}\">$db_fullname{'ornAna1'}</option>
	<option value=\'oryCun2\' synonym=\"$db_synonym{'oryCun2'}\">$db_fullname{'oryCun2'}</option>
	<option value=\'rheMac3\' synonym=\"$db_synonym{'rheMac3'}\">$db_fullname{'rheMac3'}</option>
	<option value=\'proCap1\' synonym=\"$db_synonym{'proCap1'}\">$db_fullname{'proCap1'}</option>
	<option value=\'oviAri3\' synonym=\"$db_synonym{'oviAri3'}\">$db_fullname{'oviAri3'}</option>
	<option value=\'sorAra2\' synonym=\"$db_synonym{'sorAra2'}\">$db_fullname{'sorAra2'}</option>
	<option value=\'choHof1\' synonym=\"$db_synonym{'choHof1'}\">$db_fullname{'choHof1'}</option>
	<option value=\'speTri2\' synonym=\"$db_synonym{'speTri2'}\">$db_fullname{'speTri2'}</option>
	<option value=\'saiBol1\' synonym=\"$db_synonym{'saiBol1'}\">$db_fullname{'saiBol1'}</option>
	<option value=\'tarSyr1\' synonym=\"$db_synonym{'tarSyr1'}\">$db_fullname{'tarSyr1'}</option>
	<option value=\'sarHar1\' synonym=\"$db_synonym{'sarHar1'}\">$db_fullname{'sarHar1'}</option>
	<option value=\'echTel2\' synonym=\"$db_synonym{'echTel2'}\">$db_fullname{'echTel2'}</option>
	<option value=\'tupBel1\' synonym=\"$db_synonym{'tupBel1'}\">$db_fullname{'tupBel1'}</option>
	<option value=\'macEug2\' synonym=\"$db_synonym{'macEug2'}\">$db_fullname{'macEug2'}</option>
	<option value=\'cerSim1\' synonym=\"$db_synonym{'cerSim1'}\">$db_fullname{'cerSim1'}</option>
	<option value=\'allMis1\' synonym=\"$db_synonym{'allMis1'}\">$db_fullname{'allMis1'}</option>
	<option value=\'gadMor1\' synonym=\"$db_synonym{'gadMor1'}\">$db_fullname{'gadMor1'}</option>
	<option value=\'melUnd1\' synonym=\"$db_synonym{'melUnd1'}\">$db_fullname{'melUnd1'}</option>
	<option value=\'galGal4\' synonym=\"$db_synonym{'galGal4'}\">$db_fullname{'galGal4'}</option>
	<option value=\'latCha1\' synonym=\"$db_synonym{'latCha1'}\">$db_fullname{'latCha1'}</option>
	<option value=\'calMil1\' synonym=\"$db_synonym{'calMil1'}\">$db_fullname{'calMil1'}</option>
	<option value=\'fr3\'     synonym=\"$db_synonym{'fr3'    }\">$db_fullname{'fr3'    }</option>
	<option value=\'petMar2\' synonym=\"$db_synonym{'petMar2'}\">$db_fullname{'petMar2'}</option>
	<option value=\'anoCar2\' synonym=\"$db_synonym{'anoCar2'}\">$db_fullname{'anoCar2'}</option>
	<option value=\'oryLat2\' synonym=\"$db_synonym{'oryLat2'}\">$db_fullname{'oryLat2'}</option>
	<option value=\'geoFor1\' synonym=\"$db_synonym{'geoFor1'}\">$db_fullname{'geoFor1'}</option>
	<option value=\'oreNil2\' synonym=\"$db_synonym{'oreNil2'}\">$db_fullname{'oreNil2'}</option>
	<option value=\'chrPic1\' synonym=\"$db_synonym{'chrPic1'}\">$db_fullname{'chrPic1'}</option>
	<option value=\'gasAcu1\' synonym=\"$db_synonym{'gasAcu1'}\">$db_fullname{'gasAcu1'}</option>
	<option value=\'tetNig2\' synonym=\"$db_synonym{'tetNig2'}\">$db_fullname{'tetNig2'}</option>
	<option value=\'melGal1\' synonym=\"$db_synonym{'melGal1'}\">$db_fullname{'melGal1'}</option>
	<option value=\'Xenla7\'  synonym=\"$db_synonym{'Xenla7' }\">$db_fullname{'Xenla7' }</option>
	<option value=\'Xentr8\'  synonym=\"$db_synonym{'Xentr8' }\">$db_fullname{'Xentr8' }</option>
	<option value=\'Xentr7\'  synonym=\"$db_synonym{'Xentr7' }\">$db_fullname{'Xentr7' }</option>
	<option value=\'xenTro3\' synonym=\"$db_synonym{'xenTro3'}\">$db_fullname{'xenTro3'}</option>
	<option value=\'taeGut2\' synonym=\"$db_synonym{'taeGut2'}\">$db_fullname{'taeGut2'}</option>
	<option value=\'danRer7\' synonym=\"$db_synonym{'danRer7'}\">$db_fullname{'danRer7'}</option>
	<option value=\'ci2\'     synonym=\"$db_synonym{'ci2'    }\">$db_fullname{'ci2'    }</option>
	<option value=\'braFlo1\' synonym=\"$db_synonym{'braFlo1'}\">$db_fullname{'braFlo1'}</option>
	<option value=\'strPur2\' synonym=\"$db_synonym{'strPur2'}\">$db_fullname{'strPur2'}</option>
	<option value=\'anoGam1\' synonym=\"$db_synonym{'anoGam1'}\">$db_fullname{'anoGam1'}</option>
	<option value=\'apiMel2\' synonym=\"$db_synonym{'apiMel2'}\">$db_fullname{'apiMel2'}</option>
	<option value=\'droAna2\' synonym=\"$db_synonym{'droAna2'}\">$db_fullname{'droAna2'}</option>
	<option value=\'droEre1\' synonym=\"$db_synonym{'droEre1'}\">$db_fullname{'droEre1'}</option>
	<option value=\'droGri1\' synonym=\"$db_synonym{'droGri1'}\">$db_fullname{'droGri1'}</option>
	<option value=\'dm6\'     synonym=\"$db_synonym{'dm6'    }\">$db_fullname{'dm6'    }</option>
	<option value=\'dm3\'     synonym=\"$db_synonym{'dm3'    }\">$db_fullname{'dm3'    }</option>
	<option value=\'droMoj2\' synonym=\"$db_synonym{'droMoj2'}\">$db_fullname{'droMoj2'}</option>
	<option value=\'droPer1\' synonym=\"$db_synonym{'droPer1'}\">$db_fullname{'droPer1'}</option>
	<option value=\'dp3\'     synonym=\"$db_synonym{'dp3'    }\">$db_fullname{'dp3'    }</option>
	<option value=\'droSec1\' synonym=\"$db_synonym{'droSec1'}\">$db_fullname{'droSec1'}</option>
	<option value=\'droSim1\' synonym=\"$db_synonym{'droSim1'}\">$db_fullname{'droSim1'}</option>
	<option value=\'droVir2\' synonym=\"$db_synonym{'droVir2'}\">$db_fullname{'droVir2'}</option>
	<option value=\'droYak2\' synonym=\"$db_synonym{'droYak2'}\">$db_fullname{'droYak2'}</option>
	<option value=\'caePb2\'  synonym=\"$db_synonym{'caePb2' }\">$db_fullname{'caePb2' }</option>
	<option value=\'cb3\'     synonym=\"$db_synonym{'cb3'    }\">$db_fullname{'cb3'    }</option>
	<option value=\'ce10\'    synonym=\"$db_synonym{'ce10'   }\">$db_fullname{'ce10'   }</option>
	<option value=\'caeJap1\' synonym=\"$db_synonym{'caeJap1'}\">$db_fullname{'caeJap1'}</option>
	<option value=\'caeRem3\' synonym=\"$db_synonym{'caeRem3'}\">$db_fullname{'caeRem3'}</option>
	<option value=\'priPac1\' synonym=\"$db_synonym{'priPac1'}\">$db_fullname{'priPac1'}</option>
	<option value=\'sacCer3\' synonym=\"$db_synonym{'sacCer3'}\">$db_fullname{'sacCer3'}</option>
	<option value=\'aplCal1\' synonym=\"$db_synonym{'aplCal1'}\">$db_fullname{'aplCal1'}</option>

	<option value=\'OryAfe1.0\'      synonym=\"$db_synonym{'OryAfe1.0'     }\">$db_fullname{'OryAfe1.0'     }</option>
	<option value=\'PoeFor_5.1.2\'   synonym=\"$db_synonym{'PoeFor_5.1.2'  }\">$db_fullname{'PoeFor_5.1.2'  }</option>
	<option value=\'CSAV2.0\'        synonym=\"$db_synonym{'CSAV2.0'       }\">$db_fullname{'CSAV2.0'       }</option>
	<option value=\'AstMex102\'      synonym=\"$db_synonym{'AstMex102'     }\">$db_fullname{'AstMex102'     }</option>
	<option value=\'PelSin_1.0\'     synonym=\"$db_synonym{'PelSin_1.0'    }\">$db_fullname{'PelSin_1.0'    }</option>
	<option value=\'MacFas5.0\'      synonym=\"$db_synonym{'MacFas5.0'     }\">$db_fullname{'MacFas5.0'     }</option>
	<option value=\'BGI_duck_1.0\'   synonym=\"$db_synonym{'BGI_duck_1.0'  }\">$db_fullname{'BGI_duck_1.0'  }</option>
	<option value=\'FicAlb_1.4\'     synonym=\"$db_synonym{'FicAlb_1.4'    }\">$db_fullname{'FicAlb_1.4'    }</option>
	<option value=\'Pham\'           synonym=\"$db_synonym{'Pham'          }\">$db_fullname{'Pham'          }</option>
	<option value=\'Xipmac4.4.2\'    synonym=\"$db_synonym{'Xipmac4.4.2'   }\">$db_fullname{'Xipmac4.4.2'   }</option>
	<option value=\'MicOch1.0\'      synonym=\"$db_synonym{'MicOch1.0'     }\">$db_fullname{'MicOch1.0'     }</option>
	<option value=\'PhyMac_2.0.2\'   synonym=\"$db_synonym{'PhyMac_2.0.2'  }\">$db_fullname{'PhyMac_2.0.2'  }</option>
	<option value=\'LepOcu1\'        synonym=\"$db_synonym{'LepOcu1'       }\">$db_fullname{'LepOcu1'       }</option>
	<option value=\'ChlSab1.1\'      synonym=\"$db_synonym{'ChlSab1.1'     }\">$db_fullname{'ChlSab1.1'     }</option>
	<option value=\'Acyr_2.0\'       synonym=\"$db_synonym{'Acyr_2.0'      }\">$db_fullname{'Acyr_2.0'      }</option>
	<option value=\'AaegL3\'         synonym=\"$db_synonym{'AaegL3'        }\">$db_fullname{'AaegL3'        }</option>
	<option value=\'Aqu1\'           synonym=\"$db_synonym{'Aqu1'          }\">$db_fullname{'Aqu1'          }</option>
	<option value=\'AdarC3\'         synonym=\"$db_synonym{'AdarC3'        }\">$db_fullname{'AdarC3'        }</option>
	<option value=\'Attacep1.0\'     synonym=\"$db_synonym{'Attacep1.0'    }\">$db_fullname{'Attacep1.0'    }</option>
	<option value=\'ASM15162v1\'     synonym=\"$db_synonym{'ASM15162v1'    }\">$db_fullname{'ASM15162v1'    }</option>
	<option value=\'B_malayi_3.0\'   synonym=\"$db_synonym{'B_malayi_3.0'  }\">$db_fullname{'B_malayi_3.0'  }</option>
	<option value=\'Capte_v1.0\'     synonym=\"$db_synonym{'Capte_v1.0'    }\">$db_fullname{'Capte_v1.0'    }</option>
	<option value=\'oyster_v9\'      synonym=\"$db_synonym{'oyster_v9'     }\">$db_fullname{'oyster_v9'     }</option>
	<option value=\'CpipJ2\'         synonym=\"$db_synonym{'CpipJ2'        }\">$db_fullname{'CpipJ2'        }</option>
	<option value=\'DanPle_1.0\'     synonym=\"$db_synonym{'DanPle_1.0'    }\">$db_fullname{'DanPle_1.0'    }</option>
	<option value=\'Dappu_V1.0\'     synonym=\"$db_synonym{'Dappu_V1.0'    }\">$db_fullname{'Dappu_V1.0'    }</option>
	<option value=\'DendPond_1.0\'   synonym=\"$db_synonym{'DendPond_1.0'  }\">$db_fullname{'DendPond_1.0'  }</option>
	<option value=\'dwil_caf1\'      synonym=\"$db_synonym{'dwil_caf1'     }\">$db_fullname{'dwil_caf1'     }</option>
	<option value=\'Hmel1\'          synonym=\"$db_synonym{'Hmel1'         }\">$db_fullname{'Hmel1'         }</option>
	<option value=\'Helro1\'         synonym=\"$db_synonym{'Helro1'        }\">$db_fullname{'Helro1'        }</option>
	<option value=\'IscaW1\'         synonym=\"$db_synonym{'IscaW1'        }\">$db_fullname{'IscaW1'        }</option>
	<option value=\'Loa_loa_V3\'     synonym=\"$db_synonym{'Loa_loa_V3'    }\">$db_fullname{'Loa_loa_V3'    }</option>
	<option value=\'Lotgi1\'         synonym=\"$db_synonym{'Lotgi1'        }\">$db_fullname{'Lotgi1'        }</option>
	<option value=\'Msca1\'          synonym=\"$db_synonym{'Msca1'         }\">$db_fullname{'Msca1'         }</option>
	<option value=\'MelCinx1.0\'     synonym=\"$db_synonym{'MelCinx1.0'    }\">$db_fullname{'MelCinx1.0'    }</option>
	<option value=\'MneLei\'         synonym=\"$db_synonym{'MneLei'        }\">$db_fullname{'MneLei'        }</option>
	<option value=\'Nvit_2.1\'       synonym=\"$db_synonym{'Nvit_2.1'      }\">$db_fullname{'Nvit_2.1'      }</option>
	<option value=\'ASM20922v1\'     synonym=\"$db_synonym{'ASM20922v1'    }\">$db_fullname{'ASM20922v1'    }</option>
	<option value=\'Cameroon_v3\'    synonym=\"$db_synonym{'Cameroon_v3'   }\">$db_fullname{'Cameroon_v3'   }</option>
	<option value=\'PhumU2\'         synonym=\"$db_synonym{'PhumU2'        }\">$db_fullname{'PhumU2'        }</option>
	<option value=\'RproC1\'         synonym=\"$db_synonym{'RproC1'        }\">$db_fullname{'RproC1'        }</option>
	<option value=\'ASM23792v2\'     synonym=\"$db_synonym{'ASM23792v2'    }\">$db_fullname{'ASM23792v2'    }</option>
	<option value=\'Si_gnG\'         synonym=\"$db_synonym{'Si_gnG'        }\">$db_fullname{'Si_gnG'        }</option>
	<option value=\'Smar1\'          synonym=\"$db_synonym{'Smar1'         }\">$db_fullname{'Smar1'         }</option>
	<option value=\'ASM23943v1\'     synonym=\"$db_synonym{'ASM23943v1'    }\">$db_fullname{'ASM23943v1'    }</option>
	<option value=\'Tcas3\'          synonym=\"$db_synonym{'Tcas3'         }\">$db_fullname{'Tcas3'         }</option>
	<option value=\'Tspiralis1\'     synonym=\"$db_synonym{'Tspiralis1'    }\">$db_fullname{'Tspiralis1'    }</option>
	<option value=\'ASM15027v1\'     synonym=\"$db_synonym{'ASM15027v1'    }\">$db_fullname{'ASM15027v1'    }</option>
	<option value=\'ZooNev1.0\'      synonym=\"$db_synonym{'ZooNev1.0'     }\">$db_fullname{'ZooNev1.0'     }</option>
	<option value=\'ASM34733v1\'     synonym=\"$db_synonym{'ASM34733v1'    }\">$db_fullname{'ASM34733v1'    }</option>
	<option value=\'AMTR1.0\'        synonym=\"$db_synonym{'AMTR1.0'       }\">$db_fullname{'AMTR1.0'       }</option>
	<option value=\'Araly_v.1.0\'    synonym=\"$db_synonym{'Araly_v.1.0'   }\">$db_fullname{'Araly_v.1.0'   }</option>
	<option value=\'TAIR10_en\'      synonym=\"$db_synonym{'TAIR10_en'     }\">$db_fullname{'TAIR10_en'     }</option>
	<option value=\'Bradi_v1.0\'     synonym=\"$db_synonym{'Bradi_v1.0'    }\">$db_fullname{'Bradi_v1.0'    }</option>
	<option value=\'Braol_v2.1\'     synonym=\"$db_synonym{'Braol_v2.1'    }\">$db_fullname{'Braol_v2.1'    }</option>
	<option value=\'IVFCAASv1\'      synonym=\"$db_synonym{'IVFCAASv1'     }\">$db_fullname{'IVFCAASv1'     }</option>
	<option value=\'Chlre_v3.1\'     synonym=\"$db_synonym{'Chlre_v3.1'    }\">$db_fullname{'Chlre_v3.1'    }</option>
	<option value=\'ASM9120v1\'      synonym=\"$db_synonym{'ASM9120v1'     }\">$db_fullname{'ASM9120v1'     }</option>
	<option value=\'Soybn_V1.0\'     synonym=\"$db_synonym{'Soybn_V1.0'    }\">$db_fullname{'Soybn_V1.0'    }</option>
	<option value=\'Horvu_v1\'       synonym=\"$db_synonym{'Horvu_v1'      }\">$db_fullname{'Horvu_v1'      }</option>
	<option value=\'Lperr_V1.4\'     synonym=\"$db_synonym{'Lperr_V1.4'    }\">$db_fullname{'Lperr_V1.4'    }</option>
	<option value=\'MedtrA17_4.0\'   synonym=\"$db_synonym{'MedtrA17_4.0'  }\">$db_fullname{'MedtrA17_4.0'  }</option>
	<option value=\'MA1\'            synonym=\"$db_synonym{'MA1'           }\">$db_fullname{'MA1'           }</option>
	<option value=\'Obart_v1.0\'     synonym=\"$db_synonym{'Obart_v1.0'    }\">$db_fullname{'Obart_v1.0'    }</option>
	<option value=\'Orybr_v1.4b\'    synonym=\"$db_synonym{'Orybr_v1.4b'   }\">$db_fullname{'Orybr_v1.4b'   }</option>
	<option value=\'AGI1.1\'         synonym=\"$db_synonym{'AGI1.1'        }\">$db_fullname{'AGI1.1'        }</option>
	<option value=\'Orygl\'          synonym=\"$db_synonym{'Orygl'         }\">$db_fullname{'Orygl'         }</option>
	<option value=\'Orylo_v0117\'    synonym=\"$db_synonym{'Orylo_v0117'   }\">$db_fullname{'Orylo_v0117'   }</option>
	<option value=\'Oryme_v1.3\'     synonym=\"$db_synonym{'Oryme_v1.3'    }\">$db_fullname{'Oryme_v1.3'    }</option>
	<option value=\'Oryni\'          synonym=\"$db_synonym{'Oryni'         }\">$db_fullname{'Oryni'         }</option>
	<option value=\'Orypu\'          synonym=\"$db_synonym{'Orypu'         }\">$db_fullname{'Orypu'         }</option>
	<option value=\'PRJEB4137\'      synonym=\"$db_synonym{'PRJEB4137'     }\">$db_fullname{'PRJEB4137'     }</option>
	<option value=\'ASM465v1\'       synonym=\"$db_synonym{'ASM465v1'      }\">$db_fullname{'ASM465v1'      }</option>
	<option value=\'ASM9206v1\'      synonym=\"$db_synonym{'ASM9206v1'     }\">$db_fullname{'ASM9206v1'     }</option>
	<option value=\'ASM242v1\'       synonym=\"$db_synonym{'ASM242v1'      }\">$db_fullname{'ASM242v1'      }</option>
	<option value=\'Poptr_JGI2.0\'   synonym=\"$db_synonym{'Poptr_JGI2.0'  }\">$db_fullname{'Poptr_JGI2.0'  }</option>
	<option value=\'Prupe1_0\'       synonym=\"$db_synonym{'Prupe1_0'      }\">$db_fullname{'Prupe1_0'      }</option>
	<option value=\'Selml_v1.0\'     synonym=\"$db_synonym{'Selml_v1.0'    }\">$db_fullname{'Selml_v1.0'    }</option>
	<option value=\'Setit_JGIv2.0\'  synonym=\"$db_synonym{'Setit_JGIv2.0' }\">$db_fullname{'Setit_JGIv2.0' }</option>
	<option value=\'SL2.50\'         synonym=\"$db_synonym{'SL2.50'        }\">$db_fullname{'SL2.50'        }</option>
	<option value=\'SolTub_3.0\'     synonym=\"$db_synonym{'SolTub_3.0'    }\">$db_fullname{'SolTub_3.0'    }</option>
	<option value=\'Sorbi1\'         synonym=\"$db_synonym{'Sorbi1'        }\">$db_fullname{'Sorbi1'        }</option>
	<option value=\'Thecc_20110822\' synonym=\"$db_synonym{'Thecc_20110822'}\">$db_fullname{'Thecc_20110822'}</option>
	<option value=\'IWGSC1.0\'       synonym=\"$db_synonym{'IWGSC1.0'      }\">$db_fullname{'IWGSC1.0'      }</option>
	<option value=\'ASM34745v1\'     synonym=\"$db_synonym{'ASM34745v1'    }\">$db_fullname{'ASM34745v1'    }</option>
	<option value=\'IGGP_12x\'       synonym=\"$db_synonym{'IGGP_12x'      }\">$db_fullname{'IGGP_12x'      }</option>
	<option value=\'AGPv3\'          synonym=\"$db_synonym{'AGPv3'         }\">$db_fullname{'AGPv3'         }</option>

	<option value=\'macaque_CE_1\' synonym=\"$db_synonym{'macaque_CE_1'}\">$db_fullname{'macaque_CE_1'}</option>
	<option value=\'bmor1\'   synonym=\"$db_synonym{'bmor1'  }\">$db_fullname{'bmor1'  }</option>
	<option value=\'pombe\'   synonym=\"$db_synonym{'pombe'  }\">$db_fullname{'pombe'  }</option>

	<option value=\'TAIR10\'  synonym=\"$db_synonym{'TAIR10' }\">$db_fullname{'TAIR10' }</option>
	<option value=\'rice\'    synonym=\"$db_synonym{'rice'   }\">$db_fullname{'rice'   }</option>
	<option value=\'sorBic\'  synonym=\"$db_synonym{'sorBic' }\">$db_fullname{'sorBic' }</option>
	<option value=\'Ppatens_251_v3\'           synonym=\"$db_synonym{'Ppatens_251_v3'          }\">$db_fullname{'Ppatens_251_v3'          }</option>
	<option value=\'Smoellendorffii_91_v1\'    synonym=\"$db_synonym{'Smoellendorffii_91_v1'   }\">$db_fullname{'Smoellendorffii_91_v1'   }</option>
	<option value=\'Creinhardtii_281_v5_5\'    synonym=\"$db_synonym{'Creinhardtii_281_v5_5'   }\">$db_fullname{'Creinhardtii_281_v5_5'   }</option>
	<option value=\'Olucimarinus_231_v2\'      synonym=\"$db_synonym{'Olucimarinus_231_v2'     }\">$db_fullname{'Olucimarinus_231_v2'     }</option>
	<option value=\'Cgrandiflora_v1\'          synonym=\"$db_synonym{'Cgrandiflora_v1'         }\">$db_fullname{'Cgrandiflora_v1'         }</option>
	<option value=\'Crubella_v1\'              synonym=\"$db_synonym{'Crubella_v1'             }\">$db_fullname{'Crubella_v1'             }</option>
	<option value=\'Cpapaya_r.Dec2008\'        synonym=\"$db_synonym{'Cpapaya_r.Dec2008'       }\">$db_fullname{'Cpapaya_r.Dec2008'       }</option>
	<option value=\'CsubellipsoideaC169_v2.0\' synonym=\"$db_synonym{'CsubellipsoideaC169_v2.0'}\">$db_fullname{'CsubellipsoideaC169_v2.0'}</option>
	<option value=\'Csativus_v1\'              synonym=\"$db_synonym{'Csativus_v1'             }\">$db_fullname{'Csativus_v1'             }</option>
	<option value=\'Egrandis_v2.0\'            synonym=\"$db_synonym{'Egrandis_v2.0'           }\">$db_fullname{'Egrandis_v2.0'           }</option>
	<option value=\'Fvesca_v1.1\'              synonym=\"$db_synonym{'Fvesca_v1.1'             }\">$db_fullname{'Fvesca_v1.1'             }</option>
	<option value=\'Graimondii_v2.0\'          synonym=\"$db_synonym{'Graimondii_v2.0'         }\">$db_fullname{'Graimondii_v2.0'         }</option>
	<option value=\'Lusitatissimum_BGIv1.0\'   synonym=\"$db_synonym{'Lusitatissimum_BGIv1.0'  }\">$db_fullname{'Lusitatissimum_BGIv1.0'  }</option>
	<option value=\'Mdomestica_v1.0\'          synonym=\"$db_synonym{'Mdomestica_v1.0'         }\">$db_fullname{'Mdomestica_v1.0'         }</option>
	<option value=\'Mesculenta_v6\'            synonym=\"$db_synonym{'Mesculenta_v6'           }\">$db_fullname{'Mesculenta_v6'           }</option>
	<option value=\'MpusillaCCMP1545_v3.0\'    synonym=\"$db_synonym{'MpusillaCCMP1545_v3.0'   }\">$db_fullname{'MpusillaCCMP1545_v3.0'   }</option>
	<option value=\'MpusillaRCC299_v3.0\'      synonym=\"$db_synonym{'MpusillaRCC299_v3.0'     }\">$db_fullname{'MpusillaRCC299_v3.0'     }</option>
	<option value=\'Mguttatus_v2.0\'           synonym=\"$db_synonym{'Mguttatus_v2.0'          }\">$db_fullname{'Mguttatus_v2.0'          }</option>
	<option value=\'Ppersica_v2.0\'            synonym=\"$db_synonym{'Ppersica_v2.0'           }\">$db_fullname{'Ppersica_v2.0'           }</option>
	<option value=\'Rcommunis_TIGR.0.1\'       synonym=\"$db_synonym{'Rcommunis_TIGR.0.1'      }\">$db_fullname{'Rcommunis_TIGR.0.1'      }</option>
	<option value=\'Spolyrhiza_v1\'            synonym=\"$db_synonym{'Spolyrhiza_v1'           }\">$db_fullname{'Spolyrhiza_v1'           }</option>
	<option value=\'Vcarteri_v2\'              synonym=\"$db_synonym{'Vcarteri_v2'             }\">$db_fullname{'Vcarteri_v2'             }</option>

	<option value=\'eboVir3\' synonym=\"$db_synonym{'eboVir3'}\">$db_fullname{'eboVir3'}</option>

	<option disabled>--------------------</option>

	<option value=\'refseq\'      synonym=\"$db_synonym{'refseq'     }\">$db_fullname{'refseq'     }</option>
	<option value=\'hs_refseq70\' synonym=\"$db_synonym{'hs_refseq70'}\">$db_fullname{'hs_refseq70'}</option>
	<option value=\'mm_refseq70\' synonym=\"$db_synonym{'mm_refseq70'}\">$db_fullname{'mm_refseq70'}</option>
	<option value=\'rn_refseq70\' synonym=\"$db_synonym{'rn_refseq70'}\">$db_fullname{'rn_refseq70'}</option>
	<option value=\'prok\'        synonym=\"$db_synonym{'prok'       }\">$db_fullname{'prok'       }</option>
	<option value=\'16SrRNA\'     synonym=\"$db_synonym{'16SrRNA'    }\">$db_fullname{'16SrRNA'    }</option>
	<option value=\'macaque_CE_1_cds\' synonym=\"$db_synonym{'macaque_CE_1_cds'}\">$db_fullname{'macaque_CE_1_cds'}</option>

	<option disabled>--------------------</option>

	<option value=\'ddbj101hum\' synonym=\"$db_synonym{'ddbj101hum'}\">$db_fullname{'ddbj101hum'}</option>
	<option value=\'ddbj101pri\' synonym=\"$db_synonym{'ddbj101pri'}\">$db_fullname{'ddbj101pri'}</option>
	<option value=\'ddbj101rod\' synonym=\"$db_synonym{'ddbj101rod'}\">$db_fullname{'ddbj101rod'}</option>
	<option value=\'ddbj101mam\' synonym=\"$db_synonym{'ddbj101mam'}\">$db_fullname{'ddbj101mam'}</option>
	<option value=\'ddbj101vrt\' synonym=\"$db_synonym{'ddbj101vrt'}\">$db_fullname{'ddbj101vrt'}</option>
	<option value=\'ddbj101inv\' synonym=\"$db_synonym{'ddbj101inv'}\">$db_fullname{'ddbj101inv'}</option>
	<option value=\'ddbj101pln\' synonym=\"$db_synonym{'ddbj101pln'}\">$db_fullname{'ddbj101pln'}</option>
	<option value=\'ddbj101bct\' synonym=\"$db_synonym{'ddbj101bct'}\">$db_fullname{'ddbj101bct'}</option>
	<option value=\'ddbj101vrl\' synonym=\"$db_synonym{'ddbj101vrl'}\">$db_fullname{'ddbj101vrl'}</option>
	<option value=\'ddbj101phg\' synonym=\"$db_synonym{'ddbj101phg'}\">$db_fullname{'ddbj101phg'}</option>
	<option value=\'ddbj101pat\' synonym=\"$db_synonym{'ddbj101pat'}\">$db_fullname{'ddbj101pat'}</option>
	<option value=\'ddbj101env\' synonym=\"$db_synonym{'ddbj101env'}\">$db_fullname{'ddbj101env'}</option>
	<option value=\'ddbj101syn\' synonym=\"$db_synonym{'ddbj101syn'}\">$db_fullname{'ddbj101syn'}</option>
	<option value=\'ddbj101est\' synonym=\"$db_synonym{'ddbj101est'}\">$db_fullname{'ddbj101est'}</option>
	<option value=\'ddbj101tsa\' synonym=\"$db_synonym{'ddbj101tsa'}\">$db_fullname{'ddbj101tsa'}</option>
	<option value=\'ddbj101gss\' synonym=\"$db_synonym{'ddbj101gss'}\">$db_fullname{'ddbj101gss'}</option>
	<option value=\'ddbj101htc\' synonym=\"$db_synonym{'ddbj101htc'}\">$db_fullname{'ddbj101htc'}</option>
	<option value=\'ddbj101htg\' synonym=\"$db_synonym{'ddbj101htg'}\">$db_fullname{'ddbj101htg'}</option>
	<option value=\'ddbj101sts\' synonym=\"$db_synonym{'ddbj101sts'}\">$db_fullname{'ddbj101sts'}</option>
	<option value=\'ddbj101una\' synonym=\"$db_synonym{'ddbj101una'}\">$db_fullname{'ddbj101una'}</option>
	<option value=\'ddbj\'       synonym=\"$db_synonym{'ddbj'      }\">$db_fullname{'ddbj'      }</option>
--EOS--

$db and $select =~ s/(?<=option value=$db)/ selected/ or  # 種を選択
	$db_fullname{$db} and $select =                       # 種を追加
		"	<option value=$db selected>$db_fullname{$db}</option>\n" .
		"	<option disabled>----------</option>\n" . $select or
	$select =~ s/(?<=option value=hg19)/ selected/ ;      # default: Human genome (hg19)
#-- △ プルダウンメニュー

#-- ▽ strand選択ボタン
my $strand_selection =
"<input type=radio name=strand value=both>双方向を検索
<input type=radio name=strand value=plus>＋方向のみ検索
<input type=radio name=strand value=minus>－方向のみ検索" ;
($strand and $strand eq '+') ? $strand_selection =~ s/plus/plus checked/   :
($strand and $strand eq '-') ? $strand_selection =~ s/minus/minus checked/ :
                               $strand_selection =~ s/both/both checked/   ;
#-- △ strand選択ボタン
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
	STRAND => $strand_selection,
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
#ADD tyamamot synonym属性の追記
my $select = <<"--EOS--" ;
	<option value=\'hg38\'    synonym=\"$db_synonym{'hg38'   }\">$db_fullname{'hg38'   }</option>
	<option value=\'hg19\'    synonym=\"$db_synonym{'hg19'   }\">$db_fullname{'hg19'   }</option>
	<option value=\'hg18\'    synonym=\"$db_synonym{'hg18'   }\">$db_fullname{'hg18'   }</option>
	<option value=\'mm10\'    synonym=\"$db_synonym{'mm10'   }\">$db_fullname{'mm10'   }</option>
	<option value=\'mm9\'     synonym=\"$db_synonym{'mm9'    }\">$db_fullname{'mm9'    }</option>
	<option value=\'rn6\'     synonym=\"$db_synonym{'rn6'    }\">$db_fullname{'rn6'    }</option>
	<option value=\'rn5\'     synonym=\"$db_synonym{'rn5'    }\">$db_fullname{'rn5'    }</option>
	<option value=\'vicPac2\' synonym=\"$db_synonym{'vicPac2'}\">$db_fullname{'vicPac2'}</option>
	<option value=\'dasNov3\' synonym=\"$db_synonym{'dasNov3'}\">$db_fullname{'dasNov3'}</option>
	<option value=\'papAnu2\' synonym=\"$db_synonym{'papAnu2'}\">$db_fullname{'papAnu2'}</option>
	<option value=\'otoGar3\' synonym=\"$db_synonym{'otoGar3'}\">$db_fullname{'otoGar3'}</option>
	<option value=\'felCat5\' synonym=\"$db_synonym{'felCat5'}\">$db_fullname{'felCat5'}</option>
	<option value=\'panTro4\' synonym=\"$db_synonym{'panTro4'}\">$db_fullname{'panTro4'}</option>
	<option value=\'criGri1\' synonym=\"$db_synonym{'criGri1'}\">$db_fullname{'criGri1'}</option>
	<option value=\'bosTau8\' synonym=\"$db_synonym{'bosTau8'}\">$db_fullname{'bosTau8'}</option>
	<option value=\'canFam3\' synonym=\"$db_synonym{'canFam3'}\">$db_fullname{'canFam3'}</option>
	<option value=\'turTru2\' synonym=\"$db_synonym{'turTru2'}\">$db_fullname{'turTru2'}</option>
	<option value=\'loxAfr3\' synonym=\"$db_synonym{'loxAfr3'}\">$db_fullname{'loxAfr3'}</option>
	<option value=\'musFur1\' synonym=\"$db_synonym{'musFur1'}\">$db_fullname{'musFur1'}</option>
	<option value=\'nomLeu3\' synonym=\"$db_synonym{'nomLeu3'}\">$db_fullname{'nomLeu3'}</option>
	<option value=\'gorGor3\' synonym=\"$db_synonym{'gorGor3'}\">$db_fullname{'gorGor3'}</option>
	<option value=\'cavPor3\' synonym=\"$db_synonym{'cavPor3'}\">$db_fullname{'cavPor3'}</option>
	<option value=\'eriEur2\' synonym=\"$db_synonym{'eriEur2'}\">$db_fullname{'eriEur2'}</option>
	<option value=\'equCab2\' synonym=\"$db_synonym{'equCab2'}\">$db_fullname{'equCab2'}</option>
	<option value=\'dipOrd1\' synonym=\"$db_synonym{'dipOrd1'}\">$db_fullname{'dipOrd1'}</option>
	<option value=\'triMan1\' synonym=\"$db_synonym{'triMan1'}\">$db_fullname{'triMan1'}</option>
	<option value=\'calJac3\' synonym=\"$db_synonym{'calJac3'}\">$db_fullname{'calJac3'}</option>
	<option value=\'pteVam1\' synonym=\"$db_synonym{'pteVam1'}\">$db_fullname{'pteVam1'}</option>
	<option value=\'myoLuc2\' synonym=\"$db_synonym{'myoLuc2'}\">$db_fullname{'myoLuc2'}</option>
	<option value=\'balAcu1\' synonym=\"$db_synonym{'balAcu1'}\">$db_fullname{'balAcu1'}</option>
	<option value=\'micMur1\' synonym=\"$db_synonym{'micMur1'}\">$db_fullname{'micMur1'}</option>
	<option value=\'hetGla2\' synonym=\"$db_synonym{'hetGla2'}\">$db_fullname{'hetGla2'}</option>
	<option value=\'monDom5\' synonym=\"$db_synonym{'monDom5'}\">$db_fullname{'monDom5'}</option>
	<option value=\'ponAbe2\' synonym=\"$db_synonym{'ponAbe2'}\">$db_fullname{'ponAbe2'}</option>
	<option value=\'ailMel1\' synonym=\"$db_synonym{'ailMel1'}\">$db_fullname{'ailMel1'}</option>
	<option value=\'susScr3\' synonym=\"$db_synonym{'susScr3'}\">$db_fullname{'susScr3'}</option>
	<option value=\'ochPri3\' synonym=\"$db_synonym{'ochPri3'}\">$db_fullname{'ochPri3'}</option>
	<option value=\'ornAna1\' synonym=\"$db_synonym{'ornAna1'}\">$db_fullname{'ornAna1'}</option>
	<option value=\'oryCun2\' synonym=\"$db_synonym{'oryCun2'}\">$db_fullname{'oryCun2'}</option>
	<option value=\'rheMac3\' synonym=\"$db_synonym{'rheMac3'}\">$db_fullname{'rheMac3'}</option>
	<option value=\'proCap1\' synonym=\"$db_synonym{'proCap1'}\">$db_fullname{'proCap1'}</option>
	<option value=\'oviAri3\' synonym=\"$db_synonym{'oviAri3'}\">$db_fullname{'oviAri3'}</option>
	<option value=\'sorAra2\' synonym=\"$db_synonym{'sorAra2'}\">$db_fullname{'sorAra2'}</option>
	<option value=\'choHof1\' synonym=\"$db_synonym{'choHof1'}\">$db_fullname{'choHof1'}</option>
	<option value=\'speTri2\' synonym=\"$db_synonym{'speTri2'}\">$db_fullname{'speTri2'}</option>
	<option value=\'saiBol1\' synonym=\"$db_synonym{'saiBol1'}\">$db_fullname{'saiBol1'}</option>
	<option value=\'tarSyr1\' synonym=\"$db_synonym{'tarSyr1'}\">$db_fullname{'tarSyr1'}</option>
	<option value=\'sarHar1\' synonym=\"$db_synonym{'sarHar1'}\">$db_fullname{'sarHar1'}</option>
	<option value=\'echTel2\' synonym=\"$db_synonym{'echTel2'}\">$db_fullname{'echTel2'}</option>
	<option value=\'tupBel1\' synonym=\"$db_synonym{'tupBel1'}\">$db_fullname{'tupBel1'}</option>
	<option value=\'macEug2\' synonym=\"$db_synonym{'macEug2'}\">$db_fullname{'macEug2'}</option>
	<option value=\'cerSim1\' synonym=\"$db_synonym{'cerSim1'}\">$db_fullname{'cerSim1'}</option>
	<option value=\'allMis1\' synonym=\"$db_synonym{'allMis1'}\">$db_fullname{'allMis1'}</option>
	<option value=\'gadMor1\' synonym=\"$db_synonym{'gadMor1'}\">$db_fullname{'gadMor1'}</option>
	<option value=\'melUnd1\' synonym=\"$db_synonym{'melUnd1'}\">$db_fullname{'melUnd1'}</option>
	<option value=\'galGal4\' synonym=\"$db_synonym{'galGal4'}\">$db_fullname{'galGal4'}</option>
	<option value=\'latCha1\' synonym=\"$db_synonym{'latCha1'}\">$db_fullname{'latCha1'}</option>
	<option value=\'calMil1\' synonym=\"$db_synonym{'calMil1'}\">$db_fullname{'calMil1'}</option>
	<option value=\'fr3\'     synonym=\"$db_synonym{'fr3'    }\">$db_fullname{'fr3'    }</option>
	<option value=\'petMar2\' synonym=\"$db_synonym{'petMar2'}\">$db_fullname{'petMar2'}</option>
	<option value=\'anoCar2\' synonym=\"$db_synonym{'anoCar2'}\">$db_fullname{'anoCar2'}</option>
	<option value=\'oryLat2\' synonym=\"$db_synonym{'oryLat2'}\">$db_fullname{'oryLat2'}</option>
	<option value=\'geoFor1\' synonym=\"$db_synonym{'geoFor1'}\">$db_fullname{'geoFor1'}</option>
	<option value=\'oreNil2\' synonym=\"$db_synonym{'oreNil2'}\">$db_fullname{'oreNil2'}</option>
	<option value=\'chrPic1\' synonym=\"$db_synonym{'chrPic1'}\">$db_fullname{'chrPic1'}</option>
	<option value=\'gasAcu1\' synonym=\"$db_synonym{'gasAcu1'}\">$db_fullname{'gasAcu1'}</option>
	<option value=\'tetNig2\' synonym=\"$db_synonym{'tetNig2'}\">$db_fullname{'tetNig2'}</option>
	<option value=\'melGal1\' synonym=\"$db_synonym{'melGal1'}\">$db_fullname{'melGal1'}</option>
	<option value=\'Xenla7\'  synonym=\"$db_synonym{'Xenla7' }\">$db_fullname{'Xenla7' }</option>
	<option value=\'Xentr8\'  synonym=\"$db_synonym{'Xentr8' }\">$db_fullname{'Xentr8' }</option>
	<option value=\'Xentr7\'  synonym=\"$db_synonym{'Xentr7' }\">$db_fullname{'Xentr7' }</option>
	<option value=\'xenTro3\' synonym=\"$db_synonym{'xenTro3'}\">$db_fullname{'xenTro3'}</option>
	<option value=\'taeGut2\' synonym=\"$db_synonym{'taeGut2'}\">$db_fullname{'taeGut2'}</option>
	<option value=\'danRer7\' synonym=\"$db_synonym{'danRer7'}\">$db_fullname{'danRer7'}</option>
	<option value=\'ci2\'     synonym=\"$db_synonym{'ci2'    }\">$db_fullname{'ci2'    }</option>
	<option value=\'braFlo1\' synonym=\"$db_synonym{'braFlo1'}\">$db_fullname{'braFlo1'}</option>
	<option value=\'strPur2\' synonym=\"$db_synonym{'strPur2'}\">$db_fullname{'strPur2'}</option>
	<option value=\'anoGam1\' synonym=\"$db_synonym{'anoGam1'}\">$db_fullname{'anoGam1'}</option>
	<option value=\'apiMel2\' synonym=\"$db_synonym{'apiMel2'}\">$db_fullname{'apiMel2'}</option>
	<option value=\'droAna2\' synonym=\"$db_synonym{'droAna2'}\">$db_fullname{'droAna2'}</option>
	<option value=\'droEre1\' synonym=\"$db_synonym{'droEre1'}\">$db_fullname{'droEre1'}</option>
	<option value=\'droGri1\' synonym=\"$db_synonym{'droGri1'}\">$db_fullname{'droGri1'}</option>
	<option value=\'dm6\'     synonym=\"$db_synonym{'dm6'    }\">$db_fullname{'dm6'    }</option>
	<option value=\'dm3\'     synonym=\"$db_synonym{'dm3'    }\">$db_fullname{'dm3'    }</option>
	<option value=\'droMoj2\' synonym=\"$db_synonym{'droMoj2'}\">$db_fullname{'droMoj2'}</option>
	<option value=\'droPer1\' synonym=\"$db_synonym{'droPer1'}\">$db_fullname{'droPer1'}</option>
	<option value=\'dp3\'     synonym=\"$db_synonym{'dp3'    }\">$db_fullname{'dp3'    }</option>
	<option value=\'droSec1\' synonym=\"$db_synonym{'droSec1'}\">$db_fullname{'droSec1'}</option>
	<option value=\'droSim1\' synonym=\"$db_synonym{'droSim1'}\">$db_fullname{'droSim1'}</option>
	<option value=\'droVir2\' synonym=\"$db_synonym{'droVir2'}\">$db_fullname{'droVir2'}</option>
	<option value=\'droYak2\' synonym=\"$db_synonym{'droYak2'}\">$db_fullname{'droYak2'}</option>
	<option value=\'caePb2\'  synonym=\"$db_synonym{'caePb2' }\">$db_fullname{'caePb2' }</option>
	<option value=\'cb3\'     synonym=\"$db_synonym{'cb3'    }\">$db_fullname{'cb3'    }</option>
	<option value=\'ce10\'    synonym=\"$db_synonym{'ce10'   }\">$db_fullname{'ce10'   }</option>
	<option value=\'caeJap1\' synonym=\"$db_synonym{'caeJap1'}\">$db_fullname{'caeJap1'}</option>
	<option value=\'caeRem3\' synonym=\"$db_synonym{'caeRem3'}\">$db_fullname{'caeRem3'}</option>
	<option value=\'priPac1\' synonym=\"$db_synonym{'priPac1'}\">$db_fullname{'priPac1'}</option>
	<option value=\'sacCer3\' synonym=\"$db_synonym{'sacCer3'}\">$db_fullname{'sacCer3'}</option>
	<option value=\'aplCal1\' synonym=\"$db_synonym{'aplCal1'}\">$db_fullname{'aplCal1'}</option>

	<option value=\'OryAfe1.0\'      synonym=\"$db_synonym{'OryAfe1.0'     }\">$db_fullname{'OryAfe1.0'     }</option>
	<option value=\'PoeFor_5.1.2\'   synonym=\"$db_synonym{'PoeFor_5.1.2'  }\">$db_fullname{'PoeFor_5.1.2'  }</option>
	<option value=\'CSAV2.0\'        synonym=\"$db_synonym{'CSAV2.0'       }\">$db_fullname{'CSAV2.0'       }</option>
	<option value=\'AstMex102\'      synonym=\"$db_synonym{'AstMex102'     }\">$db_fullname{'AstMex102'     }</option>
	<option value=\'PelSin_1.0\'     synonym=\"$db_synonym{'PelSin_1.0'    }\">$db_fullname{'PelSin_1.0'    }</option>
	<option value=\'MacFas5.0\'      synonym=\"$db_synonym{'MacFas5.0'     }\">$db_fullname{'MacFas5.0'     }</option>
	<option value=\'BGI_duck_1.0\'   synonym=\"$db_synonym{'BGI_duck_1.0'  }\">$db_fullname{'BGI_duck_1.0'  }</option>
	<option value=\'FicAlb_1.4\'     synonym=\"$db_synonym{'FicAlb_1.4'    }\">$db_fullname{'FicAlb_1.4'    }</option>
	<option value=\'Pham\'           synonym=\"$db_synonym{'Pham'          }\">$db_fullname{'Pham'          }</option>
	<option value=\'Xipmac4.4.2\'    synonym=\"$db_synonym{'Xipmac4.4.2'   }\">$db_fullname{'Xipmac4.4.2'   }</option>
	<option value=\'MicOch1.0\'      synonym=\"$db_synonym{'MicOch1.0'     }\">$db_fullname{'MicOch1.0'     }</option>
	<option value=\'PhyMac_2.0.2\'   synonym=\"$db_synonym{'PhyMac_2.0.2'  }\">$db_fullname{'PhyMac_2.0.2'  }</option>
	<option value=\'LepOcu1\'        synonym=\"$db_synonym{'LepOcu1'       }\">$db_fullname{'LepOcu1'       }</option>
	<option value=\'ChlSab1.1\'      synonym=\"$db_synonym{'ChlSab1.1'     }\">$db_fullname{'ChlSab1.1'     }</option>
	<option value=\'Acyr_2.0\'       synonym=\"$db_synonym{'Acyr_2.0'      }\">$db_fullname{'Acyr_2.0'      }</option>
	<option value=\'AaegL3\'         synonym=\"$db_synonym{'AaegL3'        }\">$db_fullname{'AaegL3'        }</option>
	<option value=\'Aqu1\'           synonym=\"$db_synonym{'Aqu1'          }\">$db_fullname{'Aqu1'          }</option>
	<option value=\'AdarC3\'         synonym=\"$db_synonym{'AdarC3'        }\">$db_fullname{'AdarC3'        }</option>
	<option value=\'Attacep1.0\'     synonym=\"$db_synonym{'Attacep1.0'    }\">$db_fullname{'Attacep1.0'    }</option>
	<option value=\'ASM15162v1\'     synonym=\"$db_synonym{'ASM15162v1'    }\">$db_fullname{'ASM15162v1'    }</option>
	<option value=\'B_malayi_3.0\'   synonym=\"$db_synonym{'B_malayi_3.0'  }\">$db_fullname{'B_malayi_3.0'  }</option>
	<option value=\'Capte_v1.0\'     synonym=\"$db_synonym{'Capte_v1.0'    }\">$db_fullname{'Capte_v1.0'    }</option>
	<option value=\'oyster_v9\'      synonym=\"$db_synonym{'oyster_v9'     }\">$db_fullname{'oyster_v9'     }</option>
	<option value=\'CpipJ2\'         synonym=\"$db_synonym{'CpipJ2'        }\">$db_fullname{'CpipJ2'        }</option>
	<option value=\'DanPle_1.0\'     synonym=\"$db_synonym{'DanPle_1.0'    }\">$db_fullname{'DanPle_1.0'    }</option>
	<option value=\'Dappu_V1.0\'     synonym=\"$db_synonym{'Dappu_V1.0'    }\">$db_fullname{'Dappu_V1.0'    }</option>
	<option value=\'DendPond_1.0\'   synonym=\"$db_synonym{'DendPond_1.0'  }\">$db_fullname{'DendPond_1.0'  }</option>
	<option value=\'dwil_caf1\'      synonym=\"$db_synonym{'dwil_caf1'     }\">$db_fullname{'dwil_caf1'     }</option>
	<option value=\'Hmel1\'          synonym=\"$db_synonym{'Hmel1'         }\">$db_fullname{'Hmel1'         }</option>
	<option value=\'Helro1\'         synonym=\"$db_synonym{'Helro1'        }\">$db_fullname{'Helro1'        }</option>
	<option value=\'IscaW1\'         synonym=\"$db_synonym{'IscaW1'        }\">$db_fullname{'IscaW1'        }</option>
	<option value=\'Loa_loa_V3\'     synonym=\"$db_synonym{'Loa_loa_V3'    }\">$db_fullname{'Loa_loa_V3'    }</option>
	<option value=\'Lotgi1\'         synonym=\"$db_synonym{'Lotgi1'        }\">$db_fullname{'Lotgi1'        }</option>
	<option value=\'Msca1\'          synonym=\"$db_synonym{'Msca1'         }\">$db_fullname{'Msca1'         }</option>
	<option value=\'MelCinx1.0\'     synonym=\"$db_synonym{'MelCinx1.0'    }\">$db_fullname{'MelCinx1.0'    }</option>
	<option value=\'MneLei\'         synonym=\"$db_synonym{'MneLei'        }\">$db_fullname{'MneLei'        }</option>
	<option value=\'Nvit_2.1\'       synonym=\"$db_synonym{'Nvit_2.1'      }\">$db_fullname{'Nvit_2.1'      }</option>
	<option value=\'ASM20922v1\'     synonym=\"$db_synonym{'ASM20922v1'    }\">$db_fullname{'ASM20922v1'    }</option>
	<option value=\'Cameroon_v3\'    synonym=\"$db_synonym{'Cameroon_v3'   }\">$db_fullname{'Cameroon_v3'   }</option>
	<option value=\'PhumU2\'         synonym=\"$db_synonym{'PhumU2'        }\">$db_fullname{'PhumU2'        }</option>
	<option value=\'RproC1\'         synonym=\"$db_synonym{'RproC1'        }\">$db_fullname{'RproC1'        }</option>
	<option value=\'ASM23792v2\'     synonym=\"$db_synonym{'ASM23792v2'    }\">$db_fullname{'ASM23792v2'    }</option>
	<option value=\'Si_gnG\'         synonym=\"$db_synonym{'Si_gnG'        }\">$db_fullname{'Si_gnG'        }</option>
	<option value=\'Smar1\'          synonym=\"$db_synonym{'Smar1'         }\">$db_fullname{'Smar1'         }</option>
	<option value=\'ASM23943v1\'     synonym=\"$db_synonym{'ASM23943v1'    }\">$db_fullname{'ASM23943v1'    }</option>
	<option value=\'Tcas3\'          synonym=\"$db_synonym{'Tcas3'         }\">$db_fullname{'Tcas3'         }</option>
	<option value=\'Tspiralis1\'     synonym=\"$db_synonym{'Tspiralis1'    }\">$db_fullname{'Tspiralis1'    }</option>
	<option value=\'ASM15027v1\'     synonym=\"$db_synonym{'ASM15027v1'    }\">$db_fullname{'ASM15027v1'    }</option>
	<option value=\'ZooNev1.0\'      synonym=\"$db_synonym{'ZooNev1.0'     }\">$db_fullname{'ZooNev1.0'     }</option>
	<option value=\'ASM34733v1\'     synonym=\"$db_synonym{'ASM34733v1'    }\">$db_fullname{'ASM34733v1'    }</option>
	<option value=\'AMTR1.0\'        synonym=\"$db_synonym{'AMTR1.0'       }\">$db_fullname{'AMTR1.0'       }</option>
	<option value=\'Araly_v.1.0\'    synonym=\"$db_synonym{'Araly_v.1.0'   }\">$db_fullname{'Araly_v.1.0'   }</option>
	<option value=\'TAIR10_en\'      synonym=\"$db_synonym{'TAIR10_en'     }\">$db_fullname{'TAIR10_en'     }</option>
	<option value=\'Bradi_v1.0\'     synonym=\"$db_synonym{'Bradi_v1.0'    }\">$db_fullname{'Bradi_v1.0'    }</option>
	<option value=\'Braol_v2.1\'     synonym=\"$db_synonym{'Braol_v2.1'    }\">$db_fullname{'Braol_v2.1'    }</option>
	<option value=\'IVFCAASv1\'      synonym=\"$db_synonym{'IVFCAASv1'     }\">$db_fullname{'IVFCAASv1'     }</option>
	<option value=\'Chlre_v3.1\'     synonym=\"$db_synonym{'Chlre_v3.1'    }\">$db_fullname{'Chlre_v3.1'    }</option>
	<option value=\'ASM9120v1\'      synonym=\"$db_synonym{'ASM9120v1'     }\">$db_fullname{'ASM9120v1'     }</option>
	<option value=\'Soybn_V1.0\'     synonym=\"$db_synonym{'Soybn_V1.0'    }\">$db_fullname{'Soybn_V1.0'    }</option>
	<option value=\'Horvu_v1\'       synonym=\"$db_synonym{'Horvu_v1'      }\">$db_fullname{'Horvu_v1'      }</option>
	<option value=\'Lperr_V1.4\'     synonym=\"$db_synonym{'Lperr_V1.4'    }\">$db_fullname{'Lperr_V1.4'    }</option>
	<option value=\'MedtrA17_4.0\'   synonym=\"$db_synonym{'MedtrA17_4.0'  }\">$db_fullname{'MedtrA17_4.0'  }</option>
	<option value=\'MA1\'            synonym=\"$db_synonym{'MA1'           }\">$db_fullname{'MA1'           }</option>
	<option value=\'Obart_v1.0\'     synonym=\"$db_synonym{'Obart_v1.0'    }\">$db_fullname{'Obart_v1.0'    }</option>
	<option value=\'Orybr_v1.4b\'    synonym=\"$db_synonym{'Orybr_v1.4b'   }\">$db_fullname{'Orybr_v1.4b'   }</option>
	<option value=\'AGI1.1\'         synonym=\"$db_synonym{'AGI1.1'        }\">$db_fullname{'AGI1.1'        }</option>
	<option value=\'Orygl\'          synonym=\"$db_synonym{'Orygl'         }\">$db_fullname{'Orygl'         }</option>
	<option value=\'Orylo_v0117\'    synonym=\"$db_synonym{'Orylo_v0117'   }\">$db_fullname{'Orylo_v0117'   }</option>
	<option value=\'Oryme_v1.3\'     synonym=\"$db_synonym{'Oryme_v1.3'    }\">$db_fullname{'Oryme_v1.3'    }</option>
	<option value=\'Oryni\'          synonym=\"$db_synonym{'Oryni'         }\">$db_fullname{'Oryni'         }</option>
	<option value=\'Orypu\'          synonym=\"$db_synonym{'Orypu'         }\">$db_fullname{'Orypu'         }</option>
	<option value=\'PRJEB4137\'      synonym=\"$db_synonym{'PRJEB4137'     }\">$db_fullname{'PRJEB4137'     }</option>
	<option value=\'ASM465v1\'       synonym=\"$db_synonym{'ASM465v1'      }\">$db_fullname{'ASM465v1'      }</option>
	<option value=\'ASM9206v1\'      synonym=\"$db_synonym{'ASM9206v1'     }\">$db_fullname{'ASM9206v1'     }</option>
	<option value=\'ASM242v1\'       synonym=\"$db_synonym{'ASM242v1'      }\">$db_fullname{'ASM242v1'      }</option>
	<option value=\'Poptr_JGI2.0\'   synonym=\"$db_synonym{'Poptr_JGI2.0'  }\">$db_fullname{'Poptr_JGI2.0'  }</option>
	<option value=\'Prupe1_0\'       synonym=\"$db_synonym{'Prupe1_0'      }\">$db_fullname{'Prupe1_0'      }</option>
	<option value=\'Selml_v1.0\'     synonym=\"$db_synonym{'Selml_v1.0'    }\">$db_fullname{'Selml_v1.0'    }</option>
	<option value=\'Setit_JGIv2.0\'  synonym=\"$db_synonym{'Setit_JGIv2.0' }\">$db_fullname{'Setit_JGIv2.0' }</option>
	<option value=\'SL2.50\'         synonym=\"$db_synonym{'SL2.50'        }\">$db_fullname{'SL2.50'        }</option>
	<option value=\'SolTub_3.0\'     synonym=\"$db_synonym{'SolTub_3.0'    }\">$db_fullname{'SolTub_3.0'    }</option>
	<option value=\'Sorbi1\'         synonym=\"$db_synonym{'Sorbi1'        }\">$db_fullname{'Sorbi1'        }</option>
	<option value=\'Thecc_20110822\' synonym=\"$db_synonym{'Thecc_20110822'}\">$db_fullname{'Thecc_20110822'}</option>
	<option value=\'IWGSC1.0\'       synonym=\"$db_synonym{'IWGSC1.0'      }\">$db_fullname{'IWGSC1.0'      }</option>
	<option value=\'ASM34745v1\'     synonym=\"$db_synonym{'ASM34745v1'    }\">$db_fullname{'ASM34745v1'    }</option>
	<option value=\'IGGP_12x\'       synonym=\"$db_synonym{'IGGP_12x'      }\">$db_fullname{'IGGP_12x'      }</option>
	<option value=\'AGPv3\'          synonym=\"$db_synonym{'AGPv3'         }\">$db_fullname{'AGPv3'         }</option>

	<option value=\'macaque_CE_1\' synonym=\"$db_synonym{'macaque_CE_1'}\">$db_fullname{'macaque_CE_1'}</option>
	<option value=\'bmor1\'   synonym=\"$db_synonym{'bmor1'  }\">$db_fullname{'bmor1'  }</option>
	<option value=\'pombe\'   synonym=\"$db_synonym{'pombe'  }\">$db_fullname{'pombe'  }</option>

	<option value=\'TAIR10\'  synonym=\"$db_synonym{'TAIR10' }\">$db_fullname{'TAIR10' }</option>
	<option value=\'rice\'    synonym=\"$db_synonym{'rice'   }\">$db_fullname{'rice'   }</option>
	<option value=\'sorBic\'  synonym=\"$db_synonym{'sorBic' }\">$db_fullname{'sorBic' }</option>
	<option value=\'Ppatens_251_v3\'           synonym=\"$db_synonym{'Ppatens_251_v3'          }\">$db_fullname{'Ppatens_251_v3'          }</option>
	<option value=\'Smoellendorffii_91_v1\'    synonym=\"$db_synonym{'Smoellendorffii_91_v1'   }\">$db_fullname{'Smoellendorffii_91_v1'   }</option>
	<option value=\'Creinhardtii_281_v5_5\'    synonym=\"$db_synonym{'Creinhardtii_281_v5_5'   }\">$db_fullname{'Creinhardtii_281_v5_5'   }</option>
	<option value=\'Olucimarinus_231_v2\'      synonym=\"$db_synonym{'Olucimarinus_231_v2'     }\">$db_fullname{'Olucimarinus_231_v2'     }</option>
	<option value=\'Cgrandiflora_v1\'          synonym=\"$db_synonym{'Cgrandiflora_v1'         }\">$db_fullname{'Cgrandiflora_v1'         }</option>
	<option value=\'Crubella_v1\'              synonym=\"$db_synonym{'Crubella_v1'             }\">$db_fullname{'Crubella_v1'             }</option>
	<option value=\'Cpapaya_r.Dec2008\'        synonym=\"$db_synonym{'Cpapaya_r.Dec2008'       }\">$db_fullname{'Cpapaya_r.Dec2008'       }</option>
	<option value=\'CsubellipsoideaC169_v2.0\' synonym=\"$db_synonym{'CsubellipsoideaC169_v2.0'}\">$db_fullname{'CsubellipsoideaC169_v2.0'}</option>
	<option value=\'Csativus_v1\'              synonym=\"$db_synonym{'Csativus_v1'             }\">$db_fullname{'Csativus_v1'             }</option>
	<option value=\'Egrandis_v2.0\'            synonym=\"$db_synonym{'Egrandis_v2.0'           }\">$db_fullname{'Egrandis_v2.0'           }</option>
	<option value=\'Fvesca_v1.1\'              synonym=\"$db_synonym{'Fvesca_v1.1'             }\">$db_fullname{'Fvesca_v1.1'             }</option>
	<option value=\'Graimondii_v2.0\'          synonym=\"$db_synonym{'Graimondii_v2.0'         }\">$db_fullname{'Graimondii_v2.0'         }</option>
	<option value=\'Lusitatissimum_BGIv1.0\'   synonym=\"$db_synonym{'Lusitatissimum_BGIv1.0'  }\">$db_fullname{'Lusitatissimum_BGIv1.0'  }</option>
	<option value=\'Mdomestica_v1.0\'          synonym=\"$db_synonym{'Mdomestica_v1.0'         }\">$db_fullname{'Mdomestica_v1.0'         }</option>
	<option value=\'Mesculenta_v6\'            synonym=\"$db_synonym{'Mesculenta_v6'           }\">$db_fullname{'Mesculenta_v6'           }</option>
	<option value=\'MpusillaCCMP1545_v3.0\'    synonym=\"$db_synonym{'MpusillaCCMP1545_v3.0'   }\">$db_fullname{'MpusillaCCMP1545_v3.0'   }</option>
	<option value=\'MpusillaRCC299_v3.0\'      synonym=\"$db_synonym{'MpusillaRCC299_v3.0'     }\">$db_fullname{'MpusillaRCC299_v3.0'     }</option>
	<option value=\'Mguttatus_v2.0\'           synonym=\"$db_synonym{'Mguttatus_v2.0'          }\">$db_fullname{'Mguttatus_v2.0'          }</option>
	<option value=\'Ppersica_v2.0\'            synonym=\"$db_synonym{'Ppersica_v2.0'           }\">$db_fullname{'Ppersica_v2.0'           }</option>
	<option value=\'Rcommunis_TIGR.0.1\'       synonym=\"$db_synonym{'Rcommunis_TIGR.0.1'      }\">$db_fullname{'Rcommunis_TIGR.0.1'      }</option>
	<option value=\'Spolyrhiza_v1\'            synonym=\"$db_synonym{'Spolyrhiza_v1'           }\">$db_fullname{'Spolyrhiza_v1'           }</option>
	<option value=\'Vcarteri_v2\'              synonym=\"$db_synonym{'Vcarteri_v2'             }\">$db_fullname{'Vcarteri_v2'             }</option>

	<option value=\'eboVir3\' synonym=\"$db_synonym{'eboVir3'}\">$db_fullname{'eboVir3'}</option>

	<option disabled>--------------------</option>

	<option value=\'refseq\'      synonym=\"$db_synonym{'refseq'     }\">$db_fullname{'refseq'     }</option>
	<option value=\'hs_refseq70\' synonym=\"$db_synonym{'hs_refseq70'}\">$db_fullname{'hs_refseq70'}</option>
	<option value=\'mm_refseq70\' synonym=\"$db_synonym{'mm_refseq70'}\">$db_fullname{'mm_refseq70'}</option>
	<option value=\'rn_refseq70\' synonym=\"$db_synonym{'rn_refseq70'}\">$db_fullname{'rn_refseq70'}</option>
	<option value=\'prok\'        synonym=\"$db_synonym{'prok'       }\">$db_fullname{'prok'       }</option>
	<option value=\'16SrRNA\'     synonym=\"$db_synonym{'16SrRNA'    }\">$db_fullname{'16SrRNA'    }</option>
	<option value=\'macaque_CE_1_cds\' synonym=\"$db_synonym{'macaque_CE_1_cds'}\">$db_fullname{'macaque_CE_1_cds'}</option>

	<option disabled>--------------------</option>

	<option value=\'ddbj101hum\' synonym=\"$db_synonym{'ddbj101hum'}\">$db_fullname{'ddbj101hum'}</option>
	<option value=\'ddbj101pri\' synonym=\"$db_synonym{'ddbj101pri'}\">$db_fullname{'ddbj101pri'}</option>
	<option value=\'ddbj101rod\' synonym=\"$db_synonym{'ddbj101rod'}\">$db_fullname{'ddbj101rod'}</option>
	<option value=\'ddbj101mam\' synonym=\"$db_synonym{'ddbj101mam'}\">$db_fullname{'ddbj101mam'}</option>
	<option value=\'ddbj101vrt\' synonym=\"$db_synonym{'ddbj101vrt'}\">$db_fullname{'ddbj101vrt'}</option>
	<option value=\'ddbj101inv\' synonym=\"$db_synonym{'ddbj101inv'}\">$db_fullname{'ddbj101inv'}</option>
	<option value=\'ddbj101pln\' synonym=\"$db_synonym{'ddbj101pln'}\">$db_fullname{'ddbj101pln'}</option>
	<option value=\'ddbj101bct\' synonym=\"$db_synonym{'ddbj101bct'}\">$db_fullname{'ddbj101bct'}</option>
	<option value=\'ddbj101vrl\' synonym=\"$db_synonym{'ddbj101vrl'}\">$db_fullname{'ddbj101vrl'}</option>
	<option value=\'ddbj101phg\' synonym=\"$db_synonym{'ddbj101phg'}\">$db_fullname{'ddbj101phg'}</option>
	<option value=\'ddbj101pat\' synonym=\"$db_synonym{'ddbj101pat'}\">$db_fullname{'ddbj101pat'}</option>
	<option value=\'ddbj101env\' synonym=\"$db_synonym{'ddbj101env'}\">$db_fullname{'ddbj101env'}</option>
	<option value=\'ddbj101syn\' synonym=\"$db_synonym{'ddbj101syn'}\">$db_fullname{'ddbj101syn'}</option>
	<option value=\'ddbj101est\' synonym=\"$db_synonym{'ddbj101est'}\">$db_fullname{'ddbj101est'}</option>
	<option value=\'ddbj101tsa\' synonym=\"$db_synonym{'ddbj101tsa'}\">$db_fullname{'ddbj101tsa'}</option>
	<option value=\'ddbj101gss\' synonym=\"$db_synonym{'ddbj101gss'}\">$db_fullname{'ddbj101gss'}</option>
	<option value=\'ddbj101htc\' synonym=\"$db_synonym{'ddbj101htc'}\">$db_fullname{'ddbj101htc'}</option>
	<option value=\'ddbj101htg\' synonym=\"$db_synonym{'ddbj101htg'}\">$db_fullname{'ddbj101htg'}</option>
	<option value=\'ddbj101sts\' synonym=\"$db_synonym{'ddbj101sts'}\">$db_fullname{'ddbj101sts'}</option>
	<option value=\'ddbj101una\' synonym=\"$db_synonym{'ddbj101una'}\">$db_fullname{'ddbj101una'}</option>
	<option value=\'ddbj\'       synonym=\"$db_synonym{'ddbj'      }\">$db_fullname{'ddbj'      }</option>
--EOS--

$db and $select =~ s/(?<=option value=$db)/ selected/ or  # 種を選択
	$db_fullname{$db} and $select =                       # 種を追加
		"	<option value=$db selected>$db_fullname{$db}</option>\n" .
		"	<option disabled>----------</option>\n" . $select or
	$select =~ s/(?<=option value=hg19)/ selected/ ;      # default: Human genome (hg19)
#-- △ プルダウンメニュー

#-- ▽ strand選択ボタン
my $strand_selection =
"Search for:
<input type=radio name=strand value=both>both strand
<input type=radio name=strand value=plus>plus strand
<input type=radio name=strand value=minus>minus strand" ;
($strand and $strand eq '+') ? $strand_selection =~ s/plus/plus checked/   :
($strand and $strand eq '-') ? $strand_selection =~ s/minus/minus checked/ :
                               $strand_selection =~ s/both/both checked/   ;
#-- △ strand選択ボタン
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

<hr> <!-- __________________________________________________ -->
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
	STRAND => $strand_selection,
	CHATA  => $chata,
	HTML   => $html
) ;

print "Content-type: text/html; charset=utf-8\n\n" ;
print $template_index->output ;
#- ▲ HTML出力

return ;
} ;
# ====================
