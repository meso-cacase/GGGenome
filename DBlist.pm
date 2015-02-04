package DBlist ;

# データベースの正式名およびホスト名/ポート番号の一覧
#
# フォーマット：
# DB	host	port	source	fullname
#
# ホスト一覧：
# 172.18.8.70	ssd.dbcls.jp
# 172.18.8.78	s08.dbcls.jp

$dbconfig =
<<'--EOS--' ;
hg19     	172.18.8.70	42233	UCSC	Human genome, GRCh37/hg19 (Feb, 2009)
mm10     	172.18.8.70	42253	UCSC	Mouse genome, GRCm38/mm10 (Dec, 2011)
rn5      	172.18.8.70	42263	UCSC	Rat genome, RGSC 5.0/rn5 (Mar, 2012)
calJac3  	172.18.8.70	42423	UCSC	Marmoset genome, WUGSC 3.2/calJac3 (Mar, 2009)
susScr3  	172.18.8.70	42413	UCSC	Pig genome, SGSC Sscrofa10.2/susScr3 (Aug, 2011)
galGal4  	172.18.8.70	42333	UCSC	Chicken genome, ICGSC Gallus_gallus-4.0/galGal4 (Nov, 2011)
xenTro3  	172.18.8.70	42343	UCSC	Xenopus tropicalis genome, JGI 4.2/xenTro3 (Nov, 2009)
Xenla7   	172.18.8.70	42443	    	Xenopus laevis genome, JGI 7.1/Xenla7 (Dec, 2013)
danRer7  	172.18.8.70	42353	UCSC	Zebrafish genome, Zv9/danRer7 (Jul, 2010)
ci2      	172.18.8.70	42363	UCSC	Ciona intestinalis genome, JGI 2.1/ci2 (Mar, 2005)
dm3      	172.18.8.70	42273	UCSC	Drosophila genome, BDGP R5/dm3 (Apr, 2006)
ce10     	172.18.8.70	42283	UCSC	C. elegans genome, WS220/ce10 (Oct, 2010)
TAIR10   	172.18.8.70	42373	    	Arabidopsis thaliana genome, TAIR10 (Nov, 2010)
rice     	172.18.8.70	42293	    	Rice genome, Os-Nipponbare-Reference-IRGSP-1.0 (Oct, 2011)
sorBic   	172.18.8.70	42403	    	Sorghum genome, Sorghum bicolor v2.1 (May, 2013)
bmor1    	172.18.8.70	42303	    	Silkworm genome, Bmor1 (Apr, 2008)
sacCer3  	172.18.8.70	42383	UCSC	S. cerevisiae (S288C) genome, sacCer3 (Apr, 2011)
pombe    	172.18.8.70	42453	    	S. pombe (972h-) genome, ASM294v2 (Nov, 2007)
refseq   	172.18.8.70	42243	    	RefSeq complete RNA release 69 (Jan, 2015)
hs_refseq	172.18.8.70	42393	    	RefSeq human RNA release 60 (Jul, 2013)
mm_refseq	172.18.8.70	42433	    	RefSeq mouse RNA release 60 (Jul, 2013)
prok     	172.18.8.70	42323	    	Prokaryotic TogoGenome from RefSeq 62 (Nov, 2013)
ddbj     	172.18.8.70	42313	    	DDBJ release 92.0 (Feb, 2013)
hg38     	172.18.8.78	40013	UCSC	Human genome, GRCh38/hg38 (Dec, 2013)
--EOS--

return 1 ;
