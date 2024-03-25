GGGenome《ゲゲゲノム》
======================

**GGGenome** is an ultrafast search engine for nucleotide sequences.  
The web server of GGGenome is freely available to all users.  
English version of GGGenome: https://GGGenome.dbcls.jp/en/

ゲノム等の塩基配列を高速に検索するウェブサービスです。  
数塩基のミスマッチ、挿入、欠失を許容した配列検索が可能です。  
検索結果はHTMLのほか、タブ区切りテキスト、CSV、BED、GFF、JSONの各形式でも取得できます。

+ https://GGGenome.dbcls.jp/  
  本レポジトリにあるCGIが実際に稼働しています。

なお、本レポジトリはGGGenomeのウェブインターフェース部分です。  
ユーザからのリクエストを受け付け、検索を実行するサーチャにクエリを  
発行し、得られたデータを処理してユーザに検索結果を返します。


サンプル画像
-----

+ https://GGGenome.dbcls.jp/hg19/2/GCAAGAAGAGATTGCCCA  
  ヒトゲノムhg19に対して2ミスマッチ/ギャップ以内で GCAAGAAGAGATTGCCCA を検索

![スクリーンショット](https://data.dbcls.jp/~meso/img/GGGenome_screen.png
"GGGenome《ゲゲゲノム》スクリーンショットHTML")

+ https://GGGenome.dbcls.jp/hg19/2/GCAAGAAGAGATTGCCCA.json  
  上記の結果をJSONで取得

![スクリーンショット](https://data.dbcls.jp/~meso/img/GGGenome_json.png
"GGGenome《ゲゲゲノム》スクリーンショットJSON")


検索結果へのリンク (REST API仕様)
------

下記のように検索クエリとURIとが対応しています。

```
URI: http[s]://GGGenome.dbcls.jp/db/k/strand/sequence[.format][.download]
```

+ *`db`* : 塩基配列データベース  
  `hg19`   - ヒトゲノム [GRCh37/hg19 (Feb, 2009)](http://hgdownload.soe.ucsc.edu/goldenPath/hg19/bigZips/)
             (省略時のデフォルト)  
  `mm10`   - マウスゲノム [GRCm38/mm10 (Dec, 2011)](http://hgdownload.soe.ucsc.edu/goldenPath/mm10/bigZips/)  
  `dm3`    - ショウジョウバエゲノム [BDGP R5/dm3 (Apr, 2006)](http://hgdownload.soe.ucsc.edu/goldenPath/dm3/bigZips/)  
  `ce10`   - 線虫ゲノム [WS220/ce10 (Oct, 2010)](http://hgdownload.soe.ucsc.edu/goldenPath/ce10/bigZips/)  
  `TAIR10` - シロイヌナズナゲノム [TAIR10 (Nov, 2010)](ftp://ftp.arabidopsis.org/home/tair/Sequences/whole_chromosomes/)  
  `pombe`  - 分裂酵母ゲノム [ASM294v2 (Nov, 2007)](ftp://ftp.ensemblgenomes.org/pub/fungi/current/fasta/schizosaccharomyces_pombe/dna/Schizosaccharomyces_pombe.ASM294v2.23.dna.genome.fa.gz)  
  `refseq` - [RefSeq complete RNA (最新版)](ftp://ftp.ncbi.nlm.nih.gov/refseq/release/complete/)  
   その他   - [検索可能なデータベース一覧](https://GGGenome.dbcls.jp/help.html)
+ *`k`* : 許容するミスマッチ/ギャップの数  
  省略時のデフォルト: `0`
+ *`strand`* : 特定の方向のみ検索  
  `+` または `plus`  - プラス方向のみ検索  
  `-` または `minus` - マイナス方向のみ検索  
  省略時は両方向を検索
+ *`sequence`* : 塩基配列 (省略不可)
+ *`format`* : 検索結果のフォーマット  
  `html` - HTML (省略時のデフォルト)  
  `txt`  - タブ区切りテキスト  
  `csv`  - CSV (comma-separated values) 形式  
  `bed`  - BED (browser extensible data) 形式  
  `gff`  - GFF (general feature format) 形式  
  `json` - JSON
+ *`download`* : 検索結果をファイルとしてダウンロード (txt, csv, bed, gff, jsonのみ)

**例1:** https://GGGenome.dbcls.jp/ce10/1/TTCATTGACAACATT

+ 線虫ゲノム ce10 に対して
+ 1 ミスマッチ/ギャップまで許容して
+ TTCATTGACAACATT を検索し
+ html (省略時のデフォルト) で結果を返す

**例2:** https://GGGenome.dbcls.jp/refseq/+/TTCATTGACAACATT.txt

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
サーチャプログラムは [レトリバ](https://retrieva.jp/) が開発しており、
[@meso_cacase](https://twitter.com/meso_cacase) が評価および  
デバッグに協力しています。


関連プロジェクト
--------

+ 統合遺伝子検索GGRNA (https://GGRNA.dbcls.jp/)  
  遺伝子をGoogleのように検索できるウェブサーバ
  → [紹介記事](https://first.lifesciencedb.jp/from_dbcls/e0001)

+ CRISPRdirect (https://crispr.dbcls.jp/)  
  ゲノム編集のためのガイドRNA設計ウェブサーバ
  → [プレスリリース (PDF)](https://sr.rois.ac.jp/article/rc/download/pages/press/20141121dbcls.pdf)

License
--------

Copyright &copy; 2012-2024 Yuki Naito
 ([@meso_cacase](https://twitter.com/meso_cacase)) at  
Database Center for Life Science (DBCLS), Japan.  
This software is distributed under
[modified BSD license](https://opensource.org/licenses/bsd-license.php).
