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
ponAbe2  	172.18.8.77	40313	UCSC	Orangutan genome, WUGSC 2.0.2/ponAbe2 (Jul, 2007)	Pongo abelii
ailMel1  	172.18.8.77	40323	UCSC	Panda genome, BGI-Shenzhen 1.0/ailMel1 (Dec, 2009)	Ailuropoda melanoleuca
susScr3  	172.18.8.77	40333	UCSC	Pig genome, SGSC Sscrofa10.2/susScr3 (Aug, 2011)	Sus scrofa
ochPri3  	172.18.8.77	40343	UCSC	Pika genome, OchPri3.0/ochPri3 (May, 2012)	Ochotona princeps
ornAna1  	172.18.8.77	40353	UCSC	Platypus genome, WUGSC 5.0.1/ornAna1 (Mar, 2007)	Ornithorhynchus anatinus
oryCun2  	172.18.8.77	40363	UCSC	Rabbit genome, Broad/oryCun2 (Apr, 2009)	Oryctolagus cuniculus
rn6      	172.18.8.77	40373	UCSC	Rat genome, RGSC 6.0/rn6 (Jul, 2014)	Rattus norvegicus
rn5      	172.18.8.77	40383	UCSC	Rat genome, RGSC 5.0/rn5 (Mar, 2012)	Rattus norvegicus
rheMac3  	172.18.8.77	40393	UCSC	Rhesus genome, BGI CR_1.0/rheMac3 (Oct, 2010)	Macaca mulatta
proCap1  	172.18.8.77	40403	UCSC	Rock hyrax genome, Broad/proCap1 (Jul, 2008)	Procavia capensis;cape hyrax
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
xenTro3  	172.18.8.76	40683	UCSC	Xenopus tropicalis genome, JGI 4.2/xenTro3 (Nov, 2009)	Xenopus tropicalis;western clawed frog
taeGut2  	172.18.8.76	40693	UCSC	Zebra finch genome, WashU taeGut324/taeGut2 (Feb, 2013)	Taeniopygia guttata
danRer7  	172.18.8.76	40703	UCSC	Zebrafish genome, Zv9/danRer7 (Jul, 2010)	Danio rerio
ci2      	172.18.8.76	40713	UCSC	Ciona intestinalis genome, JGI 2.1/ci2 (Mar, 2005)	Ciona intestinalis;transparent sea squirt
braFlo1  	172.18.8.76	40723	UCSC	Lancelet genome, JGI 1.0/braFlo1 (Mar, 2006)	Branchiostoma floridae
strPur2  	172.18.8.76	40733	UCSC	S. purpuratus genome, Baylor 2.1/strPur2 (Sep, 2006)	Strongylocentrotus purpuratus;purple sea urchin
anoGam1  	172.18.8.76	40743	UCSC	A. gambiae genome, IAGEC MOZ2/anoGam1 (Feb, 2003)	Anopheles gambiae;african malaria mosquito
apiMel2  	172.18.8.76	40753	UCSC	A. mellifera genome, Baylor 2.0/apiMel2 (Jan, 2005)	Apis mellifera;honeybee
droAna2  	172.18.8.76	40763	UCSC	D. ananassae genome, Agencourt prelim/droAna2 (Aug, 2005)	Drosophila ananassae;fruit fly
droEre1  	172.18.8.76	40773	UCSC	D. erecta genome, Agencourt prelim/droEre1 (Aug, 2005)	Drosophila erecta;fruit fly
droGri1  	172.18.8.76	40783	UCSC	D. grimshawi genome, Agencourt prelim/droGri1 (Aug, 2005)	Drosophila grimshawi;fruit fly
dm6      	172.18.8.76	40793	UCSC	D. melanogaster genome, BDGP Release 6 + ISO1 MT/dm6 (Aug, 2014)	Drosophila melanogaster;fruit fly
dm3      	172.18.8.76	40803	UCSC	Drosophila melanogaster genome, BDGP R5/dm3 (Apr, 2006)	Drosophila melanogaster;fruit fly
droMoj2  	172.18.8.76	40813	UCSC	D. mojavensis genome, Agencourt prelim/droMoj2 (Aug, 2005)	Drosophila mojavensis;fruit fly
droPer1  	172.18.8.76	40823	UCSC	D. persimilis genome, Broad/droPer1 (Oct, 2005)	Drosophila persimilis;fruit fly
dp3      	172.18.8.76	40833	UCSC	D. pseudoobscura genome, FlyBase 1.03/dp3 (Nov, 2004)	Drosophila pseudoobscura;fruit fly
droSec1  	172.18.8.76	40843	UCSC	D. sechellia genome, Broad/droSec1 (Oct, 2005)	Drosophila sechellia;fruit fly
droSim1  	172.18.8.76	40853	UCSC	D. simulans genome, WUGSC mosaic 1.0/droSim1 (Apr, 2005)	Drosophila simulans;fruit fly
droVir2  	172.18.8.76	40863	UCSC	D. virilis genome, Agencourt prelim/droVir2 (Aug, 2005)	Drosophila virilis;fruit fly
droYak2  	172.18.8.76	40873	UCSC	D. yakuba genome, WUGSC 7.1/droYak2 (Nov, 2005)	Drosophila yakuba;fruit fly
caePb2   	172.18.8.76	40883	UCSC	C. brenneri genome, WUGSC 6.0.1/caePb2 (Feb, 2008)	Caenorhabditis brenneri;nematode worm
cb3      	172.18.8.76	40893	UCSC	C. briggsae genome, WUGSC 1.0/cb3 (Jan, 2007)	Caenorhabditis briggsae;nematode worm
ce10     	172.18.8.76	40903	UCSC	C. elegans genome, WS220/ce10 (Oct, 2010)	Caenorhabditis elegans;nematode worm
caeJap1  	172.18.8.76	40913	UCSC	C. japonica genome, WUGSC 3.0.2/caeJap1 (Mar, 2008)	Caenorhabditis japonica;nematode worm
caeRem3  	172.18.8.76	40923	UCSC	C. remanei genome, WUGSC 15.0.1/caeRem3 (May, 2007)	Caenorhabditis remanei;nematode worm
priPac1  	172.18.8.76	40933	UCSC	P. pacificus genome, WUGSC 5.0/priPac1 (Feb, 2007)	Pristionchus pacificus;parasitic nematode
sacCer3  	172.18.8.76	40943	UCSC	S. cerevisiae (S288C) genome, SacCer_Apr2011/sacCer3 (Apr, 2011)	Saccharomyces cerevisiae;budding yeast
aplCal1  	172.18.8.76	40953	UCSC	Sea hare genome, Broad 2.0/aplCal1 (Sep, 2008)	Aplysia californica
eboVir3  	172.18.8.76	40963	UCSC	Ebola virus genome, Sierra Leone G3683/KM034562.1/eboVir3 (Jun, 2014)	Filoviridae ebolavirus
hg18     	172.18.8.76	40973	UCSC	Human genome, NCBI36/hg18 (Mar, 2006)	Homo sapiens
OryAfe1.0   	172.18.8.76	43073	Ensembl	Aardvark genome, OryAfe1.0 (May, 2012)	Orycteropus afer
PoeFor_5.1.2	172.18.8.76	43083	Ensembl	Amazon molly genome, Poecilia_formosa-5.1.2 (Oct, 2013)	Poecilia formosa
CSAV2.0     	172.18.8.76	43093	Ensembl	Ciona savignyi genome, CSAV 2.0 (Oct, 2005)	Ciona savignyi;pacific transparent sea squirt
AstMex102   	172.18.8.76	43103	Ensembl	Cave fish genome, AstMex102 (Apr, 2013)	Astyanax mexicanus
PelSin_1.0  	172.18.8.76	43113	Ensembl	Chinese softshell turtle genome, PelSin_1.0 (Oct, 2011)	Pelodiscus sinensis
MacFas5.0   	172.18.8.76	43123	Ensembl	Crab-eating macaque genome, MacFas5.0 (Jun, 2013)	Macaca fascicularis
BGI_duck_1.0	172.18.8.76	43133	Ensembl	Duck genome, BGI_duck_1.0 (Apr, 2013)	Anas platyrhynchos
FicAlb_1.4  	172.18.8.76	43143	Ensembl	Flycatcher genome, FicAlb_1.4 (Jan, 2012)	Ficedula albicollis
Pham        	172.18.8.76	43153	Ensembl	Hamadryas baboon genome, Pham (Nov, 2008)	Papio hamadryas
Xipmac4.4.2 	172.18.8.76	43163	Ensembl	Platyfish genome, Xipmac4.4.2 (Jan, 2012)	Xiphophorus maculatus
MicOch1.0   	172.18.8.76	43173	Ensembl	Prairie vole genome, MicOch1.0 (Nov, 2012)	Microtus ochrogaster
PhyMac_2.0.2	172.18.8.76	43183	Ensembl	Sperm whale genome, PhyMac_2.0.2 (Sep, 2013)	Physeter macrocephalus
LepOcu1     	172.18.8.76	43193	Ensembl	Spotted gar genome, LepOcu1 (Dec, 2011)	Lepisosteus oculatus
ChlSab1.1   	172.18.8.76	43203	Ensembl	Green monkey genome, ChlSab1.1 (Mar, 2014)	Chlorocebus sabaeus
Acyr_2.0    	172.18.8.76	43213	EnsemblMetazoa	Acyrthosiphon pisum genome, Acyr_2.0 (Jun, 2010)	Acyrthosiphon pisum;pea aphid
AaegL3      	172.18.8.76	43223	EnsemblMetazoa	Aedes aegypti genome, AaegL3 (Dec, 2013)	Aedes aegypti;yellowfever mosquito
Aqu1        	172.18.8.76	43233	EnsemblMetazoa	Amphimedon queenslandica genome, Aqu1 (Oct, 2010)	Amphimedon queenslandica;sponge
AdarC3      	172.18.8.76	43243	EnsemblMetazoa	Anopheles darlingi genome, AdarC3 (Jan, 2014)	Anopheles darlingi;mosquito
Attacep1.0  	172.18.8.76	43253	EnsemblMetazoa	Atta cephalotes genome, Attacep1.0 (Jul, 2012)	Atta cephalotes;leafcutter ant
ASM15162v1  	172.18.8.76	43263	EnsemblMetazoa	Silkworm genome, ASM15162v1 (Feb, 2013)	Bombyx mori
B_malayi_3.0	172.18.8.76	43273	EnsemblMetazoa	Brugia malayi genome, B_malayi-3.0 (Dec, 2012)	Brugia malayi;filarial nematode worm
Capte_v1.0  	172.18.8.76	43283	EnsemblMetazoa	Capitella teleta genome, Capitella teleta v1.0 (Dec, 2012)	Capitella teleta;polychaete worm
oyster_v9   	172.18.8.76	43293	EnsemblMetazoa	Crassostrea gigas genome, oyster_v9 (Sep, 2012)	Crassostrea gigas;pacific oyster
CpipJ2      	172.18.8.76	43303	EnsemblMetazoa	Culex quinquefasciatus genome, CpipJ2 (Jan, 2007)	Culex quinquefasciatus;southern house mosquito
DanPle_1.0  	172.18.8.76	43313	EnsemblMetazoa	Danaus plexippus genome, DanPle_1.0 (Nov, 2011)	Danaus plexippus;monarch butterfly
Dappu_V1.0  	172.18.8.76	43323	EnsemblMetazoa	Daphnia pulex genome, V1.0 (Feb, 2011)	Daphnia pulex;water flea
DendPond_1.0	172.18.8.76	43333	EnsemblMetazoa	Dendroctonus ponderosae genome, DendPond_male_1.0 (Apr, 2013)	Dendroctonus ponderosae;mountain pine beetle
dwil_caf1   	172.18.8.76	43343	EnsemblMetazoa	Drosophila willistoni genome, dwil_caf1 (Jul, 2008)	Drosophila willistoni;fruit fly
Hmel1       	172.18.8.76	43353	EnsemblMetazoa	Heliconius melpomene genome, Hmel1 (Feb, 2012)	Heliconius melpomene;postman butterfly
Helro1      	172.18.8.76	43363	EnsemblMetazoa	Helobdella robusta genome, Helro1 (Dec, 2012)	Helobdella robusta;californian leech
IscaW1      	172.18.8.76	43373	EnsemblMetazoa	Ixodes scapularis genome, IscaW1 (Aug, 2007)	Ixodes scapularis;black-legged tick
Loa_loa_V3  	172.18.8.76	43383	EnsemblMetazoa	Loa loa genome, Loa_loa_V3 (Jan, 2010)	Loa loa;eye worm
Lotgi1      	172.18.8.76	43393	EnsemblMetazoa	Lottia gigantea genome, Lotgi1 (Jan, 2013)	Lottia gigantea;giant owl limpet
Msca1       	172.18.8.76	43403	EnsemblMetazoa	Megaselia scalaris genome, Msca1 (Feb, 2013)	Megaselia scalaris;humpbacked fly
MelCinx1.0  	172.18.8.76	43413	EnsemblMetazoa	Melitaea cinxia genome, MelCinx1.0 (Jul, 2014)	Melitaea cinxia;glanville fritillary
MneLei      	172.18.8.76	43423	EnsemblMetazoa	Mnemiopsis leidyi genome, MneLei_Aug2011 (Sep, 2011)	Mnemiopsis leidyi;sea walnut
Nvit_2.1    	172.18.8.76	43433	EnsemblMetazoa	Nasonia vitripennis genome, Nvit_2.1 (Nov, 2012)	Nasonia vitripennis;parasitic wasp
ASM20922v1  	172.18.8.76	43443	EnsemblMetazoa	Nematostella vectensis genome, ASM20922v1 (Sep, 2007)	Nematostella vectensis;starlet sea anemone
Cameroon_v3 	172.18.8.76	43453	EnsemblMetazoa	Onchocerca volvulus genome, Cameroon_v3 (Nov, 2013)	Onchocerca volvulus;parasitic nematode
PhumU2      	172.18.8.76	43463	EnsemblMetazoa	Pediculus humanus genome, PhumU2 (Nov, 2008)	Pediculus humanus;body louse
RproC1      	172.18.8.76	43473	EnsemblMetazoa	Rhodnius prolixus genome, RproC1 (Dec, 2010)	Rhodnius prolixus;triatomid bug
ASM23792v2  	172.18.8.76	43483	EnsemblMetazoa	Schistosoma mansoni genome, ASM23792v2 (Apr, 2012)	Schistosoma mansoni;blood fluke
Si_gnG      	172.18.8.76	43493	EnsemblMetazoa	Solenopsis invicta genome, Si_gnG (Feb, 2011)	Solenopsis invicta;red imported fire ant
Smar1       	172.18.8.76	43503	EnsemblMetazoa	Strigamia maritima genome, Smar1 (Feb, 2013)	Strigamia maritima;european centipede
ASM23943v1  	172.18.8.76	43513	EnsemblMetazoa	Tetranychus urticae genome, ASM23943v1 (Nov, 2011)	Tetranychus urticae;two-spotted spider mite
Tcas3       	172.18.8.76	43523	EnsemblMetazoa	Tribolium castaneum genome, Tcas3 (Feb, 2010)	Tribolium castaneum;red flour beetle
Tspiralis1  	172.18.8.76	43533	EnsemblMetazoa	Trichinella spiralis genome, Tspiralis1 (Mar, 2011)	Trichinella spiralis;trichina worm
ASM15027v1  	172.18.8.76	43543	EnsemblMetazoa	Trichoplax adhaerens genome, ASM15027v1 (Aug, 2006)	Trichoplax adhaerens
ZooNev1.0   	172.18.8.76	43553	EnsemblMetazoa	Zootermopsis nevadensis genome, ZooNev1.0 (Jun, 2014)	Zootermopsis nevadensis;dampwood termite
ASM34733v1  	172.18.8.75	45013	EnsemblPlants	Aegilops tauschii genome, ASM34733v1 (Dec, 2013)	Aegilops tauschii;tausch's goatgrass
AMTR1.0     	172.18.8.75	45023	EnsemblPlants	Amborella trichopoda genome, AMTR1.0 (Jan, 2014)	Amborella trichopoda
Araly_v.1.0 	172.18.8.75	45033	EnsemblPlants	Arabidopsis lyrata genome, v.1.0 (Dec, 2008)	Arabidopsis lyrata;lyre-leaved rock-cress
TAIR10_en   	172.18.8.75	45043	EnsemblPlants	Arabidopsis thaliana genome, TAIR10 (Sep, 2010)	Arabidopsis thaliana;thale cress
Bradi_v1.0  	172.18.8.75	45053	EnsemblPlants	Brachypodium distachyon genome, v1.0 (Jan, 2009)	Brachypodium distachyon;purple false brome
Braol_v2.1  	172.18.8.75	45063	EnsemblPlants	Brassica oleracea genome, v2.1	Brassica oleracea;wild cabbage
IVFCAASv1   	172.18.8.75	45073	EnsemblPlants	Brassica rapa genome, IVFCAASv1 (Aug, 2009)	Brassica rapa ssp. pekinensis;chinese cabbage
Chlre_v3.1  	172.18.8.75	45083	EnsemblPlants	Chlamydomonas reinhardtii genome, v3.1 (Nov, 2007)	Chlamydomonas reinhardtii;green algae
ASM9120v1   	172.18.8.75	45093	EnsemblPlants	Cyanidioschyzon merolae genome, ASM9120v1 (Nov, 2008)	Cyanidioschyzon merolae;red alga
Soybn_V1.0  	172.18.8.75	45103	EnsemblPlants	Glycine max genome, V1.0 (Jan, 2010)	Glycine max;soybean
Horvu_v1    	172.18.8.75	45113	EnsemblPlants	Hordeum vulgare genome, 082214v1 (Mar, 2012)	Hordeum vulgare;barley
Lperr_V1.4  	172.18.8.75	45123	EnsemblPlants	Leersia perrieri genome, Lperr_V1.4 (Mar, 2014)	Leersia perrieri
MedtrA17_4.0	172.18.8.75	45133	EnsemblPlants	Medicago truncatula str. A17 genome, MedtrA17_4.0 (Jun, 2014)	Medicago truncatula str. A17;barrel medic
MA1         	172.18.8.75	45143	EnsemblPlants	Musa acuminata genome, MA1 (Aug, 2012)	Musa acuminata;banana
Obart_v1.0  	172.18.8.75	45153	EnsemblPlants	Oryza barthii genome, Obart_v1.0 (Apr, 2014)	Oryza barthii;african wild rice
Orybr_v1.4b 	172.18.8.75	45163	EnsemblPlants	Oryza brachyantha genome, Oryza_brachyantha.v1.4b (May, 2011)	Oryza brachyantha;african wild rice
AGI1.1      	172.18.8.75	45173	EnsemblPlants	Oryza glaberrima genome, AGI1.1 (May, 2011)	Oryza glaberrima;african wild rice
Orygl       	172.18.8.75	45183	EnsemblPlants	Oryza glumaepatula genome, ALNU02000000 (Aug, 2013)	Oryza glumaepatula;brazilian wild rice
Orylo_v0117 	172.18.8.75	45193	EnsemblPlants	Oryza longistaminata genome, v0117-2013Aug (Aug, 2013)	Oryza longistaminata;longstamen rice
Oryme_v1.3  	172.18.8.75	45203	EnsemblPlants	Oryza meridionalis genome, Oryza_meridionalis_v1.3 (Oct, 2014)	Oryza meridionalis;australian wild rice
Oryni       	172.18.8.75	45213	EnsemblPlants	Oryza nivara genome, AWHD00000000 (Aug, 2013)	Oryza nivara;indian wild rice
Orypu       	172.18.8.75	45223	EnsemblPlants	Oryza punctata genome, AVCL00000000 (Aug, 2013)	Oryza punctata;red rice
PRJEB4137   	172.18.8.75	45233	EnsemblPlants	Oryza rufipogon genome, PRJEB4137 (Aug, 2013)	Oryza rufipogon;brownbeard rice
ASM465v1    	172.18.8.75	45243	EnsemblPlants	Oryza sativa Indica genome, ASM465v1 (Jan, 2005)	Oryza sativa ssp. indica;rice
ASM9206v1   	172.18.8.75	45263	EnsemblPlants	Ostreococcus lucimarinus genome, ASM9206v1 (Jan, 2011)	Ostreococcus lucimarinus
ASM242v1    	172.18.8.75	45273	EnsemblPlants	Physcomitrella patens genome, ASM242v1 (Jul, 2006)	Physcomitrella patens;moss
Poptr_JGI2.0	172.18.8.75	45283	EnsemblPlants	Populus trichocarpa genome, JGI2.0 (Jan, 2010)	Populus trichocarpa;western balsam poplar
Prupe1_0    	172.18.8.75	45293	EnsemblPlants	Prunus persica genome, Prupe1_0 (Mar, 2013)	Prunus persica;peach
Selml_v1.0  	172.18.8.75	45303	EnsemblPlants	Selaginella moellendorffii genome, v1.0 (May, 2011)	Selaginella moellendorffii;spikemoss
Setit_JGIv2.0	172.18.8.75	45313	EnsemblPlants	Setaria italica genome, JGIv2.0 (Jan, 2012)	Setaria italica;foxtail millet
SL2.50      	172.18.8.75	45323	EnsemblPlants	Solanum lycopersicum str. Heinz 1706 genome, SL2.50 (Oct, 2014)	Solanum lycopersicum str. Heinz 1706;tomato
SolTub_3.0  	172.18.8.75	45333	EnsemblPlants	Solanum tuberosum genome, SolTub_3.0 (May, 2011)	Solanum tuberosum;potato
Sorbi1      	172.18.8.75	45343	EnsemblPlants	Sorghum bicolor genome, Sorbi1 (Dec, 2007)	Sorghum bicolor;sorghum
Thecc_20110822	172.18.8.75	45353	EnsemblPlants	Theobroma cacao genome, Theobroma_cacao_20110822 (May, 2014)	Theobroma cacao;cacao
IWGSC1.0    	172.18.8.75	45363	EnsemblPlants	Triticum aestivum genome, IWGSC1.0+popseq (Nov, 2014)	Triticum aestivum;wheat
ASM34745v1  	172.18.8.75	45373	EnsemblPlants	Triticum urartu genome, ASM34745v1 (Apr, 2013)	Triticum urartu;red wild einkorn
IGGP_12x    	172.18.8.75	45383	EnsemblPlants	Vitis vinifera genome, IGGP_12x (Jun, 2011)	Vitis vinifera;grape
AGPv3       	172.18.8.75	45393	EnsemblPlants	Zea mays genome, AGPv3 (Apr, 2013)	Zea mays;maize, Corn
Xenla7   	172.18.8.70	42443	Xenbase	Xenopus laevis genome, JGI 7.1/Xenla7 (Dec, 2013)	Xenopus laevis;african clawed frog
TAIR10   	172.18.8.70	42373	    	Arabidopsis thaliana genome, TAIR10 (Nov, 2010)	Arabidopsis thaliana;thale cress
rice     	172.18.8.70	42293	    	Rice genome, Os-Nipponbare-Reference-IRGSP-1.0 (Oct, 2011)	Oryza sativa ssp. japonica;rice
sorBic   	172.18.8.70	42403	    	Sorghum genome, Sorghum bicolor v2.1 (May, 2013)	Sorghum bicolor
bmor1    	172.18.8.70	42303	Ensembl	Silkworm genome, Bmor1 (Apr, 2008)	Bombyx mori
pombe    	172.18.8.70	42453	EnsemblFungi	S. pombe (972h-) genome, ASM294v2 (Nov, 2007)	Schizosaccharomyces pombe;fission yeast
MG8      	172.18.8.77	42463	EnsemblFungi	Magnaporthe oryzae (70-15) genome, MG8 (Sep, 2011)	Magnaporthe oryzae;rice blast fungus
prok     	172.18.8.70	42323	    	Prokaryotic TogoGenome from RefSeq 62 (Nov, 2013)	
ddbj     	172.18.8.70	42313	DDBJ	DDBJ release 92.0 (Feb, 2013)	
Xentr7               	172.18.8.77	43013	Xenbase  	Xenopus tropicalis genome, XenBase/JGI 7.1	Xenopus tropicalis;western clawed frog
Xentr8               	172.18.8.77	43023	Xenbase  	Xenopus tropicalis genome, XenBase/JGI 8.0	Xenopus tropicalis;western clawed frog
Xentr9               	172.18.8.77	42513	Xenbase  	Xenopus tropicalis genome, XenBase/JGI 9.0	Xenopus tropicalis;western clawed frog
Xenla9               	172.18.8.77	42523	Xenbase  	Xenopus laevis genome, XenBase/JGI 9.1	Xenopus laevis;african clawed frog
macaque_CE_1         	172.18.8.77	43043	         	Crab-eating macaque genome, CE_1.0 (Jul, 2011)	Macaca fascicularis
macaque_CE_1_cds     	172.18.8.77	43053	         	Crab-eating macaque CDS, CE_1.0 (Jul, 2011)	Macaca fascicularis
KH                   	172.18.8.77	42533	         	Ciona intestinalis genome, KH (Jul, 2008)	Ciona intestinalis;transparent sea squirt
Spur_v3.1            	172.18.8.77	42543	SpBase   	S. purpuratus genome, Spur_v3.1 (Jun, 2011)	Strongylocentrotus purpuratus;purple sea urchin
h7                   	172.18.8.77	42553	NCBI     	Hydra genome, h7 (Aug, 2008)	Hydra vulgaris
Hydra_RP_1.0         	172.18.8.77	42563	NCBI     	Hydra genome, Hydra_RP_1.0 (Oct, 2009)	Hydra vulgaris
Brana_v4.1           	172.18.8.77	42573	Genoscope	Brassica napus genome, Genoscope v4.1 (Aug, 2014)	Brassica napus
lotus_r3.0           	172.18.8.77	42583	Kazusa   	Lotus japonicus genome, build 3.0 (Aug, 2015)	Lotus japonicus;japanese trefoil
Niben_v1.0.1         	172.18.8.77	42593	         	Nicotiana benthamiana genome, v1.0.1 (Jul, 2014)	Nicotiana benthamiana;tobacco
adzuki_ver3          	172.18.8.77	42603	         	Vigna angularis genome, ver3 (Nov, 2011)	Vigna angularis;adzuki bean
RSA_r1.0             	172.18.8.77	42613	Kazusa   	Raphanus sativus genome, RSA_r1.0 (May, 2014)	Raphanus sativus;radish
MesAur1.0            	172.18.8.77	42623	         	Golden hamster genome, MesAur1.0 (Mar, 2013)	Mesocricetus auratus;golden hamster
ASM644v2             	172.18.8.76	42633	EnsemblFungi	Debaryomyces hansenii (CBS767) genome, ASM644v2 (Feb, 2015)	Debaryomyces hansenii;marine yeast
ASM251v1             	172.18.8.76	42643	EnsemblFungi	Kluyveromyces lactis genome, ASM251v1 (Feb, 2015)	Kluyveromyces lactis;kluyveromyces yeast
ASM252v1             	172.18.8.76	42653	EnsemblFungi	Yarrowia lipolytica genome, ASM252v1 (May, 2012)	Yarrowia lipolytica;oleaginous yeast
RR                   	172.18.8.76	42663	EnsemblFungi	Fusarium graminearum genome, RR (Nov, 2014)	Fusarium graminearum;Gibberella zeae;wheat head blight fungus
CC3                  	172.18.8.72	42823	EnsemblFungi	Coprinopsis cinerea (okayama7#130) genome, CC3 (Aug, 2014)	Coprinopsis cinerea;Hormographiella aspergillata;inky cap fungus
BX                   	172.18.8.76	42673	         	Nicotiana tabacum (BX) genome, Ntab-BX (2014)	Nicotiana tabacum;tobacco
RHOziaDV1.0          	172.18.8.76	42683	NCBI     	Rhodotorula toruloides (NP11) genome, RHOziaDV1.0 (Apr, 2013)	Rhodotorula toruloides;oleaginous yeast
Tetth                	172.18.8.76	42693	TGD      	Tetrahymena thermophila genome (Jun, 2014)	Tetrahymena thermophila
Tetbo                	172.18.8.76	42703	TGD      	Tetrahymena borealis genome (Oct, 2012)	Tetrahymena borealis
Tetel                	172.18.8.76	42713	TGD      	Tetrahymena elliotti genome (Oct, 2012)	Tetrahymena elliotti
Tetma                	172.18.8.76	42723	TGD      	Tetrahymena malaccensis genome (Oct, 2012)	Tetrahymena malaccensis
img1                 	172.18.8.72	42733	IchDB    	Ichthyophthirius multifiliis macronuclear genome	Ichthyophthirius multifiliis;ciliate
stylo                	172.18.8.72	42743	StyloDB  	Stylonychia lemnae macronuclear genome	Stylonychia lemnae;ciliate
oxy                  	172.18.8.72	42753	OxyDB    	Oxytricha trifallax macronuclear genome	Oxytricha trifallax;ciliate
oxymic               	172.18.8.72	42763	OxyDB    	Oxytricha trifallax micronuclear genome	Oxytricha trifallax;ciliate
A_nidulans_FGSC_A4   	172.18.8.72	42773	AspGD    	Aspergillus nidulans (FGSC A4) genome, s10-m04-r06 (Apr, 2016)	Aspergillus nidulans;Emericella nidulans
A_fumigatus_Af293    	172.18.8.72	42783	AspGD    	Aspergillus fumigatus (Af293) genome, s03-m05-r06 (Apr, 2016)	Aspergillus fumigatus;Neosartorya fumigata
C_glabrata_CBS138    	172.18.8.72	42793	CGD      	Candida glabrata (CBS138) genome, s02-m07-r08 (Jun, 2016)	Candida glabrata;Torulopsis glabrata
C_albicans_SC5314    	172.18.8.72	42803	CGD      	Candida albicans (SC5314) genome, Assembly 21, A21-s02-m09-r10 (Feb, 2016)	Candida albicans
JCVI_PMFA1_2.0       	172.18.8.72	42813	NCBI     	Penicillium marneffei (ATCC 18224) genome, JCVI-PMFA1-2.0 (Oct, 2008)	Penicillium marneffei;Talaromyces marneffei
JRGv1                	172.18.8.72	42833	ToMMo    	Human Japanese Reference Genome, JRGv1 (Aug, 2016)	Homo sapiens
decoyJRGv1           	172.18.8.72	42843	ToMMo    	Decoy sequence of the Human Japanese Reference Genome, decoyJRGv1 (Aug, 2016)	Homo sapiens
16SrRNA              	172.18.8.77	50053	         	DDBJ 16S rRNA of prokaryotes (Dec, 2014)	
Ppatens_251_v3          	172.18.8.74	42013	Phytozome	Physcomitrella patens genome, v3.0 (Oct, 2007)	Physcomitrella patens;moss
Smoellendorffii_91_v1   	172.18.8.74	42023	Phytozome	Selaginella moellendorffii genome, v1.0 (Dec, 2007)	Selaginella moellendorffii;spikemoss
Creinhardtii_281_v5_5   	172.18.8.74	42033	Phytozome	Chlamydomonas reinhardtii genome, v5.5 (May, 2014)	Chlamydomonas reinhardtii;green algae
Olucimarinus_231_v2     	172.18.8.74	42043	Phytozome	Ostreococcus lucimarinus genome, v2.0 (Jan, 2011)	Ostreococcus lucimarinus;o. lucimarinus
Cgrandiflora_v1         	172.18.8.74	47043	Phytozome	Capsella grandiflora genome, v1.1	Capsella grandiflora;c. grandiflora
Crubella_v1             	172.18.8.74	47053	Phytozome	Capsella rubella genome, v1.0	Capsella rubella;red shepherd's purse
Cpapaya_r.Dec2008       	172.18.8.74	47063	Phytozome	Carica papaya genome, ASGPBv0.4	Carica papaya;papaya
CsubellipsoideaC169_v2.0	172.18.8.74	47103	Phytozome	Coccomyxa subellipsoidea C-169 genome, v2.0	Coccomyxa subellipsoidea;c. subellipsoidea
Csativus_v1             	172.18.8.74	47113	Phytozome	Cucumis sativus genome, v1.0	Cucumis sativus;cucumber
Egrandis_v2.0           	172.18.8.74	47123	Phytozome	Eucalyptus grandis genome, v2.0	Eucalyptus grandis;eucalyptus
Fvesca_v1.1             	172.18.8.74	47143	Phytozome	Fragaria vesca genome, v1.1	Fragaria vesca;strawberry
Graimondii_v2.0         	172.18.8.74	47153	Phytozome	Gossypium raimondii genome, v2.1	Gossypium raimondii;cotton
Lusitatissimum_BGIv1.0  	172.18.8.74	47173	Phytozome	Linum usitatissimum genome, v1.0	Linum usitatissimum;flax
Mdomestica_v1.0         	172.18.8.74	47183	Phytozome	Malus domestica genome, v1.0	Malus domestica;apple
Mesculenta_v6           	172.18.8.74	47193	Phytozome	Manihot esculenta genome, v6.1	Manihot esculenta;cassava
MpusillaCCMP1545_v3.0   	172.18.8.74	47203	Phytozome	Micromonas pusilla CCMP1545 genome, v3.0	Micromonas pusilla;picoplanktonic green alga
MpusillaRCC299_v3.0     	172.18.8.74	47213	Phytozome	Micromonas sp. RCC299 genome, v3.0	Micromonas pusilla;picoplanktonic green alga
Mguttatus_v2.0          	172.18.8.74	47223	Phytozome	Mimulus guttatus genome, v2.0	Mimulus guttatus;monkey flower
Ppersica_v2.0           	172.18.8.74	47293	Phytozome	Prunus persica genome, v2.1	Prunus persica;peach
Rcommunis_TIGR.0.1      	172.18.8.74	47303	Phytozome	Ricinus communis genome, v0.1	Ricinus communis;castor bean
Spolyrhiza_v1           	172.18.8.74	47333	Phytozome	Spirodela polyrhiza genome, v2	Spirodela polyrhiza;giant duckweed
Vcarteri_v2             	172.18.8.74	47343	Phytozome	Volvox carteri genome, v2.0	Volvox carteri;green alga
Ptrichocarpa_v3.0       	172.18.8.74	47353	Phytozome	Populus trichocarpa genome, v3.0	Populus trichocarpa;western balsam poplar
refseq70             	172.18.8.74	60003	RefSeq   	RefSeq complete RNA release 70 (May, 2015)	
refseq77             	172.18.8.74	60073	RefSeq   	RefSeq complete RNA release 77 (Jul, 2016)	
refseq78             	172.18.8.74	60083	RefSeq   	RefSeq complete RNA release 78 (Sep, 2016)	
refseq               	172.18.8.74	60083	RefSeq   	RefSeq complete RNA release 78 (Sep, 2016)	
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
togogenome74         	172.18.8.70	60243	         	TogoGenome from RefSeq 74 (Jan, 2016)	
togogenome           	172.18.8.70	60243	         	TogoGenome from RefSeq 74 (Jan, 2016)	
ddbj106hum           	172.18.8.77	51023	DDBJ     	DDBJ release 106.0, HUM division (Sep, 2016)	ddbjhum
ddbj106pri           	172.18.8.76	51033	DDBJ     	DDBJ release 106.0, PRI division (Sep, 2016)	ddbjpri
ddbj106rod           	172.18.8.72	51043	DDBJ     	DDBJ release 106.0, ROD division (Sep, 2016)	ddbjrod
ddbj106mam           	172.18.8.76	51053	DDBJ     	DDBJ release 106.0, MAM division (Sep, 2016)	ddbjmam
ddbj106vrt           	172.18.8.76	51063	DDBJ     	DDBJ release 106.0, VRT division (Sep, 2016)	ddbjvrt
ddbj106inv           	172.18.8.73	51073	DDBJ     	DDBJ release 106.0, INV division (Sep, 2016)	ddbjinv
ddbj106pln           	172.18.8.78	51083	DDBJ     	DDBJ release 106.0, PLN division (Sep, 2016)	ddbjpln
ddbj106bct           	172.18.8.78	51093	DDBJ     	DDBJ release 106.0, BCT division (Sep, 2016)	ddbjbct
ddbj106vrl           	172.18.8.75	51103	DDBJ     	DDBJ release 106.0, VRL division (Sep, 2016)	ddbjvrl
ddbj106phg           	172.18.8.78	51113	DDBJ     	DDBJ release 106.0, PHG division (Sep, 2016)	ddbjphg
ddbj106pat           	172.18.8.77	51123	DDBJ     	DDBJ release 106.0, PAT division (Sep, 2016)	ddbjpat
ddbj106env           	172.18.8.77	51133	DDBJ     	DDBJ release 106.0, ENV division (Sep, 2016)	ddbjenv
ddbj106syn           	172.18.8.73	51143	DDBJ     	DDBJ release 106.0, SYN division (Sep, 2016)	ddbjsyn
ddbj106est           	172.18.8.73	51153	DDBJ     	DDBJ release 106.0, EST division (Sep, 2016)	ddbjest
ddbj106tsa           	172.18.8.72	51163	DDBJ     	DDBJ release 106.0, TSA division (Sep, 2016)	ddbjtsa
ddbj106gss           	172.18.8.76	51173	DDBJ     	DDBJ release 106.0, GSS division (Sep, 2016)	ddbjgss
ddbj106htc           	172.18.8.73	51183	DDBJ     	DDBJ release 106.0, HTC division (Sep, 2016)	ddbjhtc
ddbj106htg           	172.18.8.72	51193	DDBJ     	DDBJ release 106.0, HTG division (Sep, 2016)	ddbjhtg
ddbj106sts           	172.18.8.78	51203	DDBJ     	DDBJ release 106.0, STS division (Sep, 2016)	ddbjsts
ddbj106una           	172.18.8.73	51213	DDBJ     	DDBJ release 106.0, UNA division (Sep, 2016)	ddbjuna
--EOS--

return 1 ;
