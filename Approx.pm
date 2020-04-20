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
sub approx_core {  # 曖昧検索サーバに問い合わせを行う
my $q     = $_[0] or return () ;
my $host  = $_[1] or return () ;
my $port  = $_[2] or return () ;
my $k     = $_[3] // 0  ;
my $nogap = ($_[4] // 0) ? 1 : 0 ;
my $limit = $_[5] // '' ;
my $offset  = $_[6] // 0   ;	#ADD tyamamot offsetの追加
my $timeout = $_[7] // 180 ;	#ADD tyamamot timeoutの追加
#CHANGE tyamamot offsetの値を送るようにする
my $uri   = "http://$host:$port/match?q=$q&k=$k&no_gap=$nogap&offset=$offset&limit=$limit" ;

#CHANGE tyamamot timeoutを使用するようにする
$ua->timeout($timeout) ;
my $json  = get($uri) or return () ;
return (decode_json($json) // (), $uri) ;
} ;
# ====================

return 1 ;
