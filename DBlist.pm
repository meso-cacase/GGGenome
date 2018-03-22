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
hg38                     	172.18.8.75	40013	UCSC	Human genome, GRCh38/hg38 (Dec, 2013)	Homo sapiens
hg19                     	172.18.8.78	40023	UCSC	Human genome, GRCh37/hg19 (Feb, 2009)	Homo sapiens
mm10                     	172.18.8.78	40033	UCSC	Mouse genome, GRCm38/mm10 (Dec, 2011)	Mus musculus
mm9                      	172.18.8.78	40043	UCSC	Mouse genome, NCBI37/mm9 (Jul, 2007)	Mus musculus
vicPac2                  	172.18.8.78	40053	UCSC	Alpaca genome, Vicugna_pacos-2.0.1/vicPac2 (Mar, 2013)	Vicugna pacos
dasNov3                  	172.18.8.78	40063	UCSC	Armadillo genome, Baylor/dasNov3 (Dec, 2011)	Dasypus novemcinctus
papAnu2                  	172.18.8.78	40073	UCSC	Baboon genome, Baylor Panu_2.0/papAnu2 (Mar, 2012)	Papio anubis
otoGar3                  	172.18.8.78	40083	UCSC	Bushbaby genome, Broad/otoGar3 (Mar, 2011)	Otolemur garnettii
felCat5                  	172.18.8.78	40093	UCSC	Cat genome, ICGSC Felis_catus 6.2/felCat5 (Sep, 2011)	Felis catus
panTro4                  	172.18.8.78	40103	UCSC	Chimp genome, CSAC 2.1.4/panTro4 (Feb, 2011)	Pan troglodytes
criGri1                  	172.18.8.78	40113	UCSC	Chinese hamster genome, C_griseus_v1.0/criGri1 (Jul, 2013)	Cricetulus griseus
bosTau8                  	172.18.8.78	40123	UCSC	Cow genome, Bos_taurus_UMD_3.1.1/bosTau8 (Jun, 2014)	Bos taurus
canFam3                  	172.18.8.78	40133	UCSC	Dog genome, Broad CanFam3.1/canFam3 (Sep, 2011)	Canis lupus familiaris
turTru2                  	172.18.8.78	40143	UCSC	Dolphin genome, Baylor Ttru_1.4/turTru2 (Oct, 2011)	Tursiops truncatus
loxAfr3                  	172.18.8.78	40153	UCSC	Elephant genome, Broad/loxAfr3 (Jul, 2009)	Loxodonta africana
musFur1                  	172.18.8.78	40163	UCSC	Ferret genome, MusPutFur1.0/musFur1 (Apr, 2011)	Mustela putorius furo
nomLeu3                  	172.18.8.78	40173	UCSC	Gibbon genome, GGSC Nleu3.0/nomLeu3 (Oct, 2012)	Nomascus leucogenys
gorGor3                  	172.18.8.78	40183	UCSC	Gorilla genome, gorGor3.1/gorGor3 (May, 2011)	Gorilla gorilla gorilla
cavPor3                  	172.18.8.78	40193	UCSC	Guinea pig genome, Broad/cavPor3 (Feb, 2008)	Cavia porcellus
eriEur2                  	172.18.8.78	40203	UCSC	Hedgehog genome, EriEur2.0/eriEur2 (May, 2012)	Erinaceus europaeus
equCab2                  	172.18.8.78	40213	UCSC	Horse genome, Broad/equCab2 (Sep, 2007)	Equus caballus
dipOrd1                  	172.18.8.78	40223	UCSC	Kangaroo rat genome, Broad/dipOrd1 (Jul, 2008)	Dipodomys ordii
triMan1                  	172.18.8.78	40233	UCSC	Manatee genome, Broad v1.0/triMan1 (Oct, 2011)	Trichechus manatus latirostris
calJac3                  	172.18.8.78	40243	UCSC	Marmoset genome, WUGSC 3.2/calJac3 (Mar, 2009)	Callithrix jacchus
pteVam1                  	172.18.8.78	40253	UCSC	Megabat genome, Broad/pteVam1 (Jul, 2008)	Pteropus vampyrus
myoLuc2                  	172.18.8.78	40263	UCSC	Microbat genome, Broad Institute Myoluc2.0/myoLuc2 (Jul, 2010)	Myotis lucifugus
balAcu1                  	172.18.8.77	40273	UCSC	Minke whale genome, BalAcu1.0/balAcu1 (Oct, 2013)	Balaenoptera acutorostrata scammoni
micMur1                  	172.18.8.77	40283	UCSC	Mouse lemur genome, Broad/micMur1 (Jul, 2007)	Microcebus murinus
hetGla2                  	172.18.8.77	40293	UCSC	Naked mole-rat genome, Broad HetGla_female_1.0/hetGla2 (Jan, 2012)	Heterocephalus glaber
monDom5                  	172.18.8.77	40303	UCSC	Opossum genome, Broad/monDom5 (Oct, 2006)	Monodelphis domestica
ponAbe2                  	172.18.8.77	40313	UCSC	Orangutan genome, WUGSC 2.0.2/ponAbe2 (Jul, 2007)	Pongo abelii
ailMel1                  	172.18.8.77	40323	UCSC	Panda genome, BGI-Shenzhen 1.0/ailMel1 (Dec, 2009)	Ailuropoda melanoleuca
susScr3                  	172.18.8.77	40333	UCSC	Pig genome, SGSC Sscrofa10.2/susScr3 (Aug, 2011)	Sus scrofa
ochPri3                  	172.18.8.77	40343	UCSC	Pika genome, OchPri3.0/ochPri3 (May, 2012)	Ochotona princeps
ornAna1                  	172.18.8.77	40353	UCSC	Platypus genome, WUGSC 5.0.1/ornAna1 (Mar, 2007)	Ornithorhynchus anatinus
oryCun2                  	172.18.8.77	40363	UCSC	Rabbit genome, Broad/oryCun2 (Apr, 2009)	Oryctolagus cuniculus
rn6                      	172.18.8.77	40373	UCSC	Rat genome, RGSC 6.0/rn6 (Jul, 2014)	Rattus norvegicus
rn5                      	172.18.8.77	40383	UCSC	Rat genome, RGSC 5.0/rn5 (Mar, 2012)	Rattus norvegicus
rheMac3                  	172.18.8.77	40393	UCSC	Rhesus genome, BGI CR_1.0/rheMac3 (Oct, 2010)	Macaca mulatta
proCap1                  	172.18.8.77	40403	UCSC	Rock hyrax genome, Broad/proCap1 (Jul, 2008)	Procavia capensis;cape hyrax
oviAri3                  	172.18.8.77	40413	UCSC	Sheep genome, ISGC Oar_v3.1/oviAri3 (Aug, 2012)	Ovis aries
sorAra2                  	172.18.8.77	40423	UCSC	Shrew genome, Broad/sorAra2 (Aug, 2008)	Sorex araneus
choHof1                  	172.18.8.77	40433	UCSC	Sloth genome, Broad/choHof1 (Jul, 2008)	Choloepus hoffmanni
speTri2                  	172.18.8.77	40443	UCSC	Squirrel genome, Broad/speTri2 (Nov, 2011)	Spermophilus tridecemlineatus
saiBol1                  	172.18.8.77	40453	UCSC	Squirrel monkey genome, Broad/saiBol1 (Oct, 2011)	Saimiri boliviensis
tarSyr1                  	172.18.8.77	40463	UCSC	Tarsier genome, Broad/tarSyr1 (Aug, 2008)	Tarsius syrichta
sarHar1                  	172.18.8.77	40473	UCSC	Tasmanian devil genome, WTSI Devil_ref v7.0/sarHar1 (Feb, 2011)	Sarcophilus harrisii
echTel2                  	172.18.8.77	40483	UCSC	Tenrec genome, Broad/echTel2 (Nov, 2012)	Echinops telfairi
tupBel1                  	172.18.8.77	40493	UCSC	Tree shrew genome, Broad/tupBel1 (Dec, 2006)	Tupaia belangeri
macEug2                  	172.18.8.77	40503	UCSC	Wallaby genome, TWGS Meug_1.1/macEug2 (Sep, 2009)	Macropus eugenii
cerSim1                  	172.18.8.77	40513	UCSC	White rhinoceros genome, CerSimSim1.0/cerSim1 (May, 2012)	Ceratotherium simum
allMis1                  	172.18.8.76	40523	UCSC	American alligator genome, allMis0.2/allMis1 (Aug, 2012)	Alligator mississippiensis
gadMor1                  	172.18.8.76	40533	UCSC	Atlantic cod genome, Genofisk GadMor_May2010/gadMor1 (May, 2010)	Gadus morhua
melUnd1                  	172.18.8.76	40543	UCSC	Budgerigar genome, WUSTL v6.3/melUnd1 (Sep, 2011)	Melopsittacus undulatus
galGal4                  	172.18.8.76	40553	UCSC	Chicken genome, ICGSC Gallus_gallus-4.0/galGal4 (Nov, 2011)	Gallus gallus
latCha1                  	172.18.8.76	40563	UCSC	Coelacanth genome, Broad/latCha1 (Aug, 2011)	Latimeria chalumnae
calMil1                  	172.18.8.76	40573	UCSC	Elephant shark genome, Callorhinchus_milii-6.1.3/calMil1 (Dec, 2013)	Callorhinchus milii
fr3                      	172.18.8.76	40583	UCSC	Fugu genome, FUGU5/fr3 (Oct, 2011)	Takifugu rubripes
petMar2                  	172.18.8.76	40593	UCSC	Lamprey genome, WUGSC 7.0/petMar2 (Sep, 2010)	Petromyzon marinus
anoCar2                  	172.18.8.76	40603	UCSC	Lizard genome, Broad AnoCar2.0/anoCar2 (May, 2010)	Anolis carolinensis
oryLat2                  	172.18.8.76	40613	UCSC	Medaka genome, NIG/UT MEDAKA1/oryLat2 (Oct, 2005)	Oryzias latipes
geoFor1                  	172.18.8.76	40623	UCSC	Medium ground finch genome, GeoFor_1.0/geoFor1 (Apr, 2012)	Geospiza fortis
oreNil2                  	172.18.8.76	40633	UCSC	Nile tilapia genome, Broad oreNil1.1/oreNil2 (Jan, 2011)	Oreochromis niloticus
chrPic1                  	172.18.8.76	40643	UCSC	Painted turtle genome, v3.0.1/chrPic1 (Dec, 2011)	Chrysemys picta bellii
gasAcu1                  	172.18.8.76	40653	UCSC	Stickleback genome, Broad/gasAcu1 (Feb, 2006)	Gasterosteus aculeatus
tetNig2                  	172.18.8.76	40663	UCSC	Tetraodon genome, Genoscope 8.0/tetNig2 (Mar, 2007)	Tetraodon nigroviridis
melGal1                  	172.18.8.76	40673	UCSC	Turkey genome, TGC Turkey_2.01/melGal1 (Dec, 2009)	Meleagris gallopavo
xenTro3                  	172.18.8.76	40683	UCSC	Xenopus tropicalis genome, JGI 4.2/xenTro3 (Nov, 2009)	Xenopus tropicalis;western clawed frog
taeGut2                  	172.18.8.76	40693	UCSC	Zebra finch genome, WashU taeGut324/taeGut2 (Feb, 2013)	Taeniopygia guttata
danRer7                  	172.18.8.76	40703	UCSC	Zebrafish genome, Zv9/danRer7 (Jul, 2010)	Danio rerio
ci2                      	172.18.8.76	40713	UCSC	Ciona intestinalis genome, JGI 2.1/ci2 (Mar, 2005)	Ciona intestinalis;transparent sea squirt
braFlo1                  	172.18.8.76	40723	UCSC	Lancelet genome, JGI 1.0/braFlo1 (Mar, 2006)	Branchiostoma floridae
strPur2                  	172.18.8.76	40733	UCSC	S. purpuratus genome, Baylor 2.1/strPur2 (Sep, 2006)	Strongylocentrotus purpuratus;purple sea urchin
anoGam1                  	172.18.8.76	40743	UCSC	A. gambiae genome, IAGEC MOZ2/anoGam1 (Feb, 2003)	Anopheles gambiae;african malaria mosquito
apiMel2                  	172.18.8.76	40753	UCSC	A. mellifera genome, Baylor 2.0/apiMel2 (Jan, 2005)	Apis mellifera;honeybee
droAna2                  	172.18.8.76	40763	UCSC	D. ananassae genome, Agencourt prelim/droAna2 (Aug, 2005)	Drosophila ananassae;fruit fly
droEre1                  	172.18.8.76	40773	UCSC	D. erecta genome, Agencourt prelim/droEre1 (Aug, 2005)	Drosophila erecta;fruit fly
droGri1                  	172.18.8.76	40783	UCSC	D. grimshawi genome, Agencourt prelim/droGri1 (Aug, 2005)	Drosophila grimshawi;fruit fly
dm6                      	172.18.8.76	40793	UCSC	D. melanogaster genome, BDGP Release 6 + ISO1 MT/dm6 (Aug, 2014)	Drosophila melanogaster;fruit fly
dm3                      	172.18.8.76	40803	UCSC	Drosophila melanogaster genome, BDGP R5/dm3 (Apr, 2006)	Drosophila melanogaster;fruit fly
droMoj2                  	172.18.8.76	40813	UCSC	D. mojavensis genome, Agencourt prelim/droMoj2 (Aug, 2005)	Drosophila mojavensis;fruit fly
droPer1                  	172.18.8.76	40823	UCSC	D. persimilis genome, Broad/droPer1 (Oct, 2005)	Drosophila persimilis;fruit fly
dp3                      	172.18.8.76	40833	UCSC	D. pseudoobscura genome, FlyBase 1.03/dp3 (Nov, 2004)	Drosophila pseudoobscura;fruit fly
droSec1                  	172.18.8.76	40843	UCSC	D. sechellia genome, Broad/droSec1 (Oct, 2005)	Drosophila sechellia;fruit fly
droSim1                  	172.18.8.76	40853	UCSC	D. simulans genome, WUGSC mosaic 1.0/droSim1 (Apr, 2005)	Drosophila simulans;fruit fly
droVir2                  	172.18.8.76	40863	UCSC	D. virilis genome, Agencourt prelim/droVir2 (Aug, 2005)	Drosophila virilis;fruit fly
droYak2                  	172.18.8.76	40873	UCSC	D. yakuba genome, WUGSC 7.1/droYak2 (Nov, 2005)	Drosophila yakuba;fruit fly
caePb2                   	172.18.8.76	40883	UCSC	C. brenneri genome, WUGSC 6.0.1/caePb2 (Feb, 2008)	Caenorhabditis brenneri;nematode worm
cb3                      	172.18.8.76	40893	UCSC	C. briggsae genome, WUGSC 1.0/cb3 (Jan, 2007)	Caenorhabditis briggsae;nematode worm
ce10                     	172.18.8.76	40903	UCSC	C. elegans genome, WS220/ce10 (Oct, 2010)	Caenorhabditis elegans;nematode worm
caeJap1                  	172.18.8.76	40913	UCSC	C. japonica genome, WUGSC 3.0.2/caeJap1 (Mar, 2008)	Caenorhabditis japonica;nematode worm
caeRem3                  	172.18.8.76	40923	UCSC	C. remanei genome, WUGSC 15.0.1/caeRem3 (May, 2007)	Caenorhabditis remanei;nematode worm
priPac1                  	172.18.8.76	40933	UCSC	P. pacificus genome, WUGSC 5.0/priPac1 (Feb, 2007)	Pristionchus pacificus;parasitic nematode
sacCer3                  	172.18.8.76	40943	UCSC	S. cerevisiae (S288C) genome, SacCer_Apr2011/sacCer3 (Apr, 2011)	Saccharomyces cerevisiae;budding yeast
aplCal1                  	172.18.8.76	40953	UCSC	Sea hare genome, Broad 2.0/aplCal1 (Sep, 2008)	Aplysia californica
eboVir3                  	172.18.8.76	40963	UCSC	Ebola virus genome, Sierra Leone G3683/KM034562.1/eboVir3 (Jun, 2014)	Filoviridae ebolavirus
hg18                     	172.18.8.76	40973	UCSC	Human genome, NCBI36/hg18 (Mar, 2006)	Homo sapiens
OryAfe1.0                	172.18.8.76	43073	Ensembl	Aardvark genome, OryAfe1.0 (May, 2012)	Orycteropus afer
PoeFor_5.1.2             	172.18.8.76	43083	Ensembl	Amazon molly genome, Poecilia_formosa-5.1.2 (Oct, 2013)	Poecilia formosa
CSAV2.0                  	172.18.8.76	43093	Ensembl	Ciona savignyi genome, CSAV 2.0 (Oct, 2005)	Ciona savignyi;pacific transparent sea squirt
AstMex102                	172.18.8.76	43103	Ensembl	Cave fish genome, AstMex102 (Apr, 2013)	Astyanax mexicanus
PelSin_1.0               	172.18.8.76	43113	Ensembl	Chinese softshell turtle genome, PelSin_1.0 (Oct, 2011)	Pelodiscus sinensis
MacFas5.0                	172.18.8.76	43123	Ensembl	Crab-eating macaque genome, MacFas5.0 (Jun, 2013)	Macaca fascicularis
BGI_duck_1.0             	172.18.8.76	43133	Ensembl	Duck genome, BGI_duck_1.0 (Apr, 2013)	Anas platyrhynchos
FicAlb_1.4               	172.18.8.76	43143	Ensembl	Flycatcher genome, FicAlb_1.4 (Jan, 2012)	Ficedula albicollis
Pham                     	172.18.8.76	43153	Ensembl	Hamadryas baboon genome, Pham (Nov, 2008)	Papio hamadryas
Xipmac4.4.2              	172.18.8.76	43163	Ensembl	Platyfish genome, Xipmac4.4.2 (Jan, 2012)	Xiphophorus maculatus
MicOch1.0                	172.18.8.76	43173	Ensembl	Prairie vole genome, MicOch1.0 (Nov, 2012)	Microtus ochrogaster
PhyMac_2.0.2             	172.18.8.76	43183	Ensembl	Sperm whale genome, PhyMac_2.0.2 (Sep, 2013)	Physeter macrocephalus
LepOcu1                  	172.18.8.76	43193	Ensembl	Spotted gar genome, LepOcu1 (Dec, 2011)	Lepisosteus oculatus
ChlSab1.1                	172.18.8.76	43203	Ensembl	Green monkey genome, ChlSab1.1 (Mar, 2014)	Chlorocebus sabaeus
Acyr_2.0                 	172.18.8.76	43213	EnsemblMetazoa	Acyrthosiphon pisum genome, Acyr_2.0 (Jun, 2010)	Acyrthosiphon pisum;pea aphid
AaegL3                   	172.18.8.76	43223	EnsemblMetazoa	Aedes aegypti genome, AaegL3 (Dec, 2013)	Aedes aegypti;yellowfever mosquito
Aqu1                     	172.18.8.76	43233	EnsemblMetazoa	Amphimedon queenslandica genome, Aqu1 (Oct, 2010)	Amphimedon queenslandica;sponge
AdarC3                   	172.18.8.76	43243	EnsemblMetazoa	Anopheles darlingi genome, AdarC3 (Jan, 2014)	Anopheles darlingi;mosquito
Attacep1.0               	172.18.8.76	43253	EnsemblMetazoa	Atta cephalotes genome, Attacep1.0 (Jul, 2012)	Atta cephalotes;leafcutter ant
ASM15162v1               	172.18.8.76	43263	EnsemblMetazoa	Silkworm genome, ASM15162v1 (Feb, 2013)	Bombyx mori
B_malayi_3.0             	172.18.8.76	43273	EnsemblMetazoa	Brugia malayi genome, B_malayi-3.0 (Dec, 2012)	Brugia malayi;filarial nematode worm
Capte_v1.0               	172.18.8.76	43283	EnsemblMetazoa	Capitella teleta genome, Capitella teleta v1.0 (Dec, 2012)	Capitella teleta;polychaete worm
oyster_v9                	172.18.8.76	43293	EnsemblMetazoa	Crassostrea gigas genome, oyster_v9 (Sep, 2012)	Crassostrea gigas;pacific oyster
CpipJ2                   	172.18.8.76	43303	EnsemblMetazoa	Culex quinquefasciatus genome, CpipJ2 (Jan, 2007)	Culex quinquefasciatus;southern house mosquito
DanPle_1.0               	172.18.8.76	43313	EnsemblMetazoa	Danaus plexippus genome, DanPle_1.0 (Nov, 2011)	Danaus plexippus;monarch butterfly
Dappu_V1.0               	172.18.8.76	43323	EnsemblMetazoa	Daphnia pulex genome, V1.0 (Feb, 2011)	Daphnia pulex;water flea
DendPond_1.0             	172.18.8.76	43333	EnsemblMetazoa	Dendroctonus ponderosae genome, DendPond_male_1.0 (Apr, 2013)	Dendroctonus ponderosae;mountain pine beetle
dwil_caf1                	172.18.8.76	43343	EnsemblMetazoa	Drosophila willistoni genome, dwil_caf1 (Jul, 2008)	Drosophila willistoni;fruit fly
Hmel1                    	172.18.8.76	43353	EnsemblMetazoa	Heliconius melpomene genome, Hmel1 (Feb, 2012)	Heliconius melpomene;postman butterfly
Helro1                   	172.18.8.76	43363	EnsemblMetazoa	Helobdella robusta genome, Helro1 (Dec, 2012)	Helobdella robusta;californian leech
IscaW1                   	172.18.8.76	43373	EnsemblMetazoa	Ixodes scapularis genome, IscaW1 (Aug, 2007)	Ixodes scapularis;black-legged tick
Loa_loa_V3               	172.18.8.76	43383	EnsemblMetazoa	Loa loa genome, Loa_loa_V3 (Jan, 2010)	Loa loa;eye worm
Lotgi1                   	172.18.8.76	43393	EnsemblMetazoa	Lottia gigantea genome, Lotgi1 (Jan, 2013)	Lottia gigantea;giant owl limpet
Msca1                    	172.18.8.76	43403	EnsemblMetazoa	Megaselia scalaris genome, Msca1 (Feb, 2013)	Megaselia scalaris;humpbacked fly
MelCinx1.0               	172.18.8.76	43413	EnsemblMetazoa	Melitaea cinxia genome, MelCinx1.0 (Jul, 2014)	Melitaea cinxia;glanville fritillary
MneLei                   	172.18.8.76	43423	EnsemblMetazoa	Mnemiopsis leidyi genome, MneLei_Aug2011 (Sep, 2011)	Mnemiopsis leidyi;sea walnut
Nvit_2.1                 	172.18.8.76	43433	EnsemblMetazoa	Nasonia vitripennis genome, Nvit_2.1 (Nov, 2012)	Nasonia vitripennis;parasitic wasp
ASM20922v1               	172.18.8.76	43443	EnsemblMetazoa	Nematostella vectensis genome, ASM20922v1 (Sep, 2007)	Nematostella vectensis;starlet sea anemone
Cameroon_v3              	172.18.8.76	43453	EnsemblMetazoa	Onchocerca volvulus genome, Cameroon_v3 (Nov, 2013)	Onchocerca volvulus;parasitic nematode
PhumU2                   	172.18.8.76	43463	EnsemblMetazoa	Pediculus humanus genome, PhumU2 (Nov, 2008)	Pediculus humanus;body louse
RproC1                   	172.18.8.76	43473	EnsemblMetazoa	Rhodnius prolixus genome, RproC1 (Dec, 2010)	Rhodnius prolixus;triatomid bug
ASM23792v2               	172.18.8.76	43483	EnsemblMetazoa	Schistosoma mansoni genome, ASM23792v2 (Apr, 2012)	Schistosoma mansoni;blood fluke
Si_gnG                   	172.18.8.76	43493	EnsemblMetazoa	Solenopsis invicta genome, Si_gnG (Feb, 2011)	Solenopsis invicta;red imported fire ant
Smar1                    	172.18.8.76	43503	EnsemblMetazoa	Strigamia maritima genome, Smar1 (Feb, 2013)	Strigamia maritima;european centipede
ASM23943v1               	172.18.8.76	43513	EnsemblMetazoa	Tetranychus urticae genome, ASM23943v1 (Nov, 2011)	Tetranychus urticae;two-spotted spider mite
Tcas3                    	172.18.8.76	43523	EnsemblMetazoa	Tribolium castaneum genome, Tcas3 (Feb, 2010)	Tribolium castaneum;red flour beetle
Tspiralis1               	172.18.8.76	43533	EnsemblMetazoa	Trichinella spiralis genome, Tspiralis1 (Mar, 2011)	Trichinella spiralis;trichina worm
ASM15027v1               	172.18.8.76	43543	EnsemblMetazoa	Trichoplax adhaerens genome, ASM15027v1 (Aug, 2006)	Trichoplax adhaerens
ZooNev1.0                	172.18.8.76	43553	EnsemblMetazoa	Zootermopsis nevadensis genome, ZooNev1.0 (Jun, 2014)	Zootermopsis nevadensis;dampwood termite
ASM34733v1               	172.18.8.75	45013	EnsemblPlants	Aegilops tauschii genome, ASM34733v1 (Dec, 2013)	Aegilops tauschii;tausch's goatgrass
AMTR1.0                  	172.18.8.75	45023	EnsemblPlants	Amborella trichopoda genome, AMTR1.0 (Jan, 2014)	Amborella trichopoda
Araly_v.1.0              	172.18.8.75	45033	EnsemblPlants	Arabidopsis lyrata genome, v.1.0 (Dec, 2008)	Arabidopsis lyrata;lyre-leaved rock-cress
TAIR10_en                	172.18.8.75	45043	EnsemblPlants	Arabidopsis thaliana genome, TAIR10 (Sep, 2010)	Arabidopsis thaliana;thale cress
Bradi_v1.0               	172.18.8.75	45053	EnsemblPlants	Brachypodium distachyon genome, v1.0 (Jan, 2009)	Brachypodium distachyon;purple false brome
Braol_v2.1               	172.18.8.75	45063	EnsemblPlants	Brassica oleracea genome, v2.1	Brassica oleracea;wild cabbage
IVFCAASv1                	172.18.8.75	45073	EnsemblPlants	Brassica rapa genome, IVFCAASv1 (Aug, 2009)	Brassica rapa ssp. pekinensis;chinese cabbage
Chlre_v3.1               	172.18.8.75	45083	EnsemblPlants	Chlamydomonas reinhardtii genome, v3.1 (Nov, 2007)	Chlamydomonas reinhardtii;green algae
ASM9120v1                	172.18.8.75	45093	EnsemblPlants	Cyanidioschyzon merolae genome, ASM9120v1 (Nov, 2008)	Cyanidioschyzon merolae;red alga
Soybn_V1.0               	172.18.8.75	45103	EnsemblPlants	Glycine max genome, V1.0 (Jan, 2010)	Glycine max;soybean
Horvu_v1                 	172.18.8.75	45113	EnsemblPlants	Hordeum vulgare genome, 082214v1 (Mar, 2012)	Hordeum vulgare;barley
Lperr_V1.4               	172.18.8.75	45123	EnsemblPlants	Leersia perrieri genome, Lperr_V1.4 (Mar, 2014)	Leersia perrieri
MedtrA17_4.0             	172.18.8.75	45133	EnsemblPlants	Medicago truncatula str. A17 genome, MedtrA17_4.0 (Jun, 2014)	Medicago truncatula str. A17;barrel medic
MA1                      	172.18.8.75	45143	EnsemblPlants	Musa acuminata genome, MA1 (Aug, 2012)	Musa acuminata;banana
Obart_v1.0               	172.18.8.75	45153	EnsemblPlants	Oryza barthii genome, Obart_v1.0 (Apr, 2014)	Oryza barthii;african wild rice
Orybr_v1.4b              	172.18.8.75	45163	EnsemblPlants	Oryza brachyantha genome, Oryza_brachyantha.v1.4b (May, 2011)	Oryza brachyantha;african wild rice
AGI1.1                   	172.18.8.75	45173	EnsemblPlants	Oryza glaberrima genome, AGI1.1 (May, 2011)	Oryza glaberrima;african wild rice
Orygl                    	172.18.8.75	45183	EnsemblPlants	Oryza glumaepatula genome, ALNU02000000 (Aug, 2013)	Oryza glumaepatula;brazilian wild rice
Orylo_v0117              	172.18.8.75	45193	EnsemblPlants	Oryza longistaminata genome, v0117-2013Aug (Aug, 2013)	Oryza longistaminata;longstamen rice
Oryme_v1.3               	172.18.8.75	45203	EnsemblPlants	Oryza meridionalis genome, Oryza_meridionalis_v1.3 (Oct, 2014)	Oryza meridionalis;australian wild rice
Oryni                    	172.18.8.75	45213	EnsemblPlants	Oryza nivara genome, AWHD00000000 (Aug, 2013)	Oryza nivara;indian wild rice
Orypu                    	172.18.8.75	45223	EnsemblPlants	Oryza punctata genome, AVCL00000000 (Aug, 2013)	Oryza punctata;red rice
PRJEB4137                	172.18.8.75	45233	EnsemblPlants	Oryza rufipogon genome, PRJEB4137 (Aug, 2013)	Oryza rufipogon;brownbeard rice
ASM465v1                 	172.18.8.75	45243	EnsemblPlants	Oryza sativa Indica genome, ASM465v1 (Jan, 2005)	Oryza sativa ssp. indica;rice
ASM9206v1                	172.18.8.75	45263	EnsemblPlants	Ostreococcus lucimarinus genome, ASM9206v1 (Jan, 2011)	Ostreococcus lucimarinus
ASM242v1                 	172.18.8.75	45273	EnsemblPlants	Physcomitrella patens genome, ASM242v1 (Jul, 2006)	Physcomitrella patens;moss
Poptr_JGI2.0             	172.18.8.75	45283	EnsemblPlants	Populus trichocarpa genome, JGI2.0 (Jan, 2010)	Populus trichocarpa;western balsam poplar
Prupe1_0                 	172.18.8.75	45293	EnsemblPlants	Prunus persica genome, Prupe1_0 (Mar, 2013)	Prunus persica;peach
Selml_v1.0               	172.18.8.75	45303	EnsemblPlants	Selaginella moellendorffii genome, v1.0 (May, 2011)	Selaginella moellendorffii;spikemoss
Setit_JGIv2.0            	172.18.8.75	45313	EnsemblPlants	Setaria italica genome, JGIv2.0 (Jan, 2012)	Setaria italica;foxtail millet
SL2.50                   	172.18.8.75	45323	EnsemblPlants	Solanum lycopersicum str. Heinz 1706 genome, SL2.50 (Oct, 2014)	Solanum lycopersicum str. Heinz 1706;tomato
SolTub_3.0               	172.18.8.75	45333	EnsemblPlants	Solanum tuberosum genome, SolTub_3.0 (May, 2011)	Solanum tuberosum;potato
Sorbi1                   	172.18.8.75	45343	EnsemblPlants	Sorghum bicolor genome, Sorbi1 (Dec, 2007)	Sorghum bicolor;sorghum
Thecc_20110822           	172.18.8.75	45353	EnsemblPlants	Theobroma cacao genome, Theobroma_cacao_20110822 (May, 2014)	Theobroma cacao;cacao
IWGSC1.0                 	172.18.8.75	45363	EnsemblPlants	Triticum aestivum genome, IWGSC1.0+popseq (Nov, 2014)	Triticum aestivum;wheat
ASM34745v1               	172.18.8.75	45373	EnsemblPlants	Triticum urartu genome, ASM34745v1 (Apr, 2013)	Triticum urartu;red wild einkorn
IGGP_12x                 	172.18.8.75	45383	EnsemblPlants	Vitis vinifera genome, IGGP_12x (Jun, 2011)	Vitis vinifera;grape
AGPv3                    	172.18.8.75	45393	EnsemblPlants	Zea mays genome, AGPv3 (Apr, 2013)	Zea mays;maize, Corn
Xenla7                   	172.18.8.70	42443	Xenbase	Xenopus laevis genome, JGI 7.1/Xenla7 (Dec, 2013)	Xenopus laevis;african clawed frog
TAIR10                   	172.18.8.70	42373	    	Arabidopsis thaliana genome, TAIR10 (Nov, 2010)	Arabidopsis thaliana;thale cress
rice                     	172.18.8.70	42293	    	Rice genome, Os-Nipponbare-Reference-IRGSP-1.0 (Oct, 2011)	Oryza sativa ssp. japonica;rice
sorBic                   	172.18.8.70	42403	    	Sorghum genome, Sorghum bicolor v2.1 (May, 2013)	Sorghum bicolor
bmor1                    	172.18.8.70	42303	Ensembl	Silkworm genome, Bmor1 (Apr, 2008)	Bombyx mori
pombe                    	172.18.8.70	42453	EnsemblFungi	S. pombe (972h-) genome, ASM294v2 (Nov, 2007)	Schizosaccharomyces pombe;fission yeast
MG8                      	172.18.8.77	42463	EnsemblFungi	Magnaporthe oryzae (70-15) genome, MG8 (Sep, 2011)	Magnaporthe oryzae;rice blast fungus
prok                     	172.18.8.70	42323	    	Prokaryotic TogoGenome from RefSeq 62 (Nov, 2013)	
ddbj                     	172.18.8.76	42313	DDBJ	DDBJ release 92.0 (Feb, 2013)	
Xentr7                   	172.18.8.77	43013	Xenbase  	Xenopus tropicalis genome, XenBase/JGI 7.1	Xenopus tropicalis;western clawed frog
Xentr8                   	172.18.8.77	43023	Xenbase  	Xenopus tropicalis genome, XenBase/JGI 8.0	Xenopus tropicalis;western clawed frog
Xentr9                   	172.18.8.77	42513	Xenbase  	Xenopus tropicalis genome, XenBase/JGI 9.0	Xenopus tropicalis;western clawed frog
Xenla9                   	172.18.8.77	42523	Xenbase  	Xenopus laevis genome, XenBase/JGI 9.1	Xenopus laevis;african clawed frog
macaque_CE_1             	172.18.8.77	43043	         	Crab-eating macaque genome, CE_1.0 (Jul, 2011)	Macaca fascicularis
macaque_CE_1_cds         	172.18.8.77	43053	         	Crab-eating macaque CDS, CE_1.0 (Jul, 2011)	Macaca fascicularis
KH                       	172.18.8.77	42533	         	Ciona intestinalis genome, KH (Jul, 2008)	Ciona intestinalis;transparent sea squirt
Spur_v3.1                	172.18.8.77	42543	SpBase   	S. purpuratus genome, Spur_v3.1 (Jun, 2011)	Strongylocentrotus purpuratus;purple sea urchin
h7                       	172.18.8.77	42553	NCBI     	Hydra genome, h7 (Aug, 2008)	Hydra vulgaris
Hydra_RP_1.0             	172.18.8.77	42563	NCBI     	Hydra genome, Hydra_RP_1.0 (Oct, 2009)	Hydra vulgaris
Brana_v4.1               	172.18.8.77	42573	Genoscope	Brassica napus genome, Genoscope v4.1 (Aug, 2014)	Brassica napus
lotus_r3.0               	172.18.8.77	42583	Kazusa   	Lotus japonicus genome, build 3.0 (Aug, 2015)	Lotus japonicus;japanese trefoil
Niben_v1.0.1             	172.18.8.77	42593	         	Nicotiana benthamiana genome, v1.0.1 (Jul, 2014)	Nicotiana benthamiana;tobacco
adzuki_ver3              	172.18.8.77	42603	         	Vigna angularis genome, ver3 (Nov, 2011)	Vigna angularis;adzuki bean
RSA_r1.0                 	172.18.8.77	42613	Kazusa   	Raphanus sativus genome, RSA_r1.0 (May, 2014)	Raphanus sativus;radish
MesAur1.0                	172.18.8.77	42623	         	Golden hamster genome, MesAur1.0 (Mar, 2013)	Mesocricetus auratus;golden hamster
ASM644v2                 	172.18.8.76	42633	EnsemblFungi	Debaryomyces hansenii (CBS767) genome, ASM644v2 (Feb, 2015)	Debaryomyces hansenii;marine yeast
ASM251v1                 	172.18.8.76	42643	EnsemblFungi	Kluyveromyces lactis genome, ASM251v1 (Feb, 2015)	Kluyveromyces lactis;kluyveromyces yeast
ASM252v1                 	172.18.8.76	42653	EnsemblFungi	Yarrowia lipolytica genome, ASM252v1 (May, 2012)	Yarrowia lipolytica;oleaginous yeast
RR                       	172.18.8.76	42663	EnsemblFungi	Fusarium graminearum genome, RR (Nov, 2014)	Fusarium graminearum;Gibberella zeae;wheat head blight fungus
CC3                      	172.18.8.72	42823	EnsemblFungi	Coprinopsis cinerea (okayama7#130) genome, CC3 (Aug, 2014)	Coprinopsis cinerea;Hormographiella aspergillata;inky cap fungus
BX                       	172.18.8.76	42673	         	Nicotiana tabacum (BX) genome, Ntab-BX (2014)	Nicotiana tabacum;tobacco
RHOziaDV1.0              	172.18.8.76	42683	NCBI     	Rhodotorula toruloides (NP11) genome, RHOziaDV1.0 (Apr, 2013)	Rhodotorula toruloides;oleaginous yeast
Tetth                    	172.18.8.76	42693	TGD      	Tetrahymena thermophila genome (Jun, 2014)	Tetrahymena thermophila
Tetbo                    	172.18.8.76	42703	TGD      	Tetrahymena borealis genome (Oct, 2012)	Tetrahymena borealis
Tetel                    	172.18.8.76	42713	TGD      	Tetrahymena elliotti genome (Oct, 2012)	Tetrahymena elliotti
Tetma                    	172.18.8.76	42723	TGD      	Tetrahymena malaccensis genome (Oct, 2012)	Tetrahymena malaccensis
img1                     	172.18.8.72	42733	IchDB    	Ichthyophthirius multifiliis macronuclear genome	Ichthyophthirius multifiliis;ciliate
stylo                    	172.18.8.72	42743	StyloDB  	Stylonychia lemnae macronuclear genome	Stylonychia lemnae;ciliate
oxy                      	172.18.8.72	42753	OxyDB    	Oxytricha trifallax macronuclear genome	Oxytricha trifallax;ciliate
oxymic                   	172.18.8.72	42763	OxyDB    	Oxytricha trifallax micronuclear genome	Oxytricha trifallax;ciliate
A_nidulans_FGSC_A4       	172.18.8.72	42773	AspGD    	Aspergillus nidulans (FGSC A4) genome, s10-m04-r06 (Apr, 2016)	Aspergillus nidulans;Emericella nidulans
A_fumigatus_Af293        	172.18.8.72	42783	AspGD    	Aspergillus fumigatus (Af293) genome, s03-m05-r06 (Apr, 2016)	Aspergillus fumigatus;Neosartorya fumigata
C_glabrata_CBS138        	172.18.8.72	42793	CGD      	Candida glabrata (CBS138) genome, s02-m07-r08 (Jun, 2016)	Candida glabrata;Torulopsis glabrata
C_albicans_SC5314        	172.18.8.72	42803	CGD      	Candida albicans (SC5314) genome, Assembly 21, A21-s02-m09-r10 (Feb, 2016)	Candida albicans
JCVI_PMFA1_2.0           	172.18.8.72	42813	NCBI     	Penicillium marneffei (ATCC 18224) genome, JCVI-PMFA1-2.0 (Oct, 2008)	Penicillium marneffei;Talaromyces marneffei
JRGv1                    	172.18.8.72	42833	ToMMo    	Human Japanese Reference Genome, JRGv1 (Aug, 2016)	Homo sapiens
decoyJRGv1               	172.18.8.72	42843	ToMMo    	Decoy sequence of the Human Japanese Reference Genome, decoyJRGv1 (Aug, 2016)	Homo sapiens
JRGv2                    	172.18.8.72	42973	ToMMo    	Human Japanese Reference Genome, JRGv2 (Jun, 2017)	Homo sapiens
decoyJRGv2               	172.18.8.72	42983	ToMMo    	Decoy sequence of the Human Japanese Reference Genome, decoyJRGv2 (Jun, 2017)	Homo sapiens
MSMv3                    	172.18.8.72	42853	         	Mouse genome, MSMv3	Mus musculus
JF1v2                    	172.18.8.72	42863	         	Mouse genome, JF1v2	Mus musculus
YOKOZUNA-1               	172.18.8.72	42873	         	Ramazzottius variornatus (YOKOZUNA-1) genome (Sep, 2016)	Ramazzottius variornatus;tardigrade;water bear
ASM15095v2               	172.18.8.72	42883	EnsemblProtists	Phaeodactylum tricornutum genome, ASM15095v2 (Feb, 2010)	Phaeodactylum tricornutum;diatom
ASM14940v2               	172.18.8.72	42893	EnsemblProtists	Thalassiosira pseudonana genome, ASM14940v2 (May, 2014)	Thalassiosira pseudonana;diatom
asagao                   	172.18.8.72	42903	         	Ipomoea nil (Tokyo Kokei Standard; TKS) genome (Sep, 2016)	Ipomoea nil;Pharbitis nil;japanese morning glory
malus_x_domestica_v1.0p  	172.18.8.72	42913	         	Malus domestica genome, v1.0p (Aug, 2012)	Malus domestica;apple
fragaria_vesca_v2.0.a1   	172.18.8.72	42923	         	Fragaria vesca genome, v2.0.a1 (Dec, 2014)	Fragaria vesca;strawberry
Brapa_v1.5               	172.18.8.72	42933	         	Brassica rapa genome, v1.5 (May, 2013)	Brassica rapa ssp. pekinensis;chinese cabbage
Bomo_silkbase            	172.18.8.72	42943	SilkBase 	Silkworm genome, SilkBase assembly (Jan, 2017)	Bombyx mori
SL2.4                    	172.18.8.72	42053	         	Solanum lycopersicum genome, SL2.40 (Jan, 2011)	Solanum lycopersicum;tomato
SL3.0                    	172.18.8.72	42063	         	Solanum lycopersicum genome, SL3.00 (Feb, 2017)	Solanum lycopersicum;tomato
ChineseLong_v2           	172.18.8.72	42073	         	Cucumis sativus (Chinese long) genome, v2	Cucumis sativus;cucumber
PI183967                 	172.18.8.72	42083	         	Cucumis sativus (PI183967) genome (Apr, 2013)	Cucumis sativus;cucumber
CM3.5.1                  	172.18.8.72	42093	         	Cucumis melo genome, v3.5.1 (Oct, 2013)	Cucumis melo;melon
A_oryzae_RIB40           	172.18.8.72	42993	AspGD    	Aspergillus oryzae (RIB40) genome, s01-m09-r03 (Oct, 2015)	Aspergillus oryzae;koji
A_chinensis_Hongyang     	172.18.8.72	43003	         	Actinidia chinensis genome	Actinidia chinensis;golden kiwi;Kiwifruit
ASM24337v1               	172.18.8.72	43033	EnsemblFungi	Torulaspora delbrueckii genome, ASM24337v1 (Feb, 2015)	Torulaspora delbrueckii;yeast
Aros_1.0                 	172.18.8.72	43063	NCBI     	Athalia rosae genome, Aros_1.0 (Mar, 2013)	Athalia rosae;turnip sawfly;coleseed sawfly
Mpolymorpha_3.1          	172.18.8.72	43583	         	Marchantia polymorpha genome JGI 3.1	Marchantia polymorpha;liverwort
16SrRNA                  	172.18.8.77	50053	         	DDBJ 16S rRNA of prokaryotes (Dec, 2014)	
Ppatens_251_v3           	172.18.8.74	42013	Phytozome	Physcomitrella patens genome, v3.0 (Oct, 2007)	Physcomitrella patens;moss
Smoellendorffii_91_v1    	172.18.8.74	42023	Phytozome	Selaginella moellendorffii genome, v1.0 (Dec, 2007)	Selaginella moellendorffii;spikemoss
Creinhardtii_281_v5_5    	172.18.8.74	42033	Phytozome	Chlamydomonas reinhardtii genome, v5.5 (May, 2014)	Chlamydomonas reinhardtii;green algae
Olucimarinus_231_v2      	172.18.8.74	42043	Phytozome	Ostreococcus lucimarinus genome, v2.0 (Jan, 2011)	Ostreococcus lucimarinus;o. lucimarinus
Cgrandiflora_v1          	172.18.8.74	47043	Phytozome	Capsella grandiflora genome, v1.1	Capsella grandiflora;c. grandiflora
Crubella_v1              	172.18.8.74	47053	Phytozome	Capsella rubella genome, v1.0	Capsella rubella;red shepherd's purse
Cpapaya_r.Dec2008        	172.18.8.74	47063	Phytozome	Carica papaya genome, ASGPBv0.4	Carica papaya;papaya
Cclementina_v1           	172.18.8.74	47083	Phytozome	Citrus clementina genome, v1.0	Citrus clementina;clementine
Csinensis_v1             	172.18.8.74	47093	Phytozome	Citrus sinensis genome, v1.1	Citrus sinensis;sweet orange
CsubellipsoideaC169_v2.0 	172.18.8.74	47103	Phytozome	Coccomyxa subellipsoidea C-169 genome, v2.0	Coccomyxa subellipsoidea;c. subellipsoidea
Csativus_v1              	172.18.8.74	47113	Phytozome	Cucumis sativus genome, v1.0	Cucumis sativus;cucumber
Dcarota_v2.0             	172.18.8.72	43613	Phytozome	Daucus carota genome, v2.0	Daucus carota;carrot
Egrandis_v2.0            	172.18.8.74	47123	Phytozome	Eucalyptus grandis genome, v2.0	Eucalyptus grandis;eucalyptus
Fvesca_v1.1              	172.18.8.74	47143	Phytozome	Fragaria vesca genome, v1.1	Fragaria vesca;strawberry
Graimondii_v2.0          	172.18.8.74	47153	Phytozome	Gossypium raimondii genome, v2.1	Gossypium raimondii;cotton
Lusitatissimum_BGIv1.0   	172.18.8.74	47173	Phytozome	Linum usitatissimum genome, v1.0	Linum usitatissimum;flax
Mdomestica_v1.0          	172.18.8.74	47183	Phytozome	Malus domestica genome, v1.0	Malus domestica;apple
Mesculenta_v6            	172.18.8.74	47193	Phytozome	Manihot esculenta genome, v6.1	Manihot esculenta;cassava
MpusillaCCMP1545_v3.0    	172.18.8.74	47203	Phytozome	Micromonas pusilla CCMP1545 genome, v3.0	Micromonas pusilla;picoplanktonic green alga
MpusillaRCC299_v3.0      	172.18.8.74	47213	Phytozome	Micromonas sp. RCC299 genome, v3.0	Micromonas pusilla;picoplanktonic green alga
Mguttatus_v2.0           	172.18.8.74	47223	Phytozome	Mimulus guttatus genome, v2.0	Mimulus guttatus;monkey flower
Ppersica_v2.0            	172.18.8.74	47293	Phytozome	Prunus persica genome, v2.1	Prunus persica;peach
Rcommunis_TIGR.0.1       	172.18.8.74	47303	Phytozome	Ricinus communis genome, v0.1	Ricinus communis;castor bean
Spolyrhiza_v1            	172.18.8.74	47333	Phytozome	Spirodela polyrhiza genome, v2	Spirodela polyrhiza;giant duckweed
Vcarteri_v2              	172.18.8.74	47343	Phytozome	Volvox carteri genome, v2.0	Volvox carteri;green alga
Ptrichocarpa_v3.0        	172.18.8.74	47353	Phytozome	Populus trichocarpa genome, v3.0	Populus trichocarpa;western balsam poplar
GCA_000009725.1          	172.18.8.72	53813	CyanoBase	Synechocystis sp. PCC 6803 genome, GCA_000009725.1	
GCA_000009705.1          	172.18.8.72	53853	CyanoBase	Nostoc sp. PCC 7120 genome, GCA_000009705.1	
GCA_000011345.1          	172.18.8.72	57913	CyanoBase	Thermosynechococcus elongatus BP-1 genome, GCA_000011345.1	
GCA_000010625.1          	172.18.8.72	52913	CyanoBase	Microcystis aeruginosa NIES-843 genome, GCA_000010625.1	
GCA_000011385.1          	172.18.8.72	51523	CyanoBase	Gloeobacter violaceus PCC 7421 genome, GCA_000011385.1	
GCA_000006985.1          	172.18.8.72	58703	CyanoBase	Chlorobium tepidum TLS genome, GCA_000006985.1	
GCA_000007925.1          	172.18.8.72	52833	CyanoBase	Prochlorococcus marinus subsp. marinus str. CCMP1375 genome, GCA_000007925.1	
GCA_000010065.1          	172.18.8.72	51773	CyanoBase	Synechococcus elongatus PCC 6301 genome, GCA_000010065.1	
GCA_000011465.1          	172.18.8.72	54893	CyanoBase	Prochlorococcus marinus subsp. pastoris str. CCMP1986 genome, GCA_000011465.1	
GCA_000011485.1          	172.18.8.72	56603	CyanoBase	Prochlorococcus marinus str. MIT 9313 genome, GCA_000011485.1	
GCA_000012465.1          	172.18.8.72	53913	CyanoBase	Prochlorococcus marinus str. NATL2A genome, GCA_000012465.1	
GCA_000012505.1          	172.18.8.72	55953	CyanoBase	Synechococcus sp. CC9902 genome, GCA_000012505.1	
GCA_000012525.1          	172.18.8.72	54973	CyanoBase	Synechococcus elongatus PCC 7942 genome, GCA_000012525.1	
GCA_000012625.1          	172.18.8.72	53903	CyanoBase	Synechococcus sp. CC9605 genome, GCA_000012625.1	
GCA_000012645.1          	172.18.8.72	54533	CyanoBase	Prochlorococcus marinus str. MIT 9312 genome, GCA_000012645.1	
GCA_000013205.1          	172.18.8.72	51913	CyanoBase	Synechococcus sp. JA-3-3Ab genome, GCA_000013205.1	
GCA_000013225.1          	172.18.8.72	51883	CyanoBase	Cyanobacteria bacterium Yellowstone B-Prime genome, GCA_000013225.1	
GCA_000014265.1          	172.18.8.72	52963	CyanoBase	Trichodesmium erythraeum IMS101 genome, GCA_000014265.1	
GCA_000014585.1          	172.18.8.72	54613	CyanoBase	Synechococcus sp. CC9311 genome, GCA_000014585.1	
GCA_000015645.1          	172.18.8.72	52543	CyanoBase	Prochlorococcus marinus str. AS9601 genome, GCA_000015645.1	
GCA_000015665.1          	172.18.8.72	56833	CyanoBase	Prochlorococcus marinus str. MIT 9515 genome, GCA_000015665.1	
GCA_000015685.1          	172.18.8.72	54773	CyanoBase	Prochlorococcus marinus str. NATL1A genome, GCA_000015685.1	
GCA_000015705.1          	172.18.8.72	55543	CyanoBase	Prochlorococcus marinus str. MIT 9303 genome, GCA_000015705.1	
GCA_000015965.1          	172.18.8.72	55513	CyanoBase	Prochlorococcus marinus str. MIT 9301 genome, GCA_000015965.1	
GCA_000017845.1          	172.18.8.72	57623	CyanoBase	Cyanothece sp. ATCC 51142 genome, GCA_000017845.1	
GCA_000018065.1          	172.18.8.72	52723	CyanoBase	Prochlorococcus marinus str. MIT 9215 genome, GCA_000018065.1	
GCA_000018105.1          	172.18.8.72	56573	CyanoBase	Acaryochloris marina MBIC11017 genome, GCA_000018105.1	
GCA_000018585.1          	172.18.8.72	51603	CyanoBase	Prochlorococcus marinus str. MIT 9211 genome, GCA_000018585.1	
GCA_000019485.1          	172.18.8.72	57703	CyanoBase	Synechococcus sp. PCC 7002 genome, GCA_000019485.1	
GCA_000020025.1          	172.18.8.72	55523	CyanoBase	Nostoc punctiforme PCC 73102 genome, GCA_000020025.1	
GCA_000021805.1          	172.18.8.72	56963	CyanoBase	Cyanothece sp. PCC 8801 genome, GCA_000021805.1	
GCA_000021825.1          	172.18.8.72	57643	CyanoBase	Cyanothece sp. PCC 7424 genome, GCA_000021825.1	
GCA_000022045.1          	172.18.8.72	57713	CyanoBase	Cyanothece sp. PCC 7425 genome, GCA_000022045.1	
GCA_000024045.1          	172.18.8.72	56943	CyanoBase	Cyanothece sp. PCC 8802 genome, GCA_000024045.1	
GCA_000025125.1          	172.18.8.72	55763	CyanoBase	Candidatus Atelocyanobacterium thalassa isolate ALOHA genome, GCA_000025125.1	
GCA_000063505.1          	172.18.8.72	52703	CyanoBase	Synechococcus sp. WH 7803 genome, GCA_000063505.1	
GCA_000063525.1          	172.18.8.72	55733	CyanoBase	Synechococcus sp. RCC307 genome, GCA_000063525.1	
GCA_000147335.1          	172.18.8.72	56653	CyanoBase	Cyanothece sp. PCC 7822 genome, GCA_000147335.1	
GCA_000153045.1          	172.18.8.72	56813	CyanoBase	Synechococcus sp. WH 5701 genome, GCA_000153045.1	
GCA_000153065.1          	172.18.8.72	56703	CyanoBase	Synechococcus sp. RS9917 genome, GCA_000153065.1	
GCA_000153285.1          	172.18.8.72	54633	CyanoBase	Synechococcus sp. WH 7805 genome, GCA_000153285.1	
GCA_000153805.1          	172.18.8.72	55993	CyanoBase	Synechococcus sp. BL107 genome, GCA_000153805.1	
GCA_000153825.1          	172.18.8.72	55673	CyanoBase	Synechococcus sp. RS9916 genome, GCA_000153825.1	
GCA_000155555.1          	172.18.8.72	53553	CyanoBase	Coleofasciculus chthonoplastes PCC 7420 genome, GCA_000155555.1	
GCA_000155595.1          	172.18.8.72	52593	CyanoBase	Synechococcus sp. PCC 7335 genome, GCA_000155595.1	
GCA_000155635.1          	172.18.8.72	57733	CyanoBase	Cyanobium sp. PCC 7001 genome, GCA_000155635.1	
GCA_000158595.1          	172.18.8.72	55623	CyanoBase	Prochlorococcus marinus str. MIT 9202 genome, GCA_000158595.1	
GCA_000161795.2          	172.18.8.72	53923	CyanoBase	Synechococcus sp. WH 8109 genome, GCA_000161795.2	
GCA_000167195.1          	172.18.8.72	58543	CyanoBase	Crocosphaera watsonii WH 8501 genome, GCA_000167195.1	
GCA_000169095.1          	172.18.8.72	53693	CyanoBase	Lyngbya sp. PCC 8106 genome, GCA_000169095.1	
GCA_000169135.1          	172.18.8.72	56883	CyanoBase	Nodularia spumigena CCY9414 genome, GCA_000169135.1	
GCA_000169335.1          	172.18.8.72	58633	CyanoBase	Cyanothece sp. CCY0110 genome, GCA_000169335.1	
GCA_000173555.1          	172.18.8.72	55563	CyanoBase	Arthrospira maxima CS-328 genome, GCA_000173555.1	
GCA_000175415.3          	172.18.8.72	55713	CyanoBase	Arthrospira platensis str. Paraca genome, GCA_000175415.3	
GCA_000175835.1          	172.18.8.72	56953	CyanoBase	Cylindrospermopsis raciborskii CS-505 genome, GCA_000175835.1	
GCA_000175855.1          	172.18.8.72	53723	CyanoBase	Raphidiopsis brookii D9 genome, GCA_000175855.1	
GCA_000176895.2          	172.18.8.72	58663	CyanoBase	Arthrospira sp. PCC 8005 genome, GCA_000176895.2	
GCA_000179235.1          	172.18.8.72	54513	CyanoBase	Synechococcus sp. CB0101 genome, GCA_000179235.1	
GCA_000179255.1          	172.18.8.72	52873	CyanoBase	Synechococcus sp. CB0205 genome, GCA_000179255.1	
GCA_000180455.1          	172.18.8.72	53523	CyanoBase	Oscillatoria sp. PCC 6506 genome, GCA_000180455.1	
GCA_000195775.1          	172.18.8.72	58713	CyanoBase	Rhodopseudomonas palustris CGA009 genome, GCA_000195775.1	
GCA_000195975.1          	172.18.8.72	56563	CyanoBase	Synechococcus sp. WH 8102 genome, GCA_000195975.1	
GCA_000196515.1          	172.18.8.72	57583	CyanoBase	Nostoc azollae 0708 genome, GCA_000196515.1	
GCA_000204075.1          	172.18.8.72	56643	CyanoBase	Anabaena variabilis ATCC 29413 genome, GCA_000204075.1	
GCA_000210375.1          	172.18.8.72	54643	CyanoBase	Arthrospira platensis NIES-39 genome, GCA_000210375.1	
GCA_000211815.1          	172.18.8.72	52583	CyanoBase	Moorea producens 3L genome, GCA_000211815.1	
GCA_000214075.2          	172.18.8.72	57993	CyanoBase	Microcoleus vaginatus FGP-2 genome, GCA_000214075.2	
GCA_000218705.1          	172.18.8.72	51573	CyanoBase	Prochlorococcus marinus bv. HNLC1 genome, GCA_000218705.1	
GCA_000218745.1          	172.18.8.72	56873	CyanoBase	Prochlorococcus marinus bv. HNLC2 genome, GCA_000218745.1	
GCA_000230675.2          	172.18.8.72	57613	CyanoBase	Synechococcus sp. WH 8016 genome, GCA_000230675.2	
GCA_000231365.2          	172.18.8.72	53733	CyanoBase	Fischerella sp. JSC-11 genome, GCA_000231365.2	
GCA_000231425.3          	172.18.8.72	54983	CyanoBase	Cyanothece sp. ATCC 51472 genome, GCA_000231425.3	
GCA_000235665.2          	172.18.8.72	51973	CyanoBase	Crocosphaera watsonii WH 0003 genome, GCA_000235665.2	
GCA_000238775.2          	172.18.8.72	54673	CyanoBase	Acaryochloris sp. CCMEE 5410 genome, GCA_000238775.2	
GCA_000252425.1          	172.18.8.72	58593	CyanoBase	Prochloron didemni P2-Fiji genome, GCA_000252425.1	
GCA_000252465.1          	172.18.8.72	56593	CyanoBase	Prochloron didemni P3-Solomon genome, GCA_000252465.1	
GCA_000252485.1          	172.18.8.72	52853	CyanoBase	Prochloron didemni P4-Papua_New_Guinea genome, GCA_000252485.1	
GCA_000270265.1          	172.18.8.72	57653	CyanoBase	Synechocystis sp. PCC 6803 genome, GCA_000270265.1	
GCA_000284135.1          	172.18.8.72	56733	CyanoBase	Synechocystis sp. PCC 6803 substr. GT-I genome, GCA_000284135.1	
GCA_000284215.1          	172.18.8.72	55603	CyanoBase	Synechocystis sp. PCC 6803 substr. PCC-N genome, GCA_000284215.1	
GCA_000284455.1          	172.18.8.72	53543	CyanoBase	Synechocystis sp. PCC 6803 substr. PCC-P genome, GCA_000284455.1	
GCA_000291785.1          	172.18.8.72	52803	CyanoBase	Prochlorococcus sp. W4 genome, GCA_000291785.1	
GCA_000291805.1          	172.18.8.72	58673	CyanoBase	Prochlorococcus sp. W7 genome, GCA_000291805.1	
GCA_000291825.1          	172.18.8.72	55823	CyanoBase	Prochlorococcus sp. W8 genome, GCA_000291825.1	
GCA_000291845.1          	172.18.8.72	57503	CyanoBase	Prochlorococcus sp. W10 genome, GCA_000291845.1	
GCA_000291865.1          	172.18.8.72	56853	CyanoBase	Prochlorococcus sp. W6 genome, GCA_000291865.1	
GCA_000291885.1          	172.18.8.72	56863	CyanoBase	Prochlorococcus sp. W2 genome, GCA_000291885.1	
GCA_000291905.1          	172.18.8.72	51843	CyanoBase	Prochlorococcus sp. W3 genome, GCA_000291905.1	
GCA_000291925.1          	172.18.8.72	51993	CyanoBase	Prochlorococcus sp. W9 genome, GCA_000291925.1	
GCA_000291945.1          	172.18.8.72	55583	CyanoBase	Prochlorococcus sp. W11 genome, GCA_000291945.1	
GCA_000291965.1          	172.18.8.72	55573	CyanoBase	Prochlorococcus sp. W12 genome, GCA_000291965.1	
GCA_000291985.1          	172.18.8.72	57773	CyanoBase	Prochlorococcus sp. W5 genome, GCA_000291985.1	
GCA_000297435.1          	172.18.8.72	55783	CyanoBase	Microcystis sp. T1-4 genome, GCA_000297435.1	
GCA_000300115.1          	172.18.8.72	53993	CyanoBase	Tolypothrix sp. PCC 7601 genome, GCA_000300115.1	
GCA_000307915.1          	172.18.8.72	51753	CyanoBase	Arthrospira platensis C1 genome, GCA_000307915.1	
GCA_000307995.2          	172.18.8.72	54763	CyanoBase	Microcystis aeruginosa PCC 9432 genome, GCA_000307995.2	
GCA_000309385.1          	172.18.8.72	52823	CyanoBase	Nodosilinea nodulosa PCC 7104 genome, GCA_000309385.1	
GCA_000309945.1          	172.18.8.72	53973	CyanoBase	Oscillatoriales cyanobacterium JSC-12 genome, GCA_000309945.1	
GCA_000312165.1          	172.18.8.72	51893	CyanoBase	Microcystis aeruginosa PCC 9717 genome, GCA_000312165.1	
GCA_000312185.1          	172.18.8.72	52563	CyanoBase	Microcystis aeruginosa PCC 9443 genome, GCA_000312185.1	
GCA_000312205.1          	172.18.8.72	56843	CyanoBase	Microcystis aeruginosa PCC 7941 genome, GCA_000312205.1	
GCA_000312225.1          	172.18.8.72	52863	CyanoBase	Microcystis aeruginosa PCC 9807 genome, GCA_000312225.1	
GCA_000312245.1          	172.18.8.72	54573	CyanoBase	Microcystis aeruginosa PCC 9808 genome, GCA_000312245.1	
GCA_000312265.1          	172.18.8.72	55663	CyanoBase	Microcystis aeruginosa PCC 9809 genome, GCA_000312265.1	
GCA_000312285.1          	172.18.8.72	53583	CyanoBase	Microcystis aeruginosa PCC 9701 genome, GCA_000312285.1	
GCA_000312705.1          	172.18.8.72	55723	CyanoBase	Anabaena sp. 90 genome, GCA_000312705.1	
GCA_000312725.1          	172.18.8.72	53603	CyanoBase	Microcystis aeruginosa PCC 9806 genome, GCA_000312725.1	
GCA_000314005.1          	172.18.8.72	57963	CyanoBase	Spirulina subsalsa PCC 9445 genome, GCA_000314005.1	
GCA_000315565.1          	172.18.8.72	54953	CyanoBase	Mastigocladopsis repens PCC 10914 genome, GCA_000315565.1	
GCA_000315585.1          	172.18.8.72	56923	CyanoBase	Fischerella sp. PCC 9339 genome, GCA_000315585.1	
GCA_000316115.1          	172.18.8.72	58583	CyanoBase	Leptolyngbya sp. PCC 7375 genome, GCA_000316115.1	
GCA_000316515.1          	172.18.8.72	53823	CyanoBase	Cyanobium gracile PCC 6307 genome, GCA_000316515.1	
GCA_000316575.1          	172.18.8.72	55553	CyanoBase	Calothrix sp. PCC 7507 genome, GCA_000316575.1	
GCA_000316605.1          	172.18.8.72	58603	CyanoBase	Leptolyngbya sp. PCC 7376 genome, GCA_000316605.1	
GCA_000316625.1          	172.18.8.72	52653	CyanoBase	Nostoc sp. PCC 7107 genome, GCA_000316625.1	
GCA_000316645.1          	172.18.8.72	56683	CyanoBase	Nostoc sp. PCC 7524 genome, GCA_000316645.1	
GCA_000316665.1          	172.18.8.72	57603	CyanoBase	Rivularia sp. PCC 7116 genome, GCA_000316665.1	
GCA_000316685.1          	172.18.8.72	52503	CyanoBase	Synechococcus sp. PCC 6312 genome, GCA_000316685.1	
GCA_000317025.1          	172.18.8.72	51623	CyanoBase	Pleurocapsa sp. PCC 7327 genome, GCA_000317025.1	
GCA_000317045.1          	172.18.8.72	56933	CyanoBase	Geitlerinema sp. PCC 7407 genome, GCA_000317045.1	
GCA_000317065.1          	172.18.8.72	58743	CyanoBase	Pseudanabaena sp. PCC 7367 genome, GCA_000317065.1	
GCA_000317085.1          	172.18.8.72	55813	CyanoBase	Synechococcus sp. PCC 7502 genome, GCA_000317085.1	
GCA_000317105.1          	172.18.8.72	52893	CyanoBase	Oscillatoria acuminata PCC 6304 genome, GCA_000317105.1	
GCA_000317125.1          	172.18.8.72	55693	CyanoBase	Chroococcidiopsis thermalis PCC 7203 genome, GCA_000317125.1	
GCA_000317145.1          	172.18.8.72	57683	CyanoBase	Chamaesiphon minutus PCC 6605 genome, GCA_000317145.1	
GCA_000317205.1          	172.18.8.72	52663	CyanoBase	Fischerella muscicola PCC 7414 genome, GCA_000317205.1	
GCA_000317225.1          	172.18.8.72	55843	CyanoBase	Fischerella thermalis PCC 7521 genome, GCA_000317225.1	
GCA_000317245.1          	172.18.8.72	52743	CyanoBase	Fischerella muscicola SAG 1427-1 genome, GCA_000317245.1	
GCA_000317265.1          	172.18.8.72	51943	CyanoBase	Chlorogloeopsis fritschii PCC 9212 genome, GCA_000317265.1	
GCA_000317285.1          	172.18.8.72	54563	CyanoBase	Chlorogloeopsis fritschii PCC 6912 genome, GCA_000317285.1	
GCA_000317435.1          	172.18.8.72	56803	CyanoBase	Calothrix sp. PCC 6303 genome, GCA_000317435.1	
GCA_000317475.1          	172.18.8.72	56553	CyanoBase	Oscillatoria nigro-viridis PCC 7112 genome, GCA_000317475.1	
GCA_000317495.1          	172.18.8.72	51743	CyanoBase	Crinalium epipsammum PCC 9333 genome, GCA_000317495.1	
GCA_000317515.1          	172.18.8.72	55893	CyanoBase	Microcoleus sp. PCC 7113 genome, GCA_000317515.1	
GCA_000317535.1          	172.18.8.72	53533	CyanoBase	Cylindrospermum stagnale PCC 7417 genome, GCA_000317535.1	
GCA_000317555.1          	172.18.8.72	56513	CyanoBase	Gloeocapsa sp. PCC 7428 genome, GCA_000317555.1	
GCA_000317575.1          	172.18.8.72	57803	CyanoBase	Stanieria cyanosphaera PCC 7437 genome, GCA_000317575.1	
GCA_000317615.1          	172.18.8.72	55643	CyanoBase	Dactylococcopsis salina PCC 8305 genome, GCA_000317615.1	
GCA_000317635.1          	172.18.8.72	51513	CyanoBase	Halothece sp. PCC 7418 genome, GCA_000317635.1	
GCA_000317655.1          	172.18.8.72	56623	CyanoBase	Cyanobacterium stanieri PCC 7202 genome, GCA_000317655.1	
GCA_000317675.1          	172.18.8.72	52883	CyanoBase	Cyanobacterium aponinum PCC 10605 genome, GCA_000317675.1	
GCA_000317695.1          	172.18.8.72	57793	CyanoBase	Anabaena cylindrica PCC 7122 genome, GCA_000317695.1	
GCA_000330925.1          	172.18.8.72	51763	CyanoBase	Microcystis aeruginosa TAIHU98 genome, GCA_000330925.1	
GCA_000331305.1          	172.18.8.72	58513	CyanoBase	Calothrix sp. PCC 7103 genome, GCA_000331305.1	
GCA_000332035.1          	172.18.8.72	57743	CyanoBase	Gloeocapsa sp. PCC 73106 genome, GCA_000332035.1	
GCA_000332055.1          	172.18.8.72	56723	CyanoBase	Xenococcus sp. PCC 7305 genome, GCA_000332055.1	
GCA_000332075.2          	172.18.8.72	57663	CyanoBase	Synechocystis sp. PCC 7509 genome, GCA_000332075.2	
GCA_000332095.2          	172.18.8.72	53503	CyanoBase	Leptolyngbya sp. PCC 6406 genome, GCA_000332095.2	
GCA_000332135.1          	172.18.8.72	54553	CyanoBase	Anabaena sp. PCC 7108 genome, GCA_000332135.1	
GCA_000332155.1          	172.18.8.72	58533	CyanoBase	Kamptonema formosum PCC 6407 genome, GCA_000332155.1	
GCA_000332175.1          	172.18.8.72	57563	CyanoBase	Pseudanabaena sp. PCC 6802 genome, GCA_000332175.1	
GCA_000332195.1          	172.18.8.72	57903	CyanoBase	Pleurocapsa sp. PCC 7319 genome, GCA_000332195.1	
GCA_000332215.1          	172.18.8.72	52733	CyanoBase	Pseudanabaena biceps PCC 7429 genome, GCA_000332215.1	
GCA_000332235.1          	172.18.8.72	51853	CyanoBase	Geminocystis herdmanii PCC 6308 genome, GCA_000332235.1	
GCA_000332255.1          	172.18.8.72	53983	CyanoBase	cyanobacterium PCC 7702 genome, GCA_000332255.1	
GCA_000332275.1          	172.18.8.72	51593	CyanoBase	Synechococcus sp. PCC 7336 genome, GCA_000332275.1	
GCA_000332295.1          	172.18.8.72	53673	CyanoBase	Microchaete sp. PCC 7126 genome, GCA_000332295.1	
GCA_000332315.1          	172.18.8.72	57923	CyanoBase	Prochlorothrix hollandica PCC 9006 genome, GCA_000332315.1	
GCA_000332335.1          	172.18.8.72	57983	CyanoBase	Oscillatoria sp. PCC 10802 genome, GCA_000332335.1	
GCA_000332355.1          	172.18.8.72	56753	CyanoBase	Geitlerinema sp. PCC 7105 genome, GCA_000332355.1	
GCA_000332585.1          	172.18.8.72	55683	CyanoBase	Microcystis aeruginosa DIANCHI905 genome, GCA_000332585.1	
GCA_000340565.3          	172.18.8.72	54683	CyanoBase	Nodularia spumigena CCY9414 genome, GCA_000340565.3	
GCA_000340785.1          	172.18.8.72	55653	CyanoBase	Synechocystis sp. PCC 6803 genome, GCA_000340785.1	
GCA_000341585.2          	172.18.8.72	56743	CyanoBase	Prochlorothrix hollandica PCC 9006 genome, GCA_000341585.2	
GCA_000346485.1          	172.18.8.72	51503	CyanoBase	Scytonema hofmanni PCC 7110 genome, GCA_000346485.1	
GCA_000350105.1          	172.18.8.72	56903	CyanoBase	Richelia intracellularis HH01 genome, GCA_000350105.1	
GCA_000350125.1          	172.18.8.72	52693	CyanoBase	Richelia intracellularis HM01 genome, GCA_000350125.1	
GCA_000353285.1          	172.18.8.72	54543	CyanoBase	Leptolyngbya boryana PCC 6306 genome, GCA_000353285.1	
GCA_000380225.1          	172.18.8.72	57933	CyanoBase	filamentous cyanobacterium ESFC-1 genome, GCA_000380225.1	
GCA_000412595.1          	172.18.8.72	54693	CyanoBase	Microcystis aeruginosa SPC777 genome, GCA_000412595.1	
GCA_000426905.1          	172.18.8.72	52553	CyanoBase	Dolichospermum circinale AWQC131C genome, GCA_000426905.1	
GCA_000426925.1          	172.18.8.72	53963	CyanoBase	Dolichospermum circinale AWQC310F genome, GCA_000426925.1	
GCA_000447295.1          	172.18.8.72	57893	CyanoBase	Fischerella sp. PCC 9431 genome, GCA_000447295.1	
GCA_000464665.1          	172.18.8.72	57953	CyanoBase	Planktothrix agardhii NIVA-CYA 15 genome, GCA_000464665.1	
GCA_000464725.1          	172.18.8.72	54883	CyanoBase	Planktothrix agardhii NIVA-CYA 34 genome, GCA_000464725.1	
GCA_000464745.1          	172.18.8.72	53803	CyanoBase	Planktothrix mougeotii NIVA-CYA 405 genome, GCA_000464745.1	
GCA_000464765.1          	172.18.8.72	55883	CyanoBase	Planktothrix prolifica NIVA-CYA 406 genome, GCA_000464765.1	
GCA_000464785.1          	172.18.8.72	54743	CyanoBase	Planktothrix rubescens NIVA-CYA 407 genome, GCA_000464785.1	
GCA_000464805.1          	172.18.8.72	55963	CyanoBase	Planktothrix prolifica NIVA-CYA 540 genome, GCA_000464805.1	
GCA_000464825.1          	172.18.8.72	56973	CyanoBase	Planktothrix agardhii NIVA-CYA 56/3 genome, GCA_000464825.1	
GCA_000464845.1          	172.18.8.72	51563	CyanoBase	Planktothrix prolifica NIVA-CYA 98 genome, GCA_000464845.1	
GCA_000472885.1          	172.18.8.72	53663	CyanoBase	Mastigocoleus testarum BC008 genome, GCA_000472885.1	
GCA_000473895.1          	172.18.8.72	58503	CyanoBase	Rubidibacter lacunae KORDI 51-2 genome, GCA_000473895.1	
GCA_000478195.2          	172.18.8.72	53653	CyanoBase	Lyngbya aestuarii BL J genome, GCA_000478195.2	
GCA_000478825.2          	172.18.8.72	55873	CyanoBase	Synechocystis sp. PCC 6714 genome, GCA_000478825.2	
GCA_000482245.1          	172.18.8.72	56543	CyanoBase	Leptolyngbya sp. Heron Island J genome, GCA_000482245.1	
GCA_000484535.1          	172.18.8.72	56823	CyanoBase	Gloeobacter kilaueensis JS1 genome, GCA_000484535.1	
GCA_000485815.1          	172.18.8.72	52633	CyanoBase	Synechococcus sp. NKBG15041c genome, GCA_000485815.1	
GCA_000505665.1          	172.18.8.72	51933	CyanoBase	Thermosynechococcus sp. NK55a genome, GCA_000505665.1	
GCA_000515235.1          	172.18.8.72	55903	CyanoBase	Synechococcus sp. CC9616 genome, GCA_000515235.1	
GCA_000517105.1          	172.18.8.72	58553	CyanoBase	Fischerella sp. PCC 9605 genome, GCA_000517105.1	
GCA_000521175.1          	172.18.8.72	58733	CyanoBase	Aphanizomenon flos-aquae NIES-81 genome, GCA_000521175.1	
GCA_000582685.1          	172.18.8.72	51833	CyanoBase	Scytonema hofmanni UTEX 2349 genome, GCA_000582685.1	
GCA_000586015.1          	172.18.8.72	51693	CyanoBase	Candidatus Synechococcus spongiarum SH4 genome, GCA_000586015.1	
GCA_000599945.1          	172.18.8.72	51553	CyanoBase	Microcystis aeruginosa PCC 7005 genome, GCA_000599945.1	
GCA_000613065.1          	172.18.8.72	55533	CyanoBase	Richelia intracellularis genome, GCA_000613065.1	
GCA_000633975.1          	172.18.8.72	53943	CyanoBase	Prochlorococcus sp. scB241_526B17 genome, GCA_000633975.1	
GCA_000633995.1          	172.18.8.72	52533	CyanoBase	Prochlorococcus sp. scB241_526K3 genome, GCA_000633995.1	
GCA_000634015.1          	172.18.8.72	54923	CyanoBase	Prochlorococcus sp. scB241_526N9 genome, GCA_000634015.1	
GCA_000634035.1          	172.18.8.72	53613	CyanoBase	Prochlorococcus sp. scB241_527E14 genome, GCA_000634035.1	
GCA_000634055.1          	172.18.8.72	54523	CyanoBase	Prochlorococcus sp. scB241_527N11 genome, GCA_000634055.1	
GCA_000634075.1          	172.18.8.72	53593	CyanoBase	Prochlorococcus sp. scB241_528J14 genome, GCA_000634075.1	
GCA_000634095.1          	172.18.8.72	57553	CyanoBase	Prochlorococcus sp. scB241_528J8 genome, GCA_000634095.1	
GCA_000634115.1          	172.18.8.72	54663	CyanoBase	Prochlorococcus sp. scB241_528O2 genome, GCA_000634115.1	
GCA_000634135.1          	172.18.8.72	51783	CyanoBase	Prochlorococcus sp. scB241_528P14 genome, GCA_000634135.1	
GCA_000634155.1          	172.18.8.72	52613	CyanoBase	Prochlorococcus sp. scB241_529C4 genome, GCA_000634155.1	
GCA_000634175.1          	172.18.8.72	54733	CyanoBase	Prochlorococcus sp. scB241_529D18 genome, GCA_000634175.1	
GCA_000634195.1          	172.18.8.72	54653	CyanoBase	Prochlorococcus sp. scB243_495D8 genome, GCA_000634195.1	
GCA_000634215.1          	172.18.8.72	54843	CyanoBase	Prochlorococcus sp. scB243_495L20 genome, GCA_000634215.1	
GCA_000634235.1          	172.18.8.72	52923	CyanoBase	Prochlorococcus sp. scB243_495N16 genome, GCA_000634235.1	
GCA_000634255.1          	172.18.8.72	51813	CyanoBase	Prochlorococcus sp. scB243_496A2 genome, GCA_000634255.1	
GCA_000634275.1          	172.18.8.72	56613	CyanoBase	Prochlorococcus sp. scB243_497J18 genome, GCA_000634275.1	
GCA_000634295.1          	172.18.8.72	54713	CyanoBase	Prochlorococcus sp. scB243_498A3 genome, GCA_000634295.1	
GCA_000634315.1          	172.18.8.72	51613	CyanoBase	Prochlorococcus sp. scB243_498J20 genome, GCA_000634315.1	
GCA_000634335.1          	172.18.8.72	55633	CyanoBase	Prochlorococcus sp. scB243_498N4 genome, GCA_000634335.1	
GCA_000634355.1          	172.18.8.72	52573	CyanoBase	Prochlorococcus sp. scB243_498N8 genome, GCA_000634355.1	
GCA_000634375.1          	172.18.8.72	52903	CyanoBase	Prochlorococcus sp. scB245a_518A17 genome, GCA_000634375.1	
GCA_000634395.1          	172.18.8.72	57823	CyanoBase	Prochlorococcus sp. scB245a_518D8 genome, GCA_000634395.1	
GCA_000634415.1          	172.18.8.72	55933	CyanoBase	Prochlorococcus sp. scB245a_519A13 genome, GCA_000634415.1	
GCA_000634435.1          	172.18.8.72	55943	CyanoBase	Prochlorococcus sp. scB245a_519B7 genome, GCA_000634435.1	
GCA_000634455.1          	172.18.8.72	57943	CyanoBase	Prochlorococcus sp. scB245a_519O21 genome, GCA_000634455.1	
GCA_000634475.1          	172.18.8.72	56583	CyanoBase	Prochlorococcus sp. scB245a_520B18 genome, GCA_000634475.1	
GCA_000634495.1          	172.18.8.72	55703	CyanoBase	Prochlorococcus sp. scB245a_520D2 genome, GCA_000634495.1	
GCA_000634515.1          	172.18.8.72	58693	CyanoBase	Prochlorococcus sp. scB245a_520K10 genome, GCA_000634515.1	
GCA_000634535.1          	172.18.8.72	58623	CyanoBase	Prochlorococcus sp. scB245a_520M11 genome, GCA_000634535.1	
GCA_000634555.2          	172.18.8.72	55793	CyanoBase	Prochlorococcus sp. scB245a_521A19 genome, GCA_000634555.2	
GCA_000634575.1          	172.18.8.72	53513	CyanoBase	Prochlorococcus sp. scB245a_521N3 genome, GCA_000634575.1	
GCA_000634595.1          	172.18.8.72	58613	CyanoBase	Prochlorococcus sp. scB245a_521O23 genome, GCA_000634595.1	
GCA_000634615.1          	172.18.8.72	52993	CyanoBase	Prochlorococcus sp. scB241_526B19 genome, GCA_000634615.1	
GCA_000634635.1          	172.18.8.72	53863	CyanoBase	Prochlorococcus sp. scB241_526B22 genome, GCA_000634635.1	
GCA_000634655.1          	172.18.8.72	52793	CyanoBase	Prochlorococcus sp. scB241_526N5 genome, GCA_000634655.1	
GCA_000634675.1          	172.18.8.72	57833	CyanoBase	Prochlorococcus sp. scB241_527E15 genome, GCA_000634675.1	
GCA_000634695.1          	172.18.8.72	58653	CyanoBase	Prochlorococcus sp. scB241_527L15 genome, GCA_000634695.1	
GCA_000634715.1          	172.18.8.72	52933	CyanoBase	Prochlorococcus sp. scB241_528K19 genome, GCA_000634715.1	
GCA_000634735.1          	172.18.8.72	57723	CyanoBase	Prochlorococcus sp. scB241_528N17 genome, GCA_000634735.1	
GCA_000634755.1          	172.18.8.72	53793	CyanoBase	Prochlorococcus sp. scB241_528N20 genome, GCA_000634755.1	
GCA_000634775.1          	172.18.8.72	56673	CyanoBase	Prochlorococcus sp. scB241_528N8 genome, GCA_000634775.1	
GCA_000634795.1          	172.18.8.72	51723	CyanoBase	Prochlorococcus sp. scB241_529J15 genome, GCA_000634795.1	
GCA_000634815.1          	172.18.8.72	58573	CyanoBase	Prochlorococcus sp. scB243_495G23 genome, GCA_000634815.1	
GCA_000634835.1          	172.18.8.72	53623	CyanoBase	Prochlorococcus sp. scB243_495I8 genome, GCA_000634835.1	
GCA_000634855.1          	172.18.8.72	53873	CyanoBase	Prochlorococcus sp. scB243_495N4 genome, GCA_000634855.1	
GCA_000634875.1          	172.18.8.72	51583	CyanoBase	Prochlorococcus sp. scB243_495P20 genome, GCA_000634875.1	
GCA_000634895.1          	172.18.8.72	51733	CyanoBase	Prochlorococcus sp. scB243_496E10 genome, GCA_000634895.1	
GCA_000634915.1          	172.18.8.72	53563	CyanoBase	Prochlorococcus sp. scB243_496G15 genome, GCA_000634915.1	
GCA_000634935.1          	172.18.8.72	54793	CyanoBase	Prochlorococcus sp. scB243_497I20 genome, GCA_000634935.1	
GCA_000634955.1          	172.18.8.72	51953	CyanoBase	Prochlorococcus sp. scB243_497N18 genome, GCA_000634955.1	
GCA_000634975.1          	172.18.8.72	57883	CyanoBase	Prochlorococcus sp. scB243_498B22 genome, GCA_000634975.1	
GCA_000634995.1          	172.18.8.72	58683	CyanoBase	Prochlorococcus sp. scB243_498C16 genome, GCA_000634995.1	
GCA_000635015.1          	172.18.8.72	57763	CyanoBase	Prochlorococcus sp. scB243_498I20 genome, GCA_000635015.1	
GCA_000635035.1          	172.18.8.72	51653	CyanoBase	Prochlorococcus sp. scB243_498L10 genome, GCA_000635035.1	
GCA_000635055.1          	172.18.8.72	55803	CyanoBase	Prochlorococcus sp. scB245a_518A6 genome, GCA_000635055.1	
GCA_000635075.1          	172.18.8.72	51863	CyanoBase	Prochlorococcus sp. scB245a_518E10 genome, GCA_000635075.1	
GCA_000635095.1          	172.18.8.72	53683	CyanoBase	Prochlorococcus sp. scB245a_518J7 genome, GCA_000635095.1	
GCA_000635115.1          	172.18.8.72	53773	CyanoBase	Prochlorococcus sp. scB245a_518K17 genome, GCA_000635115.1	
GCA_000635135.1          	172.18.8.72	51663	CyanoBase	Prochlorococcus sp. scB245a_518O7 genome, GCA_000635135.1	
GCA_000635155.1          	172.18.8.72	52753	CyanoBase	Prochlorococcus sp. scB245a_519C7 genome, GCA_000635155.1	
GCA_000635175.1          	172.18.8.72	55833	CyanoBase	Prochlorococcus sp. scB245a_519E23 genome, GCA_000635175.1	
GCA_000635195.1          	172.18.8.72	56713	CyanoBase	Prochlorococcus sp. scB245a_519L21 genome, GCA_000635195.1	
GCA_000635215.1          	172.18.8.72	51643	CyanoBase	Prochlorococcus sp. scB245a_521C8 genome, GCA_000635215.1	
GCA_000635235.1          	172.18.8.72	57673	CyanoBase	Prochlorococcus sp. scB245a_521K15 genome, GCA_000635235.1	
GCA_000635255.1          	172.18.8.72	51543	CyanoBase	Prochlorococcus sp. scB245a_521O20 genome, GCA_000635255.1	
GCA_000635275.1          	172.18.8.72	57753	CyanoBase	Prochlorococcus sp. scB241_526D20 genome, GCA_000635275.1	
GCA_000635295.1          	172.18.8.72	54813	CyanoBase	Prochlorococcus sp. scB241_527G5 genome, GCA_000635295.1	
GCA_000635315.1          	172.18.8.72	54783	CyanoBase	Prochlorococcus sp. scB241_527I9 genome, GCA_000635315.1	
GCA_000635335.1          	172.18.8.72	56773	CyanoBase	Prochlorococcus sp. scB241_527L16 genome, GCA_000635335.1	
GCA_000635355.1          	172.18.8.72	54873	CyanoBase	Prochlorococcus sp. scB241_527L22 genome, GCA_000635355.1	
GCA_000635375.1          	172.18.8.72	53573	CyanoBase	Prochlorococcus sp. scB241_527P5 genome, GCA_000635375.1	
GCA_000635395.1          	172.18.8.72	57843	CyanoBase	Prochlorococcus sp. scB241_528P18 genome, GCA_000635395.1	
GCA_000635415.1          	172.18.8.72	52623	CyanoBase	Prochlorococcus sp. scB241_529B19 genome, GCA_000635415.1	
GCA_000635435.1          	172.18.8.72	52603	CyanoBase	Prochlorococcus sp. scB241_529J11 genome, GCA_000635435.1	
GCA_000635455.1          	172.18.8.72	54723	CyanoBase	Prochlorococcus sp. scB241_529J16 genome, GCA_000635455.1	
GCA_000635475.1          	172.18.8.72	51983	CyanoBase	Prochlorococcus sp. scB241_529O19 genome, GCA_000635475.1	
GCA_000635495.1          	172.18.8.72	51533	CyanoBase	Prochlorococcus sp. scB243_495K23 genome, GCA_000635495.1	
GCA_000635515.1          	172.18.8.72	53703	CyanoBase	Prochlorococcus sp. scB243_495N3 genome, GCA_000635515.1	
GCA_000635535.1          	172.18.8.72	53783	CyanoBase	Prochlorococcus sp. scB243_496M6 genome, GCA_000635535.1	
GCA_000635555.1          	172.18.8.72	54803	CyanoBase	Prochlorococcus sp. scB243_496N4 genome, GCA_000635555.1	
GCA_000635575.1          	172.18.8.72	55973	CyanoBase	Prochlorococcus sp. scB243_497E17 genome, GCA_000635575.1	
GCA_000635595.1          	172.18.8.72	57813	CyanoBase	Prochlorococcus sp. scB243_498B23 genome, GCA_000635595.1	
GCA_000635615.1          	172.18.8.72	55983	CyanoBase	Prochlorococcus sp. scB243_498F21 genome, GCA_000635615.1	
GCA_000635635.1          	172.18.8.72	56663	CyanoBase	Prochlorococcus sp. scB243_498G3 genome, GCA_000635635.1	
GCA_000635655.1          	172.18.8.72	53933	CyanoBase	Prochlorococcus sp. scB243_498M14 genome, GCA_000635655.1	
GCA_000635675.1          	172.18.8.72	54933	CyanoBase	Prochlorococcus sp. scB243_498P15 genome, GCA_000635675.1	
GCA_000635695.1          	172.18.8.72	53953	CyanoBase	Prochlorococcus sp. scB243_498P3 genome, GCA_000635695.1	
GCA_000635715.1          	172.18.8.72	55863	CyanoBase	Prochlorococcus sp. scB245a_518I6 genome, GCA_000635715.1	
GCA_000635735.1          	172.18.8.72	58723	CyanoBase	Prochlorococcus sp. scB245a_519D13 genome, GCA_000635735.1	
GCA_000635755.1          	172.18.8.72	55853	CyanoBase	Prochlorococcus sp. scB245a_519G16 genome, GCA_000635755.1	
GCA_000635775.1          	172.18.8.72	52773	CyanoBase	Prochlorococcus sp. scB245a_519O11 genome, GCA_000635775.1	
GCA_000635795.1          	172.18.8.72	57573	CyanoBase	Prochlorococcus sp. scB245a_520E22 genome, GCA_000635795.1	
GCA_000635815.1          	172.18.8.72	52843	CyanoBase	Prochlorococcus sp. scB245a_520F22 genome, GCA_000635815.1	
GCA_000635835.1          	172.18.8.72	53763	CyanoBase	Prochlorococcus sp. scB245a_521B10 genome, GCA_000635835.1	
GCA_000635855.1          	172.18.8.72	51803	CyanoBase	Prochlorococcus sp. scB245a_521M10 genome, GCA_000635855.1	
GCA_000635875.1          	172.18.8.72	57873	CyanoBase	Prochlorococcus sp. scB245a_521N5 genome, GCA_000635875.1	
GCA_000708525.1          	172.18.8.72	55593	CyanoBase	Cyanobium sp. CACIAM 14 genome, GCA_000708525.1	
GCA_000710505.1          	172.18.8.72	57633	CyanoBase	Planktothrix agardhii NIVA-CYA 126/8 genome, GCA_000710505.1	
GCA_000715475.1          	172.18.8.72	56633	CyanoBase	Synechococcus sp. NKBG042902 genome, GCA_000715475.1	
GCA_000733415.1          	172.18.8.72	54753	CyanoBase	Leptolyngbya sp. JSC-1 genome, GCA_000733415.1	
GCA_000734895.2          	172.18.8.72	52523	CyanoBase	Calothrix sp. 336/3 genome, GCA_000734895.2	
GCA_000737535.1          	172.18.8.72	56783	CyanoBase	Synechococcus sp. KORDI-100 genome, GCA_000737535.1	
GCA_000737575.1          	172.18.8.72	58753	CyanoBase	Synechococcus sp. KORDI-49 genome, GCA_000737575.1	
GCA_000737595.1          	172.18.8.72	53633	CyanoBase	Synechococcus sp. KORDI-52 genome, GCA_000737595.1	
GCA_000737945.1          	172.18.8.72	56533	CyanoBase	Candidatus Atelocyanobacterium thalassa isolate SIO64986 genome, GCA_000737945.1	
GCA_000756305.1          	172.18.8.72	51673	CyanoBase	Myxosarcina sp. GI1 genome, GCA_000756305.1	
GCA_000757845.1          	172.18.8.72	54903	CyanoBase	Prochlorococcus sp. MIT 0604 genome, GCA_000757845.1	
GCA_000757865.1          	172.18.8.72	55773	CyanoBase	Prochlorococcus sp. MIT 0801 genome, GCA_000757865.1	
GCA_000759855.1          	172.18.8.72	53713	CyanoBase	Prochlorococcus marinus str. MIT 9107 genome, GCA_000759855.1	
GCA_000759865.1          	172.18.8.72	58563	CyanoBase	Prochlorococcus marinus str. MIT 9116 genome, GCA_000759865.1	
GCA_000759875.1          	172.18.8.72	57973	CyanoBase	Prochlorococcus marinus str. EQPAC1 genome, GCA_000759875.1	
GCA_000759885.1          	172.18.8.72	56913	CyanoBase	Prochlorococcus marinus str. GP2 genome, GCA_000759885.1	
GCA_000759935.1          	172.18.8.72	52643	CyanoBase	Prochlorococcus marinus str. MIT 9123 genome, GCA_000759935.1	
GCA_000759955.1          	172.18.8.72	53893	CyanoBase	Prochlorococcus marinus str. MIT 9201 genome, GCA_000759955.1	
GCA_000759975.1          	172.18.8.72	54583	CyanoBase	Prochlorococcus marinus str. MIT 9302 genome, GCA_000759975.1	
GCA_000760015.1          	172.18.8.72	53753	CyanoBase	Prochlorococcus marinus str. MIT 9311 genome, GCA_000760015.1	
GCA_000760035.1          	172.18.8.72	56983	CyanoBase	Prochlorococcus marinus str. MIT 9314 genome, GCA_000760035.1	
GCA_000760055.1          	172.18.8.72	51793	CyanoBase	Prochlorococcus marinus str. MIT 9321 genome, GCA_000760055.1	
GCA_000760075.1          	172.18.8.72	53833	CyanoBase	Prochlorococcus marinus str. MIT 9322 genome, GCA_000760075.1	
GCA_000760095.1          	172.18.8.72	54623	CyanoBase	Prochlorococcus marinus str. MIT 9401 genome, GCA_000760095.1	
GCA_000760115.1          	172.18.8.72	51713	CyanoBase	Prochlorococcus marinus str. SB genome, GCA_000760115.1	
GCA_000760155.1          	172.18.8.72	54833	CyanoBase	Prochlorococcus marinus str. LG genome, GCA_000760155.1	
GCA_000760175.1          	172.18.8.72	52953	CyanoBase	Prochlorococcus sp. MIT 0601 genome, GCA_000760175.1	
GCA_000760195.1          	172.18.8.72	57783	CyanoBase	Prochlorococcus sp. MIT 0602 genome, GCA_000760195.1	
GCA_000760215.1          	172.18.8.72	55913	CyanoBase	Prochlorococcus sp. MIT 0603 genome, GCA_000760215.1	
GCA_000760235.1          	172.18.8.72	51683	CyanoBase	Prochlorococcus marinus str. PAC1 genome, GCA_000760235.1	
GCA_000760255.1          	172.18.8.72	53843	CyanoBase	Prochlorococcus marinus str. SS2 genome, GCA_000760255.1	
GCA_000760275.1          	172.18.8.72	51923	CyanoBase	Prochlorococcus marinus str. SS35 genome, GCA_000760275.1	
GCA_000760295.1          	172.18.8.72	53643	CyanoBase	Prochlorococcus sp. MIT 0701 genome, GCA_000760295.1	
GCA_000760315.1          	172.18.8.72	53883	CyanoBase	Prochlorococcus sp. MIT 0702 genome, GCA_000760315.1	
GCA_000760335.1          	172.18.8.72	52943	CyanoBase	Prochlorococcus sp. MIT 0703 genome, GCA_000760335.1	
GCA_000760355.1          	172.18.8.72	55503	CyanoBase	Prochlorococcus marinus str. SS51 genome, GCA_000760355.1	
GCA_000760375.1          	172.18.8.72	56503	CyanoBase	Prochlorococcus sp. SS52 genome, GCA_000760375.1	
GCA_000760695.2          	172.18.8.72	51903	CyanoBase	Tolypothrix bouteillei VB521301 genome, GCA_000760695.2	
GCA_000763385.1          	172.18.8.72	57533	CyanoBase	Leptolyngbya sp. KIOST-1 genome, GCA_000763385.1	
GCA_000775285.1          	172.18.8.72	56893	CyanoBase	Neosynechococcus sphagnicola sy1 genome, GCA_000775285.1	
GCA_000787675.1          	172.18.8.72	52783	CyanoBase	Microcystis aeruginosa NIES-44 genome, GCA_000787675.1	
GCA_000789435.1          	172.18.8.72	54593	CyanoBase	Aphanizomenon flos-aquae 2012/KM1/D3 genome, GCA_000789435.1	
GCA_000817325.1          	172.18.8.72	54503	CyanoBase	Synechococcus sp. UTEX 2973 genome, GCA_000817325.1	
GCA_000817735.1          	172.18.8.72	54913	CyanoBase	Scytonema millei VB511283 genome, GCA_000817735.1	
GCA_000817745.1          	172.18.8.72	52983	CyanoBase	Aphanocapsa montana BDHKU210001 genome, GCA_000817745.1	
GCA_000817775.1          	172.18.8.72	57593	CyanoBase	Lyngbya confervoides BDU141951 genome, GCA_000817775.1	
GCA_000817785.1          	172.18.8.72	57513	CyanoBase	Hassallia byssoidea VB512170 genome, GCA_000817785.1	
GCA_000828075.1          	172.18.8.72	57853	CyanoBase	Tolypothrix campylonemoides VB511288 genome, GCA_000828075.1	
GCA_000828085.1          	172.18.8.72	52513	CyanoBase	Scytonema tolypothrichoides VB-61278 genome, GCA_000828085.1	
GCA_000829235.1          	172.18.8.72	51703	CyanoBase	cyanobacterium endosymbiont of Epithemia turgida isolate EtSB Lake Yunoko genome, GCA_000829235.1	
GCA_000934435.1          	172.18.8.72	52763	CyanoBase	Mastigocladus laminosus UU774 genome, GCA_000934435.1	
GCA_000952155.1          	172.18.8.72	52713	CyanoBase	Chroococcales cyanobacterium CENA595 genome, GCA_000952155.1	
GCA_000963755.2          	172.18.8.72	56523	CyanoBase	Trichodesmium erythraeum 21-75 genome, GCA_000963755.2	
GCA_000972705.2          	172.18.8.72	55923	CyanoBase	Limnoraphis robusta CS-951 genome, GCA_000972705.2	
GCA_000973065.1          	172.18.8.72	52973	CyanoBase	Arthrospira sp. PCC 8005 genome, GCA_000973065.1	
GCA_000974245.1          	172.18.8.72	56993	CyanoBase	Arthrospira sp. TJSD091 genome, GCA_000974245.1	
GCA_000981785.1          	172.18.8.72	56763	CyanoBase	Microcystis aeruginosa NIES-2549 genome, GCA_000981785.1	
GCA_000987385.1          	172.18.8.72	53743	CyanoBase	Trichodesmium thiebautii H9-4 genome, GCA_000987385.1	
GCA_001007625.1          	172.18.8.72	51823	CyanoBase	Candidatus Synechococcus spongiarum 142 genome, GCA_001007625.1	
GCA_001007635.1          	172.18.8.72	51963	CyanoBase	Candidatus Synechococcus spongiarum 15L genome, GCA_001007635.1	
GCA_001007665.1          	172.18.8.72	58523	CyanoBase	Candidatus Synechococcus spongiarum SP3 genome, GCA_001007665.1	
GCA_001039265.1          	172.18.8.72	55613	CyanoBase	Synechococcus sp. GFB01 genome, GCA_001039265.1	
GCA_001039555.1          	172.18.8.72	51633	CyanoBase	Crocosphaera watsonii WH 8502 genome, GCA_001039555.1	
GCA_001039615.1          	172.18.8.72	58643	CyanoBase	Crocosphaera watsonii WH 0401 genome, GCA_001039615.1	
GCA_001039635.1          	172.18.8.72	52673	CyanoBase	Crocosphaera watsonii WH 0402 genome, GCA_001039635.1	
GCA_001040845.1          	172.18.8.72	54943	CyanoBase	Synechococcus sp. WH 8020 genome, GCA_001040845.1	
GCA_001050835.1          	172.18.8.72	57543	CyanoBase	Crocosphaera watsonii WH 0005 genome, GCA_001050835.1	
GCA_001180245.1          	172.18.8.72	55743	CyanoBase	Prochlorococcus marinus genome, GCA_001180245.1	
GCA_001180265.1          	172.18.8.72	55753	CyanoBase	Prochlorococcus marinus genome, GCA_001180265.1	
GCA_001180285.1          	172.18.8.72	57523	CyanoBase	Prochlorococcus marinus genome, GCA_001180285.1	
GCA_001180305.1          	172.18.8.72	54853	CyanoBase	Prochlorococcus marinus genome, GCA_001180305.1	
GCA_001180325.1          	172.18.8.72	54863	CyanoBase	Prochlorococcus marinus genome, GCA_001180325.1	
GCA_001182765.1          	172.18.8.72	54703	CyanoBase	Synechococcus sp. WH 8103 genome, GCA_001182765.1	
GCA_001264245.1          	172.18.8.72	56793	CyanoBase	Microcystis panniformis FACHB-1757 genome, GCA_001264245.1	
GCA_001275395.1          	172.18.8.72	54963	CyanoBase	Hapalosiphon sp. MRB220 genome, GCA_001275395.1	
GCA_001276715.1          	172.18.8.72	51873	CyanoBase	Planktothricoides sp. SR001 genome, GCA_001276715.1	
GCA_001277295.1          	172.18.8.72	57863	CyanoBase	Anabaena sp. wa102 genome, GCA_001277295.1	
GCA_001298445.1          	172.18.8.72	56693	CyanoBase	Nostoc piscinale CENA21 genome, GCA_001298445.1	
GCA_001314865.1          	172.18.8.72	54603	CyanoBase	Phormidesmis priestleyi Ana genome, GCA_001314865.1	
GCA_001314905.1          	172.18.8.72	52683	CyanoBase	Phormidium sp. OSCR genome, GCA_001314905.1	
GCA_001318385.1          	172.18.8.72	57693	CyanoBase	Synechocystis sp. PCC 6803 genome, GCA_001318385.1	
GCA_001402795.1          	172.18.8.72	52813	CyanoBase	Pseudanabaena sp. Roaring Creek genome, GCA_001402795.1	
GCA_001456025.1          	172.18.8.72	54993	CyanoBase	Mastigocoleus testarum BC008 genome, GCA_001456025.1	
GCA_001458455.1          	172.18.8.72	54823	CyanoBase	Chrysosporum ovalisporum genome, GCA_001458455.1	
refseq70                 	172.18.8.74	60003	RefSeq   	RefSeq complete RNA release 70 (May, 2015)	
refseq80                 	172.18.8.74	60103	RefSeq   	RefSeq complete RNA release 80 (Jan, 2017)	
refseq86                 	172.18.8.74	60163	RefSeq   	RefSeq complete RNA release 86 (Jan, 2018)	
refseq87                 	172.18.8.73	60173	RefSeq   	RefSeq complete RNA release 87 (Mar, 2018)	
refseq                   	172.18.8.73	60173	RefSeq   	RefSeq complete RNA release 87 (Mar, 2018)	
hs_refseq                	172.18.8.75	42393	RefSeq   	RefSeq human RNA release 60 (Jul, 2013)	Homo sapiens
mm_refseq                	172.18.8.75	42433	RefSeq   	RefSeq mouse RNA release 60 (Jul, 2013)	Mus musculus
hg19_pre_mRNA            	172.18.8.75	50013	         	Human pre mRNA, Bits DB (Dec, 2014)	Homo sapiens
mm10_pre_mRNA            	172.18.8.75	50023	         	Mouse pre mRNA, Bits DB (Dec, 2014)	Mus musculus
hg19_pre_mRNA_v2         	172.18.8.75	50033	         	Human pre mRNA, Bits DB v2 (Feb, 2015)	Homo sapiens
mm10_pre_mRNA_v2         	172.18.8.75	50043	         	Mouse pre mRNA, Bits DB v2 (Feb, 2015)	Mus musculus
hs_refseq70              	172.18.8.75	50063	RefSeq   	RefSeq human RNA release 70 (May, 2015)	Homo sapiens
mm_refseq70              	172.18.8.75	50073	RefSeq   	RefSeq mouse RNA release 70 (May, 2015)	Mus musculus
hs_pre_mRNA_201505       	172.18.8.75	50083	         	Human pre mRNA, refseq70-hg19 (May, 2015)	Homo sapiens
mm_pre_mRNA_201505       	172.18.8.75	50093	         	Mouse pre mRNA, refseq70-mm10 (May, 2015)	Mus musculus
hs_pre_mRNA_nr_201505    	172.18.8.75	50103	         	Human non-redundant pre mRNA, refseq70-hg19 (May, 2015)	Homo sapiens
mm_pre_mRNA_nr_201505    	172.18.8.75	50113	         	Mouse non-redundant pre mRNA, refseq70-mm10 (May, 2015)	Mus musculus
hsnm_refseq70            	172.18.8.75	50123	RefSeq   	RefSeq human RNA (NM/NR) release 70 (May, 2015)	Homo sapiens
hsxm_refseq70            	172.18.8.75	50133	RefSeq   	RefSeq human RNA (XM/XR) release 70 (May, 2015)	Homo sapiens
mmnm_refseq70            	172.18.8.75	50143	RefSeq   	RefSeq mouse RNA (NM/NR) release 70 (May, 2015)	Mus musculus
mmxm_refseq70            	172.18.8.75	50153	RefSeq   	RefSeq mouse RNA (XM/XR) release 70 (May, 2015)	Mus musculus
rn_refseq70              	172.18.8.75	50163	RefSeq   	RefSeq rat RNA release 70 (May, 2015)	Rattus norvegicus
rnnm_refseq70            	172.18.8.75	50173	RefSeq   	RefSeq rat RNA (NM/NR) release 70 (May, 2015)	Rattus norvegicus
rnxm_refseq70            	172.18.8.75	50183	RefSeq   	RefSeq rat RNA (XM/XR) release 70 (May, 2015)	Rattus norvegicus
hs_refseq80              	172.18.8.75	50193	RefSeq   	RefSeq human RNA release 80 (Jan, 2017)	Homo sapiens
hsnm_refseq80            	172.18.8.75	50213	RefSeq   	RefSeq human RNA (NM/NR) release 80 (Jan, 2017)	Homo sapiens
hsxm_refseq80            	172.18.8.75	50223	RefSeq   	RefSeq human RNA (XM/XR) release 80 (Jan, 2017)	Homo sapiens
mm_refseq80              	172.18.8.75	50203	RefSeq   	RefSeq mouse RNA release 80 (Jan, 2017)	Mus musculus
mmnm_refseq80            	172.18.8.75	50233	RefSeq   	RefSeq mouse RNA (NM/NR) release 80 (Jan, 2017)	Mus musculus
mmxm_refseq80            	172.18.8.75	50243	RefSeq   	RefSeq mouse RNA (XM/XR) release 80 (Jan, 2017)	Mus musculus
rn_refseq80              	172.18.8.75	50253	RefSeq   	RefSeq rat RNA release 80 (Jan, 2017)	Rattus norvegicus
rnnm_refseq80            	172.18.8.75	50263	RefSeq   	RefSeq rat RNA (NM/NR) release 80 (Jan, 2017)	Rattus norvegicus
rnxm_refseq80            	172.18.8.75	50273	RefSeq   	RefSeq rat RNA (XM/XR) release 80 (Jan, 2017)	Rattus norvegicus
hg19_pre_mRNA_refGene171101	172.18.8.75	50283	         	Human pre mRNA, refGene 171101 on hg19	Homo sapiens
hg19_pre_mRNA_FANTOMlv1  	172.18.8.75	50293	         	Human pre mRNA, FANTOM lv1 on hg19	Homo sapiens
hg19_pre_mRNA_FANTOMlv4  	172.18.8.75	50303	         	Human pre mRNA, FANTOM lv4 on hg19	Homo sapiens
GENCODE_26               	172.18.8.75	42953	GENCODE  	GENCODE human release 26 (Mar, 2017)	Homo sapiens
GENCODE_27               	172.18.8.75	43563	GENCODE  	GENCODE human release 27 (Aug, 2017)	Homo sapiens
GENCODE_M13              	172.18.8.75	42963	GENCODE  	GENCODE mouse release M13 (Mar, 2017)	Mus musculus
GENCODE_M15              	172.18.8.75	43573	GENCODE  	GENCODE mouse release M15 (Aug, 2017)	Mus musculus
GENCODE_M16              	172.18.8.75	43623	GENCODE  	GENCODE mouse release M16 (Dec, 2017)	Mus musculus
miRBase21                	172.18.8.72	43593	miRBase  	miRBase release 21, stem-loop microRNA sequences (Jun, 2014)	
miRBase21mat             	172.18.8.72	43603	miRBase  	miRBase release 21, mature microRNA sequences (Jun, 2014)	
miRBase22                	172.18.8.72	43743	miRBase  	miRBase release 22, stem-loop microRNA sequences (Mar, 2018)	
miRBase22mat             	172.18.8.72	43753	miRBase  	miRBase release 22, mature microRNA sequences (Mar, 2018)	
togogenome85             	172.18.8.70	60353	         	TogoGenome from RefSeq 85 (Nov, 2017)	
togogenome               	172.18.8.70	60353	         	TogoGenome from RefSeq 85 (Nov, 2017)	
ddbj111hum               	172.18.8.77	56023	DDBJ     	DDBJ release 111.0, HUM division (Dec, 2017)	ddbjhum
ddbj111pri               	172.18.8.76	56033	DDBJ     	DDBJ release 111.0, PRI division (Dec, 2017)	ddbjpri
ddbj111rod               	172.18.8.72	56043	DDBJ     	DDBJ release 111.0, ROD division (Dec, 2017)	ddbjrod
ddbj111mam               	172.18.8.76	56053	DDBJ     	DDBJ release 111.0, MAM division (Dec, 2017)	ddbjmam
ddbj111vrt               	172.18.8.76	56063	DDBJ     	DDBJ release 111.0, VRT division (Dec, 2017)	ddbjvrt
ddbj111inv               	172.18.8.73	56073	DDBJ     	DDBJ release 111.0, INV division (Dec, 2017)	ddbjinv
ddbj111pln               	172.18.8.78	56083	DDBJ     	DDBJ release 111.0, PLN division (Dec, 2017)	ddbjpln
ddbj111bct               	172.18.8.78	56093	DDBJ     	DDBJ release 111.0, BCT division (Dec, 2017)	ddbjbct
ddbj111vrl               	172.18.8.75	56103	DDBJ     	DDBJ release 111.0, VRL division (Dec, 2017)	ddbjvrl
ddbj111phg               	172.18.8.78	56113	DDBJ     	DDBJ release 111.0, PHG division (Dec, 2017)	ddbjphg
ddbj111pat               	172.18.8.77	56123	DDBJ     	DDBJ release 111.0, PAT division (Dec, 2017)	ddbjpat
ddbj111env               	172.18.8.77	56133	DDBJ     	DDBJ release 111.0, ENV division (Dec, 2017)	ddbjenv
ddbj111syn               	172.18.8.73	56143	DDBJ     	DDBJ release 111.0, SYN division (Dec, 2017)	ddbjsyn
ddbj111est               	172.18.8.73	56153	DDBJ     	DDBJ release 111.0, EST division (Dec, 2017)	ddbjest
ddbj111tsa               	172.18.8.72	56163	DDBJ     	DDBJ release 111.0, TSA division (Dec, 2017)	ddbjtsa
ddbj111gss               	172.18.8.76	56173	DDBJ     	DDBJ release 111.0, GSS division (Dec, 2017)	ddbjgss
ddbj111htc               	172.18.8.73	56183	DDBJ     	DDBJ release 111.0, HTC division (Dec, 2017)	ddbjhtc
ddbj111htg               	172.18.8.72	56193	DDBJ     	DDBJ release 111.0, HTG division (Dec, 2017)	ddbjhtg
ddbj111sts               	172.18.8.78	56203	DDBJ     	DDBJ release 111.0, STS division (Dec, 2017)	ddbjsts
ddbj111una               	172.18.8.73	56213	DDBJ     	DDBJ release 111.0, UNA division (Dec, 2017)	ddbjuna
65017                    	172.18.8.75	65017	         	Test Database 65017	
65027                    	172.18.8.75	65027	         	Test Database 65027	
65037                    	172.18.8.75	65037	         	Test Database 65037	
65047                    	172.18.8.75	65047	         	Test Database 65047	
65057                    	172.18.8.75	65057	         	Test Database 65057	
65067                    	172.18.8.75	65067	         	Test Database 65067	
65077                    	172.18.8.75	65077	         	Test Database 65077	
65087                    	172.18.8.75	65087	         	Test Database 65087	
65097                    	172.18.8.75	65097	         	Test Database 65097	
65107                    	172.18.8.75	65107	         	Test Database 65107	
--EOS--

return 1 ;
