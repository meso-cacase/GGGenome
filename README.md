GGGenome《ゲゲゲノム》
======================

ゲノム等の塩基配列を高速に検索するウェブサービスです。  
数塩基のミスマッチ、挿入、欠失を許容した配列検索が可能です。  
検索結果はHTMLのほか、タブ区切りテキスト、CSV、BED、GFF、JSONの各形式でも取得できます。

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

**URI:** http://GGGenome.dbcls.jp/db/k/sequence[.format][.download]

+ *db* : 塩基配列データベース  
  'hg19'        - ヒトゲノム [GRCh37/hg19 (Feb, 2009)]
                  (http://hgdownload.soe.ucsc.edu/goldenPath/hg19/bigZips/)
                  (省略時のデフォルト)  
  'mm10'        - マウスゲノム [GRCm38/mm10 (Dec, 2011)]
                  (http://hgdownload.soe.ucsc.edu/goldenPath/mm10/bigZips/)  
  'rn5'         - ラットゲノム [RGSC 5.0/rn5 (Mar, 2012)]
                  (http://hgdownload.soe.ucsc.edu/goldenPath/rn5/bigZips/)  
  'calJac3'     - マーモセットゲノム [WUGSC 3.2/calJac3 (Mar, 2009)]
                  (http://hgdownload.soe.ucsc.edu/goldenPath/calJac3/bigZips/)  
  'susScr3'     - ブタゲノム [SGSC Sscrofa10.2/susScr3 (Aug, 2011)]
                  (http://hgdownload.soe.ucsc.edu/goldenPath/susScr3/bigZips/)  
  'galGal4'     - ニワトリゲノム [ICGSC Gallus_gallus-4.0/galGal4 (Nov, 2011)]
                  (http://hgdownload.soe.ucsc.edu/goldenPath/galGal4/bigZips/)  
  'xenTro3'     - ネッタイツメガエルゲノム [JGI 4.2/xenTro3 (Nov, 2009)]
                  (http://hgdownload.soe.ucsc.edu/goldenPath/xenTro3/bigZips/)  
  'Xenla7'      - アフリカツメガエルゲノム [JGI 7.1/Xenla7 (Dec, 2013)]
                  (ftp://ftp.xenbase.org/pub/Genomics/JGI/Xenla7.1/Xenla_7.1_JGI_scaffolds_on_Xenbase_GBrowse.tgz)  
  'danRer7'     - ゼブラフィッシュゲノム [Zv9/danRer7 (Jul, 2010)]
                  (http://hgdownload.soe.ucsc.edu/goldenPath/danRer7/bigZips/)  
  'ci2'         - ホヤゲノム [JGI 2.1/ci2 (Mar, 2005)]
                  (http://hgdownload.soe.ucsc.edu/goldenPath/ci2/bigZips/)  
  'dm3'         - ショウジョウバエゲノム [BDGP R5/dm3 (Apr, 2006)]
                  (http://hgdownload.soe.ucsc.edu/goldenPath/dm3/bigZips/)  
  'ce10'        - 線虫ゲノム [WS220/ce10 (Oct, 2010)]
                  (http://hgdownload.soe.ucsc.edu/goldenPath/ce10/bigZips/)  
  'TAIR10'      - シロイヌナズナゲノム [TAIR10 (Nov, 2010)]
                  (ftp://ftp.arabidopsis.org/home/tair/Sequences/whole_chromosomes/)  
  'rice'        - イネゲノム [Os-Nipponbare-Reference-IRGSP-1.0 (Oct, 2011)]
                  (http://rapdb.dna.affrc.go.jp/download/irgsp1.html)  
  'sorBic'      - ソルガムゲノム [Sorghum bicolor v2.1 (May, 2013)]
                  (http://www.phytozome.net/dataUsagePolicy.php?org=Org_Sbicolor_v2.1)  
  'bmor1'       - カイコゲノム [Bmor1 (Apr, 2008)]
                  (ftp://ftp.ensemblgenomes.org/pub/metazoa/release-17/fasta/bombyx_mori/dna/)  
  'sacCer3'     - 出芽酵母ゲノム [sacCer3 (Apr, 2011)]
                  (http://hgdownload.soe.ucsc.edu/goldenPath/sacCer3/bigZips/)  
  'pombe'       - 分裂酵母ゲノム [ASM294v2 (Nov, 2007)]
                  (ftp://ftp.ensemblgenomes.org/pub/fungi/current/fasta/schizosaccharomyces_pombe/dna/Schizosaccharomyces_pombe.ASM294v2.23.dna.genome.fa.gz)  
  'refseq71'    - [RefSeq complete RNA release 71 (Jul, 2015)]
                  (ftp://ftp.ncbi.nlm.nih.gov/refseq/release/complete/)  
  'hs_refseq70' - [RefSeq human RNA release 70 (May, 2015)]
                  (ftp://ftp.ncbi.nlm.nih.gov/refseq/release/complete/)  
  'mm_refseq70' - [RefSeq mouse RNA release 70 (May, 2015)]
                  (ftp://ftp.ncbi.nlm.nih.gov/refseq/release/complete/)  
  'prok'        - Prokaryotic TogoGenome from RefSeq 62 (Nov, 2013)  
  'ddbj'        - GenBank/EMBL/DDBJ塩基配列 [DDBJ release 92.0 (Feb, 2013)]
                  (ftp://ftp.ddbj.nig.ac.jp/ddbj_database/ddbj/)  
+ *k* : 許容するミスマッチ/ギャップの数  
  省略時のデフォルト: 0
+ *strand* : 特定の方向のみ検索
  '+' または 'plus'  - プラス方向のみ検索
  '-' または 'minus' - マイナス方向のみ検索
  省略時は両方向を検索
+ *sequence* : 塩基配列 (省略不可)
+ *format* : 検索結果のフォーマット  
  'html' - HTML (省略時のデフォルト)  
  'txt'  - タブ区切りテキスト  
  'csv'  - CSV (comma-separated values) 形式  
  'bed'  - BED (browser extensible data) 形式  
  'gff'  - GFF (general feature format) 形式  
  'json' - JSON
+ *download* : 検索結果をファイルとしてダウンロード (txt, csv, bed, gff, jsonのみ)

**例1:** http://GGGenome.dbcls.jp/ce10/1/TTCATTGACAACATT

+ 線虫ゲノム ce10 に対して
+ 1 ミスマッチ/ギャップまで許容して
+ TTCATTGACAACATT を検索し
+ html (省略時のデフォルト) で結果を返す

**例2:** http://GGGenome.dbcls.jp/refseq/+/TTCATTGACAACATT.txt

+ RefSeq complete RNA (refseq) の最新版に対して
+ ミスマッチ/ギャップを許容せず (省略時のデフォルト)
+ 検索方向をプラス方向に限定し
+ TTCATTGACAACATT を検索し
+ タブ区切りテキスト (txt) で結果を返す


サーチャ
-----

検索クエリの実行はサーチャで行なっています。サーチャでは、接尾辞配列および  
逆接尾辞リンクによるインデックスをSSDに保持することによって、ミスマッチ、  
挿入、欠失を含む塩基配列の検索を、見落としなく、きわめて高速に実行します。  
サーチャプログラムはプリファードインフラストラクチャー
([PFI](http://preferred.jp/)) が開発しており、  
[@meso_cacase](http://twitter.com/meso_cacase)
が評価およびデバッグに協力しています。


関連プロジェクト
--------

+ 統合遺伝子検索GGRNA (http://GGRNA.dbcls.jp/)  
  遺伝子をGoogleのように検索できるウェブサーバ
  → [紹介記事](http://first.lifesciencedb.jp/from_dbcls/e0001)


ライセンス
--------

Copyright &copy; 2012-2015 Yuki Naito
 ([@meso_cacase](http://twitter.com/meso_cacase)) at  
Database Center for Life Science (DBCLS), Japan.  
This software is distributed under [modified BSD license]
 (http://www.opensource.org/licenses/bsd-license.php).
