package DBlist ;

# データベースの正式名およびホスト名/ポート番号の一覧
#
# フォーマット：
# DB	host	port	source	fullname	synonym(複数の場合は;で区切る)
#
# ホスト一覧：
# 172.18.8.70	ssd.dbcls.jp
# 172.18.8.71	s01.dbcls.jp
# 172.18.8.72	s02.dbcls.jp
# 172.18.8.73	s03.dbcls.jp
# 172.18.8.74	s04.dbcls.jp
# 172.18.8.75	s05.dbcls.jp
# 172.18.8.76	s06.dbcls.jp
# 172.18.8.77	s07.dbcls.jp
# 172.18.8.78	s08.dbcls.jp

$dbconfig =
<<'--EOS--' ;
hg38     	172.18.8.78	40013	UCSC	Human genome, GRCh38/hg38 (Dec, 2013)	Homo sapiens
hg19     	172.18.8.78	40023	UCSC	Human genome, GRCh37/hg19 (Feb, 2009)	Homo sapiens
mm10     	172.18.8.78	40033	UCSC	Mouse genome, GRCm38/mm10 (Dec, 2011)	Mus musculus
mm9      	172.18.8.78	40043	UCSC	Mouse genome, NCBI37/mm9 (Jul, 2007)	Mus musculus
vicPac2  	172.18.8.78	40053	UCSC	Alpaca genome, Vicugna_pacos-2.0.1/vicPac2 (Mar, 2013)	Vicugna pacos
dasNov3  	172.18.8.78	40063	UCSC	Armadillo genome, Baylor/dasNov3 (Dec, 2011)	Dasypus novemcinctus
papAnu2  	172.18.8.78	40073	UCSC	Baboon genome, Baylor Panu_2.0/papAnu2 (Mar, 2012)	Papio anubis
otoGar3  	172.18.8.78	40083	UCSC	Bushbaby genome, Broad/otoGar3 (Mar, 2011)	Otolemur garnettii
felCat5  	172.18.8.78	40093	UCSC	Cat genome, ICGSC Felis_catus 6.2/felCat5 (Sep, 2011)	Felis catus
panTro4  	172.18.8.78	40103	UCSC	Chimp genome, CSAC 2.1.4/panTro4 (Feb, 2011)	Pan troglodytes
criGri1  	172.18.8.78	40113	UCSC	Chinese hamster genome, C_griseus_v1.0/criGri1 (Jul, 2013)	Cricetulus griseus
bosTau8  	172.18.8.78	40123	UCSC	Cow genome, Bos_taurus_UMD_3.1.1/bosTau8 (Jun, 2014)	Bos taurus
canFam3  	172.18.8.78	40133	UCSC	Dog genome, Broad CanFam3.1/canFam3 (Sep, 2011)	Canis lupus familiaris
turTru2  	172.18.8.78	40143	UCSC	Dolphin genome, Baylor Ttru_1.4/turTru2 (Oct, 2011)	Tursiops truncatus
loxAfr3  	172.18.8.78	40153	UCSC	Elephant genome, Broad/loxAfr3 (Jul, 2009)	Loxodonta africana
musFur1  	172.18.8.78	40163	UCSC	Ferret genome, MusPutFur1.0/musFur1 (Apr, 2011)	Mustela putorius furo
nomLeu3  	172.18.8.78	40173	UCSC	Gibbon genome, GGSC Nleu3.0/nomLeu3 (Oct, 2012)	Nomascus leucogenys
gorGor3  	172.18.8.78	40183	UCSC	Gorilla genome, gorGor3.1/gorGor3 (May, 2011)	Gorilla gorilla gorilla
cavPor3  	172.18.8.78	40193	UCSC	Guinea pig genome, Broad/cavPor3 (Feb, 2008)	Cavia porcellus
eriEur2  	172.18.8.78	40203	UCSC	Hedgehog genome, EriEur2.0/eriEur2 (May, 2012)	Erinaceus europaeus
equCab2  	172.18.8.78	40213	UCSC	Horse genome, Broad/equCab2 (Sep, 2007)	Equus caballus
dipOrd1  	172.18.8.78	40223	UCSC	Kangaroo rat genome, Broad/dipOrd1 (Jul, 2008)	Dipodomys ordii
triMan1  	172.18.8.78	40233	UCSC	Manatee genome, Broad v1.0/triMan1 (Oct, 2011)	Trichechus manatus latirostris
calJac3  	172.18.8.78	40243	UCSC	Marmoset genome, WUGSC 3.2/calJac3 (Mar, 2009)	Callithrix jacchus
pteVam1  	172.18.8.78	40253	UCSC	Megabat genome, Broad/pteVam1 (Jul, 2008)	Pteropus vampyrus
myoLuc2  	172.18.8.78	40263	UCSC	Microbat genome, Broad Institute Myoluc2.0/myoLuc2 (Jul, 2010)	Myotis lucifugus
balAcu1  	172.18.8.77	40273	UCSC	Minke whale genome, BalAcu1.0/balAcu1 (Oct, 2013)	Balaenoptera acutorostrata scammoni
micMur1  	172.18.8.77	40283	UCSC	Mouse lemur genome, Broad/micMur1 (Jul, 2007)	Microcebus murinus
hetGla2  	172.18.8.77	40293	UCSC	Naked mole-rat genome, Broad HetGla_female_1.0/hetGla2 (Jan, 2012)	Heterocephalus glaber
monDom5  	172.18.8.77	40303	UCSC	Opossum genome, Broad/monDom5 (Oct, 2006)	Monodelphis domestica
ponAbe2  	172.18.8.77	40313	UCSC	Orangutan genome, WUGSC 2.0.2/ponAbe2 (Jul, 2007)	Pongo pygmaeus abelii
ailMel1  	172.18.8.77	40323	UCSC	Panda genome, BGI-Shenzhen 1.0/ailMel1 (Dec, 2009)	Ailuropoda melanoleuca
susScr3  	172.18.8.77	40333	UCSC	Pig genome, SGSC Sscrofa10.2/susScr3 (Aug, 2011)	Sus scrofa
ochPri3  	172.18.8.77	40343	UCSC	Pika genome, OchPri3.0/ochPri3 (May, 2012)	Ochotona princeps
ornAna1  	172.18.8.77	40353	UCSC	Platypus genome, WUGSC 5.0.1/ornAna1 (Mar, 2007)	Ornithorhynchus anatinus
oryCun2  	172.18.8.77	40363	UCSC	Rabbit genome, Broad/oryCun2 (Apr, 2009)	Oryctolagus cuniculus
rn6      	172.18.8.77	40373	UCSC	Rat genome, RGSC 6.0/rn6 (Jul, 2014)	Rattus norvegicus
rn5      	172.18.8.77	40383	UCSC	Rat genome, RGSC 5.0/rn5 (Mar, 2012)	Rattus norvegicus
rheMac3  	172.18.8.77	40393	UCSC	Rhesus genome, BGI CR_1.0/rheMac3 (Oct, 2010)	Macaca mulatta
proCap1  	172.18.8.77	40403	UCSC	Rock hyrax genome, Broad/proCap1 (Jul, 2008)	Procavia capensis
oviAri3  	172.18.8.77	40413	UCSC	Sheep genome, ISGC Oar_v3.1/oviAri3 (Aug, 2012)	Ovis aries
sorAra2  	172.18.8.77	40423	UCSC	Shrew genome, Broad/sorAra2 (Aug, 2008)	Sorex araneus
choHof1  	172.18.8.77	40433	UCSC	Sloth genome, Broad/choHof1 (Jul, 2008)	Choloepus hoffmanni
speTri2  	172.18.8.77	40443	UCSC	Squirrel genome, Broad/speTri2 (Nov, 2011)	Spermophilus tridecemlineatus
saiBol1  	172.18.8.77	40453	UCSC	Squirrel monkey genome, Broad/saiBol1 (Oct, 2011)	Saimiri boliviensis
tarSyr1  	172.18.8.77	40463	UCSC	Tarsier genome, Broad/tarSyr1 (Aug, 2008)	Tarsius syrichta
sarHar1  	172.18.8.77	40473	UCSC	Tasmanian devil genome, WTSI Devil_ref v7.0/sarHar1 (Feb, 2011)	Sarcophilus harrisii
echTel2  	172.18.8.77	40483	UCSC	Tenrec genome, Broad/echTel2 (Nov, 2012)	Echinops telfairi
tupBel1  	172.18.8.77	40493	UCSC	Tree shrew genome, Broad/tupBel1 (Dec, 2006)	Tupaia belangeri
macEug2  	172.18.8.77	40503	UCSC	Wallaby genome, TWGS Meug_1.1/macEug2 (Sep, 2009)	Macropus eugenii
cerSim1  	172.18.8.77	40513	UCSC	White rhinoceros genome, CerSimSim1.0/cerSim1 (May, 2012)	Ceratotherium simum
allMis1  	172.18.8.76	40523	UCSC	American alligator genome, allMis0.2/allMis1 (Aug, 2012)	Alligator mississippiensis
gadMor1  	172.18.8.76	40533	UCSC	Atlantic cod genome, Genofisk GadMor_May2010/gadMor1 (May, 2010)	Gadus morhua
melUnd1  	172.18.8.76	40543	UCSC	Budgerigar genome, WUSTL v6.3/melUnd1 (Sep, 2011)	Melopsittacus undulatus
galGal4  	172.18.8.76	40553	UCSC	Chicken genome, ICGSC Gallus_gallus-4.0/galGal4 (Nov, 2011)	Gallus gallus
latCha1  	172.18.8.76	40563	UCSC	Coelacanth genome, Broad/latCha1 (Aug, 2011)	Latimeria chalumnae
calMil1  	172.18.8.76	40573	UCSC	Elephant shark genome, Callorhinchus_milii-6.1.3/calMil1 (Dec, 2013)	Callorhinchus milii
fr3      	172.18.8.76	40583	UCSC	Fugu genome, FUGU5/fr3 (Oct, 2011)	Takifugu rubripes
petMar2  	172.18.8.76	40593	UCSC	Lamprey genome, WUGSC 7.0/petMar2 (Sep, 2010)	Petromyzon marinus
anoCar2  	172.18.8.76	40603	UCSC	Lizard genome, Broad AnoCar2.0/anoCar2 (May, 2010)	Anolis carolinensis
oryLat2  	172.18.8.76	40613	UCSC	Medaka genome, NIG/UT MEDAKA1/oryLat2 (Oct, 2005)	Oryzias latipes
geoFor1  	172.18.8.76	40623	UCSC	Medium ground finch genome, GeoFor_1.0/geoFor1 (Apr, 2012)	Geospiza fortis
oreNil2  	172.18.8.76	40633	UCSC	Nile tilapia genome, Broad oreNil1.1/oreNil2 (Jan, 2011)	Oreochromis niloticus
chrPic1  	172.18.8.76	40643	UCSC	Painted turtle genome, v3.0.1/chrPic1 (Dec, 2011)	Chrysemys picta bellii
gasAcu1  	172.18.8.76	40653	UCSC	Stickleback genome, Broad/gasAcu1 (Feb, 2006)	Gasterosteus aculeatus
tetNig2  	172.18.8.76	40663	UCSC	Tetraodon genome, Genoscope 8.0/tetNig2 (Mar, 2007)	Tetraodon nigroviridis
melGal1  	172.18.8.76	40673	UCSC	Turkey genome, TGC Turkey_2.01/melGal1 (Dec, 2009)	Meleagris gallopavo
xenTro3  	172.18.8.76	40683	UCSC	Xenopus tropicalis genome, JGI 4.2/xenTro3 (Nov, 2009)	Xenopus tropicalis
taeGut2  	172.18.8.76	40693	UCSC	Zebra finch genome, WashU taeGut324/taeGut2 (Feb, 2013)	Taeniopygia guttata
danRer7  	172.18.8.76	40703	UCSC	Zebrafish genome, Zv9/danRer7 (Jul, 2010)	Danio rerio
ci2      	172.18.8.76	40713	UCSC	Ciona intestinalis genome, JGI 2.1/ci2 (Mar, 2005)	Ciona intestinalis
braFlo1  	172.18.8.76	40723	UCSC	Lancelet genome, JGI 1.0/braFlo1 (Mar, 2006)	Branchiostoma floridae
strPur2  	172.18.8.76	40733	UCSC	S. purpuratus genome, Baylor 2.1/strPur2 (Sep, 2006)	Strongylocentrotus purpuratus
anoGam1  	172.18.8.76	40743	UCSC	A. gambiae genome, IAGEC MOZ2/anoGam1 (Feb, 2003)	Anopheles gambiae
apiMel2  	172.18.8.76	40753	UCSC	A. mellifera genome, Baylor 2.0/apiMel2 (Jan, 2005)	Apis mellifera
droAna2  	172.18.8.76	40763	UCSC	D. ananassae genome, Agencourt prelim/droAna2 (Aug, 2005)	Drosophila ananassae;fly
droEre1  	172.18.8.76	40773	UCSC	D. erecta genome, Agencourt prelim/droEre1 (Aug, 2005)	Drosophila erecta;fly
droGri1  	172.18.8.76	40783	UCSC	D. grimshawi genome, Agencourt prelim/droGri1 (Aug, 2005)	Drosophila grimshawi;fly
dm6      	172.18.8.76	40793	UCSC	D. melanogaster genome, BDGP Release 6 + ISO1 MT/dm6 (Aug, 2014)	Drosophila melanogaster;fly
dm3      	172.18.8.76	40803	UCSC	Drosophila melanogaster genome, BDGP R5/dm3 (Apr, 2006)	Drosophila melanogaster;fly
droMoj2  	172.18.8.76	40813	UCSC	D. mojavensis genome, Agencourt prelim/droMoj2 (Aug, 2005)	Drosophila mojavensis;fly
droPer1  	172.18.8.76	40823	UCSC	D. persimilis genome, Broad/droPer1 (Oct, 2005)	Drosophila persimilis;fly
dp3      	172.18.8.76	40833	UCSC	D. pseudoobscura genome, FlyBase 1.03/dp3 (Nov, 2004)	Drosophila pseudoobscura;fly
droSec1  	172.18.8.76	40843	UCSC	D. sechellia genome, Broad/droSec1 (Oct, 2005)	Drosophila sechellia;fly
droSim1  	172.18.8.76	40853	UCSC	D. simulans genome, WUGSC mosaic 1.0/droSim1 (Apr, 2005)	Drosophila simulans;fly
droVir2  	172.18.8.76	40863	UCSC	D. virilis genome, Agencourt prelim/droVir2 (Aug, 2005)	Drosophila virilis;fly
droYak2  	172.18.8.76	40873	UCSC	D. yakuba genome, WUGSC 7.1/droYak2 (Nov, 2005)	Drosophila yakuba;fly
caePb2   	172.18.8.76	40883	UCSC	C. brenneri genome, WUGSC 6.0.1/caePb2 (Feb, 2008)	Caenorhabditis brenneri;worm
cb3      	172.18.8.76	40893	UCSC	C. briggsae genome, WUGSC 1.0/cb3 (Jan, 2007)	Caenorhabditis briggsae;worm
ce10     	172.18.8.76	40903	UCSC	C. elegans genome, WS220/ce10 (Oct, 2010)	Caenorhabditis elegans;worm
caeJap1  	172.18.8.76	40913	UCSC	C. japonica genome, WUGSC 3.0.2/caeJap1 (Mar, 2008)	Caenorhabditis japonica;worm
caeRem3  	172.18.8.76	40923	UCSC	C. remanei genome, WUGSC 15.0.1/caeRem3 (May, 2007)	Caenorhabditis remanei;worm
priPac1  	172.18.8.76	40933	UCSC	P. pacificus genome, WUGSC 5.0/priPac1 (Feb, 2007)	Pristionchus pacificus
sacCer3  	172.18.8.76	40943	UCSC	S. cerevisiae (S288C) genome, SacCer_Apr2011/sacCer3 (Apr, 2011)	Saccharomyces cerevisiae;budding yeast
aplCal1  	172.18.8.76	40953	UCSC	Sea hare genome, Broad 2.0/aplCal1 (Sep, 2008)	Aplysia californica
eboVir3  	172.18.8.76	40963	UCSC	Ebola virus genome, Sierra Leone G3683/KM034562.1/eboVir3 (Jun, 2014)	Filoviridae ebolavirus
hg18     	172.18.8.76	40973	UCSC	Human genome, NCBI36/hg18 (Mar, 2006)	Homo sapiens
Xenla7   	172.18.8.70	42443	Xenbase	Xenopus laevis genome, JGI 7.1/Xenla7 (Dec, 2013)	Xenopus laevis
TAIR10   	172.18.8.70	42373	    	Arabidopsis thaliana genome, TAIR10 (Nov, 2010)	Arabidopsis thaliana
rice     	172.18.8.70	42293	    	Rice genome, Os-Nipponbare-Reference-IRGSP-1.0 (Oct, 2011)	Oryza sativa
sorBic   	172.18.8.70	42403	    	Sorghum genome, Sorghum bicolor v2.1 (May, 2013)	Sorghum bicolor
bmor1    	172.18.8.70	42303	Ensembl	Silkworm genome, Bmor1 (Apr, 2008)	Bombyx mori
pombe    	172.18.8.70	42453	Ensembl	S. pombe (972h-) genome, ASM294v2 (Nov, 2007)	Schizosaccharomyces pombe;fission yeast
prok     	172.18.8.70	42323	    	Prokaryotic TogoGenome from RefSeq 62 (Nov, 2013)	
ddbj     	172.18.8.70	42313	DDBJ	DDBJ release 92.0 (Feb, 2013)	
Xentr7               	172.18.8.77	43013	Xenbase  	Xenopus tropicalis genome, XenBase/JGI 7.1	Xenopus tropicalis
Xentr8               	172.18.8.77	43023	Xenbase  	Xenopus tropicalis genome, XenBase/JGI 8.0	Xenopus tropicalis
ASM15162v1           	172.18.8.77	43033	Ensembl  	Silkworm genome, ASM15162v1/GCA_000151625.1 (Feb, 2013)	Bombyx mori
macaque_CE_1         	172.18.8.77	43043	         	Crab-eating macaque genome, CE_1.0 (Jul, 2011)	Macaca fascicularis
macaque_CE_1_cds     	172.18.8.77	43053	         	Crab-eating macaque CDS, CE_1.0 (Jul, 2011)	Macaca fascicularis
Tcas3                	172.18.8.77	43063	Ensembl  	Tribolium castaneum genome, Tcas3 (Feb, 2010)	Tribolium castaneum;red flour beetle
16SrRNA              	172.18.8.77	50053	         	DDBJ 16S rRNA of prokaryotes (Dec, 2014)	
Ppatens_251_v3       	172.18.8.74	42013	Phytozome	Physcomitrella patens genome v3.0 (Oct, 2007)	Physcomitrella patens
Smoellendorffii_91_v1	172.18.8.74	42023	Phytozome	Selaginella moellendorffii genome v1.0 (Dec, 2007)	Selaginella moellendorffii
Creinhardtii_281_v5_5	172.18.8.74	42033	Phytozome	Chlamydomonas reinhardtii genome v5.5 (May, 2014)	Chlamydomonas reinhardtii
Olucimarinus_231_v2  	172.18.8.74	42043	Phytozome	Ostreococcus lucimarinus genome v2.0 (Jan, 2011)	Ostreococcus lucimarinus
refseq70             	172.18.8.74	60003	RefSeq   	RefSeq complete RNA release 70 (May, 2015)	
refseq71             	172.18.8.74	60013	RefSeq   	RefSeq complete RNA release 71 (Jul, 2015)	
refseq               	172.18.8.74	60013	RefSeq   	RefSeq complete RNA release 71 (Jul, 2015)	
hs_refseq            	172.18.8.75	42393	RefSeq   	RefSeq human RNA release 60 (Jul, 2013)	Homo sapiens
mm_refseq            	172.18.8.75	42433	RefSeq   	RefSeq mouse RNA release 60 (Jul, 2013)	Mus musculus
hg19_pre_mRNA        	172.18.8.75	50013	         	Human pre mRNA, Bits DB (Dec, 2014)	Homo sapiens
mm10_pre_mRNA        	172.18.8.75	50023	         	Mouse pre mRNA, Bits DB (Dec, 2014)	Mus musculus
hg19_pre_mRNA_v2     	172.18.8.75	50033	         	Human pre mRNA, Bits DB v2 (Feb, 2015)	Homo sapiens
mm10_pre_mRNA_v2     	172.18.8.75	50043	         	Mouse pre mRNA, Bits DB v2 (Feb, 2015)	Mus musculus
hs_refseq70          	172.18.8.75	50063	RefSeq   	RefSeq human RNA release 70 (May, 2015)	Homo sapiens
mm_refseq70          	172.18.8.75	50073	RefSeq   	RefSeq mouse RNA release 70 (May, 2015)	Mus musculus
hs_pre_mRNA_201505   	172.18.8.75	50083	         	Human pre mRNA, refseq70-hg19 (May, 2015)	Homo sapiens
mm_pre_mRNA_201505   	172.18.8.75	50093	         	Mouse pre mRNA, refseq70-mm10 (May, 2015)	Mus musculus
hs_pre_mRNA_nr_201505	172.18.8.75	50103	         	Human non-redundant pre mRNA, refseq70-hg19 (May, 2015)	Homo sapiens
mm_pre_mRNA_nr_201505	172.18.8.75	50113	         	Mouse non-redundant pre mRNA, refseq70-mm10 (May, 2015)	Mus musculus
hsnm_refseq70        	172.18.8.75	50123	RefSeq   	RefSeq human RNA (NM/NR) release 70 (May, 2015)	Homo sapiens
hsxm_refseq70        	172.18.8.75	50133	RefSeq   	RefSeq human RNA (XM/XR) release 70 (May, 2015)	Homo sapiens
mmnm_refseq70        	172.18.8.75	50143	RefSeq   	RefSeq mouse RNA (NM/NR) release 70 (May, 2015)	Mus musculus
mmxm_refseq70        	172.18.8.75	50153	RefSeq   	RefSeq mouse RNA (XM/XR) release 70 (May, 2015)	Mus musculus
rn_refseq70          	172.18.8.75	50163	RefSeq   	RefSeq rat RNA release 70 (May, 2015)	Rattus norvegicus
rnnm_refseq70        	172.18.8.75	50173	RefSeq   	RefSeq rat RNA (NM/NR) release 70 (May, 2015)	Rattus norvegicus
rnxm_refseq70        	172.18.8.75	50183	RefSeq   	RefSeq rat RNA (XM/XR) release 70 (May, 2015)	Rattus norvegicus
ddbj101hum           	172.18.8.71	61023	DDBJ     	DDBJ release 101.0, HUM division (Jun, 2015)	ddbjhum
ddbj101pri           	172.18.8.71	61033	DDBJ     	DDBJ release 101.0, PRI division (Jun, 2015)	ddbjpri
ddbj101rod           	172.18.8.71	61043	DDBJ     	DDBJ release 101.0, ROD division (Jun, 2015)	ddbjrod
ddbj101mam           	172.18.8.71	61053	DDBJ     	DDBJ release 101.0, MAM division (Jun, 2015)	ddbjmam
ddbj101vrt           	172.18.8.71	61063	DDBJ     	DDBJ release 101.0, VRT division (Jun, 2015)	ddbjvrt
ddbj101inv           	172.18.8.71	61073	DDBJ     	DDBJ release 101.0, INV division (Jun, 2015)	ddbjinv
ddbj101pln           	172.18.8.71	61083	DDBJ     	DDBJ release 101.0, PLN division (Jun, 2015)	ddbjpln
ddbj101bct           	172.18.8.71	61093	DDBJ     	DDBJ release 101.0, BCT division (Jun, 2015)	ddbjbct
ddbj101vrl           	172.18.8.71	61103	DDBJ     	DDBJ release 101.0, VRL division (Jun, 2015)	ddbjvrl
ddbj101phg           	172.18.8.71	61113	DDBJ     	DDBJ release 101.0, PHG division (Jun, 2015)	ddbjphg
ddbj101pat           	172.18.8.72	61123	DDBJ     	DDBJ release 101.0, PAT division (Jun, 2015)	ddbjpat
ddbj101env           	172.18.8.72	61133	DDBJ     	DDBJ release 101.0, ENV division (Jun, 2015)	ddbjenv
ddbj101syn           	172.18.8.72	61143	DDBJ     	DDBJ release 101.0, SYN division (Jun, 2015)	ddbjsyn
ddbj101est           	172.18.8.72	61153	DDBJ     	DDBJ release 101.0, EST division (Jun, 2015)	ddbjest
ddbj101tsa           	172.18.8.73	61163	DDBJ     	DDBJ release 101.0, TSA division (Jun, 2015)	ddbjtsa
ddbj101gss           	172.18.8.73	61173	DDBJ     	DDBJ release 101.0, GSS division (Jun, 2015)	ddbjgss
ddbj101htc           	172.18.8.73	61183	DDBJ     	DDBJ release 101.0, HTC division (Jun, 2015)	ddbjhtc
ddbj101htg           	172.18.8.73	61193	DDBJ     	DDBJ release 101.0, HTG division (Jun, 2015)	ddbjhtg
ddbj101sts           	172.18.8.73	61203	DDBJ     	DDBJ release 101.0, STS division (Jun, 2015)	ddbjsts
ddbj101una           	172.18.8.73	61213	DDBJ     	DDBJ release 101.0, UNA division (Jun, 2015)	ddbjuna
--EOS--

return 1 ;
