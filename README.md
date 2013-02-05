GGGenome《ゲゲゲノム》
======================

ゲノム等の塩基配列を高速に検索するウェブサービスです。  
数塩基のミスマッチ、挿入、欠失を許容した配列検索が可能です。  
検索結果はHTMLのほか、タブ区切りテキストやJSONでも取得できます。

+ http://GGGenome.dbcls.jp/  
  本レポジトリにあるCGIが実際に稼働しています。

なお、本レポジトリはGGGenomeのウェブインターフェース部分です。  
ユーザからのリクエストを受け付け、検索を実行するサーチャにクエリを  
発行し、得られたデータを処理してユーザに検索結果を返します。


サンプル画像
-----

+ http://GGGenome.dbcls.jp/hg19/2/GCAAGAAGAGATTGCCCA  
  ヒトゲノムhg19に対して2ミスマッチ/ギャップ以内で GCAAGAAGAGATTGCCCA を検索

![スクリーンショット]
(http://g86.dbcls.jp/~meso/meme/wp-content/uploads/2013/02/GGGenome_screen.png
"GGGenome《ゲゲゲノム》スクリーンショットHTML")

+ http://GGGenome.dbcls.jp/hg19/2/GCAAGAAGAGATTGCCCA.json  
  上記の結果をJSONで取得

![スクリーンショット]
(http://g86.dbcls.jp/~meso/meme/wp-content/uploads/2013/02/GGGenome_json.png
"GGGenome《ゲゲゲノム》スクリーンショットJSON")


検索結果へのリンク (REST API仕様)
------

下記のように検索クエリとURIとが対応しています。

**URI:** http://GGGenome.dbcls.jp/<font 
  color=red>db</font>/<font 
  color=blue>k</font>/<font 
  color=green>sequence</font>[.<font 
  color=magenta>format</font>]

+ <font color=red>*db*</font> : 塩基配列データベース  
  'hg19' - ヒトゲノム [GRCh37/hg19 (Feb, 2009)]
           (http://hgdownload.soe.ucsc.edu/goldenPath/hg19/bigZips/)
           (省略時のデフォルト)  
  'mm10' - マウスゲノム [GRCm38/mm10 (Dec, 2011)]
           (http://hgdownload.soe.ucsc.edu/goldenPath/mm10/bigZips/)  
  'rn5'  - ラットゲノム [RGSC 5.0/rn5 (Mar, 2012)]  
           (http://hgdownload.soe.ucsc.edu/goldenPath/rn5/bigZips/)  
  'dm3'  - ショウジョウバエゲノム [BDGP Rel. 5/dm3 (Apr, 2006)]  
           (http://hgdownload.soe.ucsc.edu/goldenPath/dm3/bigZips/)  
  'ce10' - 線虫ゲノム [WS220/ce10 (Oct, 2010)]  
           (http://hgdownload.soe.ucsc.edu/goldenPath/ce10/bigZips/)  
  'refseq' - [RefSeq complete RNA release 57 (Jan, 2013)]  
           (ftp://ftp.ncbi.nlm.nih.gov/refseq/release/complete/)  
  'ddbj' - GenBank/EMBL/DDBJ塩基配列 [DDBJ release 89.0 (Jun, 2012)]  
           (ftp://ftp.ddbj.nig.ac.jp/ddbj_database/ddbj/)  
+ <font color=blue>*k*</font> : 許容するミスマッチ/ギャップの数  
  省略時のデフォルト: 0
+ <font color=green>*sequence*</font> : 塩基配列 (省略不可)
+ <font color=magenta>*format*</font> : 検索結果のフォーマット  
  'html' - HTML (省略時のデフォルト)  
  'txt' - タブ区切りテキスト  
  'json' - JSON  

**例1:** [http://GGGenome.dbcls.jp/<font 
  color=red>ce10</font>/<font 
  color=blue>1</font>/<font 
  color=green>GCAAGAAGAGATTGC</font>]
(http://GGGenome.dbcls.jp/ce10/1/GCAAGAAGAGATTGC)

+ 線虫ゲノム <font color=red>ce10</font> に対して
+ <font color=blue>1</font> ミスマッチ/ギャップまで許容して
+ <font color=green>GCAAGAAGAGATTGC</font> を検索し
+ <font color=magenta>html</font> (省略時のデフォルト) で結果を返す

**例2:** [http://GGGenome.dbcls.jp/<font 
  color=red>refseq</font>/<font 
  color=green>GCAAGAAGAGATTGC</font>.<font 
  color=magenta>txt</font>]
(http://GGGenome.dbcls.jp/refseq/GCAAGAAGAGATTGC.txt)

+ RefSeq complete RNA (<font color=red>refseq</font>) に対して
+ ミスマッチ/ギャップを許容せず (省略時のデフォルト)
+ <font color=green>GCAAGAAGAGATTGC</font> を検索し
+ タブ区切りテキスト (<font color=magenta>txt</font>) で結果を返す


関連プロジェクト
--------

+ 統合遺伝子検索GGRNA (http://GGRNA.dbcls.jp/)  
  遺伝子をGoogleのように検索できるウェブサーバ
  → [紹介記事](http://first.lifesciencedb.jp/from_dbcls/e0001)


ライセンス
--------

Copyright &copy; 2012-2013 Yuki Naito
 ([@meso_cacase](http://twitter.com/meso_cacase))  
This software is distributed under [modified BSD license]
 (http://www.opensource.org/licenses/bsd-license.php).
