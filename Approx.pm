package Approx ;

# 曖昧検索サーバに問い合わせを行うためのモジュール
#
# 必要なモジュール：
# LWP::Simple
# JSON::XS
#
# 2013-08-16 Yuki Naito (@meso_cacase)

use warnings ;
use strict ;
use LWP::Simple qw($ua get) ;  # 曖昧検索サーバとの接続に使用
use JSON::XS ;                 # 曖昧検索サーバとの接続に使用

# ====================
sub approx_q {

# 曖昧検索サーバに問い合わせを行う
# 縮重塩基は展開して個別に検索し、結果をマージする

my $q     = $_[0] or return () ;
my $host  = $_[1] or return () ;
my $port  = $_[2] or return () ;
my $k     = $_[3] // 0  ;
my $limit = $_[4] // '' ;
my $offset  = $_[5] // 0   ;	#ADD tyamamot offsetの追加
my $timeout = $_[6] // 180 ;	#ADD tyamamot timeoutの追加

# 縮重塩基の展開
my @q = iub_expand($q) ;

# 展開後の配列を検索
my @hit_all ;
my @uri_all ;
foreach (@q){
	my ($hit, $uri) = approx_core($_, $host, $port, $k, $limit, $offset, $timeout) ;	#ADD tyamamot offset,timeoutの追加
	push @hit_all, $hit ;
	push @uri_all, $uri ;
}

# 結果をマージ
my $hit_all = merge_approx_hit(@hit_all) ;
my $uri_all = join ' ', @uri_all ;

# 先頭から $limit 件だけ返す
@{$hit_all->{hits}} = splice @{$hit_all->{hits}}, 0, $limit ;

return ($hit_all, $uri_all) ;
} ;
# ====================
sub iub_expand {  # 塩基配列のIUBコードを展開してリストを返す
my @in = @_ ;
my @out ;
while (my $seq = shift @in){
	if (
		$seq =~ s/^(.*?)R(.*)$/$1A$2,$1G$2/             or  # R = A/G
		$seq =~ s/^(.*?)r(.*)$/$1a$2,$1g$2/             or
		$seq =~ s/^(.*?)Y(.*)$/$1T$2,$1C$2/             or  # Y = T/C
		$seq =~ s/^(.*?)y(.*)$/$1t$2,$1c$2/             or
		$seq =~ s/^(.*?)K(.*)$/$1T$2,$1G$2/             or  # K = T/G
		$seq =~ s/^(.*?)k(.*)$/$1t$2,$1g$2/             or
		$seq =~ s/^(.*?)M(.*)$/$1A$2,$1C$2/             or  # M = A/C
		$seq =~ s/^(.*?)m(.*)$/$1a$2,$1c$2/             or
		$seq =~ s/^(.*?)S(.*)$/$1G$2,$1C$2/             or  # S = G/C
		$seq =~ s/^(.*?)s(.*)$/$1g$2,$1c$2/             or
		$seq =~ s/^(.*?)W(.*)$/$1A$2,$1T$2/             or  # W = A/T
		$seq =~ s/^(.*?)w(.*)$/$1a$2,$1t$2/             or
		$seq =~ s/^(.*?)B(.*)$/$1T$2,$1G$2,$1C$2/       or  # B = T/G/C
		$seq =~ s/^(.*?)b(.*)$/$1t$2,$1g$2,$1c$2/       or
		$seq =~ s/^(.*?)D(.*)$/$1A$2,$1T$2,$1G$2/       or  # D = A/T/G
		$seq =~ s/^(.*?)d(.*)$/$1a$2,$1t$2,$1g$2/       or
		$seq =~ s/^(.*?)H(.*)$/$1A$2,$1T$2,$1C$2/       or  # H = A/T/C
		$seq =~ s/^(.*?)h(.*)$/$1a$2,$1t$2,$1c$2/       or
		$seq =~ s/^(.*?)V(.*)$/$1A$2,$1G$2,$1C$2/       or  # V = A/G/C
		$seq =~ s/^(.*?)v(.*)$/$1a$2,$1g$2,$1c$2/       or
		$seq =~ s/^(.*?)N(.*)$/$1A$2,$1T$2,$1G$2,$1C$2/ or  # N = A/T/G/C
		$seq =~ s/^(.*?)n(.*)$/$1a$2,$1t$2,$1g$2,$1c$2/
	){
		unshift @in, split(/,/, $seq) ;
	} else {
		push @out, $seq ;
	}
}
return @out ;
} ;
# ====================
sub approx_core {  # 曖昧検索サーバに問い合わせを行う
my $q     = $_[0] or return () ;
my $host  = $_[1] or return () ;
my $port  = $_[2] or return () ;
my $k     = $_[3] // 0  ;
my $limit = $_[4] // '' ;
my $offset  = $_[5] // 0   ;	#ADD tyamamot offsetの追加
my $timeout = $_[6] // 180 ;	#ADD tyamamot timeoutの追加
#CHANGE tyamamot offsetの値を送るようにする
my $uri   = "http://$host:$port/match?q=$q&k=$k&offset=$offset&limit=$limit" ;

#CHANGE tyamamot timeoutを使用するようにする
$ua->timeout($timeout) ;
my $json  = get($uri) or return () ;
return (decode_json($json) // (), $uri) ;
} ;
# ====================
sub merge_approx_hit {  # approx_hitの結果のうちjson出力部分をmerge
my @hit = @_ ;

my $hit_all ;
$hit_all->{total_hit_num}           = 0 ;
$hit_all->{total_hit_num_is_approx} = 0 ;
foreach (@hit){
	push @{$hit_all->{hits}}, @{$_->{hits}} ;  # ヒットをマージ
	$hit_all->{total_hit_num} +=
		($_->{total_hit_num} || 0) ;           # ヒット件数を加算
	$hit_all->{total_hit_num_is_approx} ||=
		$_->{total_hit_num_is_approx} ;        # ヒット件数が概算かどうかを統合
}

# ヒットした配列の並べ替え
@{$hit_all->{hits}} =
	sort { cmp_chrname($a->{docname}, $b->{docname}) || $a->{pos} <=> $b->{pos} }
	     @{$hit_all->{hits}} ;

# 未実装:ヒットした配列の重複を削除
# total_hit_numも重複を含んだヒット件数となっている

return $hit_all ;
} ;
# ====================
sub cmp_chrname {

# 染色体名を含む配列名のソート関数
# 染色体名はアルファベット順ではなく下記の順番でソートする
# chr1 -> chr2 -> chr10 -> chrX -> chrY -> chrM -> その他

my $a = $_[0] // '' ;
my $b = $_[1] // '' ;

$a =~ s/^>// ;  # 先頭の > を消去
$a =~ /^(chr|.*)(?:(\d+)|([XY])|(.*))?(.*)/ ;
my $a1 = $1 // '' ;
my $a2 = $2 // 0 ;
my $a3 = $3 // '' ;
my $a4 = $4 // '' ;
my $a5 = $5 // '' ;

$b =~ s/^>// ;  # 先頭の > を消去
$b =~ /^(chr|.*)(?:(\d+)|([XY])|(.*))?(.*)/ ;
my $b1 = $1 // '' ;
my $b2 = $2 // 0 ;
my $b3 = $3 // '' ;
my $b4 = $4 // '' ;
my $b5 = $5 // '' ;

return $a1 cmp $b1 || $a4 cmp $b4 || $a3 cmp $b3 || $a2 <=> $b2 || $a5 cmp $b5 ;
} ;
# ====================

return 1 ;
