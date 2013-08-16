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
use LWP::Simple ;  # 曖昧検索サーバとの接続に使用
use JSON::XS ;     # 曖昧検索サーバとの接続に使用

# ====================
sub approx_q {  # 曖昧検索サーバに問い合わせを行う
my $q     = $_[0] or return () ;
my $port  = $_[1] or return () ;
my $k     = $_[2] // 0  ;
my $limit = $_[3] // '' ;
my $host  = '172.17.1.21' ;  # ssd.dbcls.jp (曖昧検索サーバ)
my $uri   = "http://$host:$port/match?q=$q&k=$k&offset=0&limit=$limit" ;
my $json  = get($uri) or return () ;
return (decode_json($json) // (), $uri) ;
} ;
# ====================

return 1 ;
