package DBmenu ;

# 生物種選択メニューのHTML

%db_synonym  = %::db_synonym ;
%db_fullname = %::db_fullname ;

$dbmenu = <<"--EOS--" ;
	<option value=\'hg38\'    synonym=\"$db_synonym{'hg38'   }\">$db_fullname{'hg38'   }</option>
	<option value=\'hg19\'    synonym=\"$db_synonym{'hg19'   }\">$db_fullname{'hg19'   }</option>
	<option value=\'hg18\'    synonym=\"$db_synonym{'hg18'   }\">$db_fullname{'hg18'   }</option>
	<option value=\'mm10\'    synonym=\"$db_synonym{'mm10'   }\">$db_fullname{'mm10'   }</option>
	<option value=\'mm9\'     synonym=\"$db_synonym{'mm9'    }\">$db_fullname{'mm9'    }</option>
	<option value=\'rn6\'     synonym=\"$db_synonym{'rn6'    }\">$db_fullname{'rn6'    }</option>
	<option value=\'rn5\'     synonym=\"$db_synonym{'rn5'    }\">$db_fullname{'rn5'    }</option>
	<option value=\'vicPac2\' synonym=\"$db_synonym{'vicPac2'}\">$db_fullname{'vicPac2'}</option>
	<option value=\'dasNov3\' synonym=\"$db_synonym{'dasNov3'}\">$db_fullname{'dasNov3'}</option>
	<option value=\'papAnu2\' synonym=\"$db_synonym{'papAnu2'}\">$db_fullname{'papAnu2'}</option>
	<option value=\'otoGar3\' synonym=\"$db_synonym{'otoGar3'}\">$db_fullname{'otoGar3'}</option>
	<option value=\'felCat5\' synonym=\"$db_synonym{'felCat5'}\">$db_fullname{'felCat5'}</option>
	<option value=\'panTro4\' synonym=\"$db_synonym{'panTro4'}\">$db_fullname{'panTro4'}</option>
	<option value=\'criGri1\' synonym=\"$db_synonym{'criGri1'}\">$db_fullname{'criGri1'}</option>
	<option value=\'bosTau8\' synonym=\"$db_synonym{'bosTau8'}\">$db_fullname{'bosTau8'}</option>
	<option value=\'canFam3\' synonym=\"$db_synonym{'canFam3'}\">$db_fullname{'canFam3'}</option>
	<option value=\'turTru2\' synonym=\"$db_synonym{'turTru2'}\">$db_fullname{'turTru2'}</option>
	<option value=\'loxAfr3\' synonym=\"$db_synonym{'loxAfr3'}\">$db_fullname{'loxAfr3'}</option>
	<option value=\'musFur1\' synonym=\"$db_synonym{'musFur1'}\">$db_fullname{'musFur1'}</option>
	<option value=\'nomLeu3\' synonym=\"$db_synonym{'nomLeu3'}\">$db_fullname{'nomLeu3'}</option>
	<option value=\'gorGor3\' synonym=\"$db_synonym{'gorGor3'}\">$db_fullname{'gorGor3'}</option>
	<option value=\'cavPor3\' synonym=\"$db_synonym{'cavPor3'}\">$db_fullname{'cavPor3'}</option>
	<option value=\'eriEur2\' synonym=\"$db_synonym{'eriEur2'}\">$db_fullname{'eriEur2'}</option>
	<option value=\'equCab2\' synonym=\"$db_synonym{'equCab2'}\">$db_fullname{'equCab2'}</option>
	<option value=\'dipOrd1\' synonym=\"$db_synonym{'dipOrd1'}\">$db_fullname{'dipOrd1'}</option>
	<option value=\'triMan1\' synonym=\"$db_synonym{'triMan1'}\">$db_fullname{'triMan1'}</option>
	<option value=\'calJac3\' synonym=\"$db_synonym{'calJac3'}\">$db_fullname{'calJac3'}</option>
	<option value=\'pteVam1\' synonym=\"$db_synonym{'pteVam1'}\">$db_fullname{'pteVam1'}</option>
	<option value=\'myoLuc2\' synonym=\"$db_synonym{'myoLuc2'}\">$db_fullname{'myoLuc2'}</option>
	<option value=\'balAcu1\' synonym=\"$db_synonym{'balAcu1'}\">$db_fullname{'balAcu1'}</option>
	<option value=\'micMur1\' synonym=\"$db_synonym{'micMur1'}\">$db_fullname{'micMur1'}</option>
	<option value=\'hetGla2\' synonym=\"$db_synonym{'hetGla2'}\">$db_fullname{'hetGla2'}</option>
	<option value=\'monDom5\' synonym=\"$db_synonym{'monDom5'}\">$db_fullname{'monDom5'}</option>
	<option value=\'ponAbe2\' synonym=\"$db_synonym{'ponAbe2'}\">$db_fullname{'ponAbe2'}</option>
	<option value=\'ailMel1\' synonym=\"$db_synonym{'ailMel1'}\">$db_fullname{'ailMel1'}</option>
	<option value=\'susScr3\' synonym=\"$db_synonym{'susScr3'}\">$db_fullname{'susScr3'}</option>
	<option value=\'ochPri3\' synonym=\"$db_synonym{'ochPri3'}\">$db_fullname{'ochPri3'}</option>
	<option value=\'ornAna1\' synonym=\"$db_synonym{'ornAna1'}\">$db_fullname{'ornAna1'}</option>
	<option value=\'oryCun2\' synonym=\"$db_synonym{'oryCun2'}\">$db_fullname{'oryCun2'}</option>
	<option value=\'rheMac3\' synonym=\"$db_synonym{'rheMac3'}\">$db_fullname{'rheMac3'}</option>
	<option value=\'proCap1\' synonym=\"$db_synonym{'proCap1'}\">$db_fullname{'proCap1'}</option>
	<option value=\'oviAri3\' synonym=\"$db_synonym{'oviAri3'}\">$db_fullname{'oviAri3'}</option>
	<option value=\'sorAra2\' synonym=\"$db_synonym{'sorAra2'}\">$db_fullname{'sorAra2'}</option>
	<option value=\'choHof1\' synonym=\"$db_synonym{'choHof1'}\">$db_fullname{'choHof1'}</option>
	<option value=\'speTri2\' synonym=\"$db_synonym{'speTri2'}\">$db_fullname{'speTri2'}</option>
	<option value=\'saiBol1\' synonym=\"$db_synonym{'saiBol1'}\">$db_fullname{'saiBol1'}</option>
	<option value=\'tarSyr1\' synonym=\"$db_synonym{'tarSyr1'}\">$db_fullname{'tarSyr1'}</option>
	<option value=\'sarHar1\' synonym=\"$db_synonym{'sarHar1'}\">$db_fullname{'sarHar1'}</option>
	<option value=\'echTel2\' synonym=\"$db_synonym{'echTel2'}\">$db_fullname{'echTel2'}</option>
	<option value=\'tupBel1\' synonym=\"$db_synonym{'tupBel1'}\">$db_fullname{'tupBel1'}</option>
	<option value=\'macEug2\' synonym=\"$db_synonym{'macEug2'}\">$db_fullname{'macEug2'}</option>
	<option value=\'cerSim1\' synonym=\"$db_synonym{'cerSim1'}\">$db_fullname{'cerSim1'}</option>
	<option value=\'allMis1\' synonym=\"$db_synonym{'allMis1'}\">$db_fullname{'allMis1'}</option>
	<option value=\'gadMor1\' synonym=\"$db_synonym{'gadMor1'}\">$db_fullname{'gadMor1'}</option>
	<option value=\'melUnd1\' synonym=\"$db_synonym{'melUnd1'}\">$db_fullname{'melUnd1'}</option>
	<option value=\'galGal4\' synonym=\"$db_synonym{'galGal4'}\">$db_fullname{'galGal4'}</option>
	<option value=\'latCha1\' synonym=\"$db_synonym{'latCha1'}\">$db_fullname{'latCha1'}</option>
	<option value=\'calMil1\' synonym=\"$db_synonym{'calMil1'}\">$db_fullname{'calMil1'}</option>
	<option value=\'fr3\'     synonym=\"$db_synonym{'fr3'    }\">$db_fullname{'fr3'    }</option>
	<option value=\'petMar2\' synonym=\"$db_synonym{'petMar2'}\">$db_fullname{'petMar2'}</option>
	<option value=\'anoCar2\' synonym=\"$db_synonym{'anoCar2'}\">$db_fullname{'anoCar2'}</option>
	<option value=\'oryLat2\' synonym=\"$db_synonym{'oryLat2'}\">$db_fullname{'oryLat2'}</option>
	<option value=\'geoFor1\' synonym=\"$db_synonym{'geoFor1'}\">$db_fullname{'geoFor1'}</option>
	<option value=\'oreNil2\' synonym=\"$db_synonym{'oreNil2'}\">$db_fullname{'oreNil2'}</option>
	<option value=\'chrPic1\' synonym=\"$db_synonym{'chrPic1'}\">$db_fullname{'chrPic1'}</option>
	<option value=\'gasAcu1\' synonym=\"$db_synonym{'gasAcu1'}\">$db_fullname{'gasAcu1'}</option>
	<option value=\'tetNig2\' synonym=\"$db_synonym{'tetNig2'}\">$db_fullname{'tetNig2'}</option>
	<option value=\'melGal1\' synonym=\"$db_synonym{'melGal1'}\">$db_fullname{'melGal1'}</option>
	<option value=\'Xenla9\'  synonym=\"$db_synonym{'Xenla9' }\">$db_fullname{'Xenla9' }</option>
	<option value=\'Xenla7\'  synonym=\"$db_synonym{'Xenla7' }\">$db_fullname{'Xenla7' }</option>
	<option value=\'Xentr9\'  synonym=\"$db_synonym{'Xentr9' }\">$db_fullname{'Xentr9' }</option>
	<option value=\'Xentr8\'  synonym=\"$db_synonym{'Xentr8' }\">$db_fullname{'Xentr8' }</option>
	<option value=\'Xentr7\'  synonym=\"$db_synonym{'Xentr7' }\">$db_fullname{'Xentr7' }</option>
	<option value=\'xenTro3\' synonym=\"$db_synonym{'xenTro3'}\">$db_fullname{'xenTro3'}</option>
	<option value=\'taeGut2\' synonym=\"$db_synonym{'taeGut2'}\">$db_fullname{'taeGut2'}</option>
	<option value=\'danRer7\' synonym=\"$db_synonym{'danRer7'}\">$db_fullname{'danRer7'}</option>
	<option value=\'KH\'      synonym=\"$db_synonym{'KH'     }\">$db_fullname{'KH'     }</option>
	<option value=\'ci2\'     synonym=\"$db_synonym{'ci2'    }\">$db_fullname{'ci2'    }</option>
	<option value=\'braFlo1\' synonym=\"$db_synonym{'braFlo1'}\">$db_fullname{'braFlo1'}</option>
	<option value=\'Spur_v3.1\' synonym=\"$db_synonym{'Spur_v3.1'}\">$db_fullname{'Spur_v3.1'}</option>
	<option value=\'strPur2\' synonym=\"$db_synonym{'strPur2'}\">$db_fullname{'strPur2'}</option>
	<option value=\'anoGam1\' synonym=\"$db_synonym{'anoGam1'}\">$db_fullname{'anoGam1'}</option>
	<option value=\'apiMel2\' synonym=\"$db_synonym{'apiMel2'}\">$db_fullname{'apiMel2'}</option>
	<option value=\'droAna2\' synonym=\"$db_synonym{'droAna2'}\">$db_fullname{'droAna2'}</option>
	<option value=\'droEre1\' synonym=\"$db_synonym{'droEre1'}\">$db_fullname{'droEre1'}</option>
	<option value=\'droGri1\' synonym=\"$db_synonym{'droGri1'}\">$db_fullname{'droGri1'}</option>
	<option value=\'dm6\'     synonym=\"$db_synonym{'dm6'    }\">$db_fullname{'dm6'    }</option>
	<option value=\'dm3\'     synonym=\"$db_synonym{'dm3'    }\">$db_fullname{'dm3'    }</option>
	<option value=\'droMoj2\' synonym=\"$db_synonym{'droMoj2'}\">$db_fullname{'droMoj2'}</option>
	<option value=\'droPer1\' synonym=\"$db_synonym{'droPer1'}\">$db_fullname{'droPer1'}</option>
	<option value=\'dp3\'     synonym=\"$db_synonym{'dp3'    }\">$db_fullname{'dp3'    }</option>
	<option value=\'droSec1\' synonym=\"$db_synonym{'droSec1'}\">$db_fullname{'droSec1'}</option>
	<option value=\'droSim1\' synonym=\"$db_synonym{'droSim1'}\">$db_fullname{'droSim1'}</option>
	<option value=\'droVir2\' synonym=\"$db_synonym{'droVir2'}\">$db_fullname{'droVir2'}</option>
	<option value=\'droYak2\' synonym=\"$db_synonym{'droYak2'}\">$db_fullname{'droYak2'}</option>
	<option value=\'caePb2\'  synonym=\"$db_synonym{'caePb2' }\">$db_fullname{'caePb2' }</option>
	<option value=\'cb3\'     synonym=\"$db_synonym{'cb3'    }\">$db_fullname{'cb3'    }</option>
	<option value=\'ce10\'    synonym=\"$db_synonym{'ce10'   }\">$db_fullname{'ce10'   }</option>
	<option value=\'caeJap1\' synonym=\"$db_synonym{'caeJap1'}\">$db_fullname{'caeJap1'}</option>
	<option value=\'caeRem3\' synonym=\"$db_synonym{'caeRem3'}\">$db_fullname{'caeRem3'}</option>
	<option value=\'priPac1\' synonym=\"$db_synonym{'priPac1'}\">$db_fullname{'priPac1'}</option>
	<option value=\'sacCer3\' synonym=\"$db_synonym{'sacCer3'}\">$db_fullname{'sacCer3'}</option>
	<option value=\'aplCal1\' synonym=\"$db_synonym{'aplCal1'}\">$db_fullname{'aplCal1'}</option>

	<option value=\'OryAfe1.0\'      synonym=\"$db_synonym{'OryAfe1.0'     }\">$db_fullname{'OryAfe1.0'     }</option>
	<option value=\'PoeFor_5.1.2\'   synonym=\"$db_synonym{'PoeFor_5.1.2'  }\">$db_fullname{'PoeFor_5.1.2'  }</option>
	<option value=\'CSAV2.0\'        synonym=\"$db_synonym{'CSAV2.0'       }\">$db_fullname{'CSAV2.0'       }</option>
	<option value=\'AstMex102\'      synonym=\"$db_synonym{'AstMex102'     }\">$db_fullname{'AstMex102'     }</option>
	<option value=\'PelSin_1.0\'     synonym=\"$db_synonym{'PelSin_1.0'    }\">$db_fullname{'PelSin_1.0'    }</option>
	<option value=\'MacFas5.0\'      synonym=\"$db_synonym{'MacFas5.0'     }\">$db_fullname{'MacFas5.0'     }</option>
	<option value=\'BGI_duck_1.0\'   synonym=\"$db_synonym{'BGI_duck_1.0'  }\">$db_fullname{'BGI_duck_1.0'  }</option>
	<option value=\'FicAlb_1.4\'     synonym=\"$db_synonym{'FicAlb_1.4'    }\">$db_fullname{'FicAlb_1.4'    }</option>
	<option value=\'Pham\'           synonym=\"$db_synonym{'Pham'          }\">$db_fullname{'Pham'          }</option>
	<option value=\'Xipmac4.4.2\'    synonym=\"$db_synonym{'Xipmac4.4.2'   }\">$db_fullname{'Xipmac4.4.2'   }</option>
	<option value=\'MicOch1.0\'      synonym=\"$db_synonym{'MicOch1.0'     }\">$db_fullname{'MicOch1.0'     }</option>
	<option value=\'PhyMac_2.0.2\'   synonym=\"$db_synonym{'PhyMac_2.0.2'  }\">$db_fullname{'PhyMac_2.0.2'  }</option>
	<option value=\'LepOcu1\'        synonym=\"$db_synonym{'LepOcu1'       }\">$db_fullname{'LepOcu1'       }</option>
	<option value=\'ChlSab1.1\'      synonym=\"$db_synonym{'ChlSab1.1'     }\">$db_fullname{'ChlSab1.1'     }</option>
	<option value=\'Acyr_2.0\'       synonym=\"$db_synonym{'Acyr_2.0'      }\">$db_fullname{'Acyr_2.0'      }</option>
	<option value=\'AaegL3\'         synonym=\"$db_synonym{'AaegL3'        }\">$db_fullname{'AaegL3'        }</option>
	<option value=\'Aqu1\'           synonym=\"$db_synonym{'Aqu1'          }\">$db_fullname{'Aqu1'          }</option>
	<option value=\'AdarC3\'         synonym=\"$db_synonym{'AdarC3'        }\">$db_fullname{'AdarC3'        }</option>
	<option value=\'Attacep1.0\'     synonym=\"$db_synonym{'Attacep1.0'    }\">$db_fullname{'Attacep1.0'    }</option>
	<option value=\'ASM15162v1\'     synonym=\"$db_synonym{'ASM15162v1'    }\">$db_fullname{'ASM15162v1'    }</option>
	<option value=\'B_malayi_3.0\'   synonym=\"$db_synonym{'B_malayi_3.0'  }\">$db_fullname{'B_malayi_3.0'  }</option>
	<option value=\'Capte_v1.0\'     synonym=\"$db_synonym{'Capte_v1.0'    }\">$db_fullname{'Capte_v1.0'    }</option>
	<option value=\'oyster_v9\'      synonym=\"$db_synonym{'oyster_v9'     }\">$db_fullname{'oyster_v9'     }</option>
	<option value=\'CpipJ2\'         synonym=\"$db_synonym{'CpipJ2'        }\">$db_fullname{'CpipJ2'        }</option>
	<option value=\'DanPle_1.0\'     synonym=\"$db_synonym{'DanPle_1.0'    }\">$db_fullname{'DanPle_1.0'    }</option>
	<option value=\'Dappu_V1.0\'     synonym=\"$db_synonym{'Dappu_V1.0'    }\">$db_fullname{'Dappu_V1.0'    }</option>
	<option value=\'DendPond_1.0\'   synonym=\"$db_synonym{'DendPond_1.0'  }\">$db_fullname{'DendPond_1.0'  }</option>
	<option value=\'dwil_caf1\'      synonym=\"$db_synonym{'dwil_caf1'     }\">$db_fullname{'dwil_caf1'     }</option>
	<option value=\'Hmel1\'          synonym=\"$db_synonym{'Hmel1'         }\">$db_fullname{'Hmel1'         }</option>
	<option value=\'Helro1\'         synonym=\"$db_synonym{'Helro1'        }\">$db_fullname{'Helro1'        }</option>
	<option value=\'IscaW1\'         synonym=\"$db_synonym{'IscaW1'        }\">$db_fullname{'IscaW1'        }</option>
	<option value=\'Loa_loa_V3\'     synonym=\"$db_synonym{'Loa_loa_V3'    }\">$db_fullname{'Loa_loa_V3'    }</option>
	<option value=\'Lotgi1\'         synonym=\"$db_synonym{'Lotgi1'        }\">$db_fullname{'Lotgi1'        }</option>
	<option value=\'Msca1\'          synonym=\"$db_synonym{'Msca1'         }\">$db_fullname{'Msca1'         }</option>
	<option value=\'MelCinx1.0\'     synonym=\"$db_synonym{'MelCinx1.0'    }\">$db_fullname{'MelCinx1.0'    }</option>
	<option value=\'MneLei\'         synonym=\"$db_synonym{'MneLei'        }\">$db_fullname{'MneLei'        }</option>
	<option value=\'Nvit_2.1\'       synonym=\"$db_synonym{'Nvit_2.1'      }\">$db_fullname{'Nvit_2.1'      }</option>
	<option value=\'ASM20922v1\'     synonym=\"$db_synonym{'ASM20922v1'    }\">$db_fullname{'ASM20922v1'    }</option>
	<option value=\'Cameroon_v3\'    synonym=\"$db_synonym{'Cameroon_v3'   }\">$db_fullname{'Cameroon_v3'   }</option>
	<option value=\'PhumU2\'         synonym=\"$db_synonym{'PhumU2'        }\">$db_fullname{'PhumU2'        }</option>
	<option value=\'RproC1\'         synonym=\"$db_synonym{'RproC1'        }\">$db_fullname{'RproC1'        }</option>
	<option value=\'ASM23792v2\'     synonym=\"$db_synonym{'ASM23792v2'    }\">$db_fullname{'ASM23792v2'    }</option>
	<option value=\'Si_gnG\'         synonym=\"$db_synonym{'Si_gnG'        }\">$db_fullname{'Si_gnG'        }</option>
	<option value=\'Smar1\'          synonym=\"$db_synonym{'Smar1'         }\">$db_fullname{'Smar1'         }</option>
	<option value=\'ASM23943v1\'     synonym=\"$db_synonym{'ASM23943v1'    }\">$db_fullname{'ASM23943v1'    }</option>
	<option value=\'Tcas3\'          synonym=\"$db_synonym{'Tcas3'         }\">$db_fullname{'Tcas3'         }</option>
	<option value=\'Tspiralis1\'     synonym=\"$db_synonym{'Tspiralis1'    }\">$db_fullname{'Tspiralis1'    }</option>
	<option value=\'ASM15027v1\'     synonym=\"$db_synonym{'ASM15027v1'    }\">$db_fullname{'ASM15027v1'    }</option>
	<option value=\'ZooNev1.0\'      synonym=\"$db_synonym{'ZooNev1.0'     }\">$db_fullname{'ZooNev1.0'     }</option>
	<option value=\'ASM34733v1\'     synonym=\"$db_synonym{'ASM34733v1'    }\">$db_fullname{'ASM34733v1'    }</option>
	<option value=\'AMTR1.0\'        synonym=\"$db_synonym{'AMTR1.0'       }\">$db_fullname{'AMTR1.0'       }</option>
	<option value=\'Araly_v.1.0\'    synonym=\"$db_synonym{'Araly_v.1.0'   }\">$db_fullname{'Araly_v.1.0'   }</option>
	<option value=\'TAIR10_en\'      synonym=\"$db_synonym{'TAIR10_en'     }\">$db_fullname{'TAIR10_en'     }</option>
	<option value=\'Bradi_v1.0\'     synonym=\"$db_synonym{'Bradi_v1.0'    }\">$db_fullname{'Bradi_v1.0'    }</option>
	<option value=\'Braol_v2.1\'     synonym=\"$db_synonym{'Braol_v2.1'    }\">$db_fullname{'Braol_v2.1'    }</option>
	<option value=\'IVFCAASv1\'      synonym=\"$db_synonym{'IVFCAASv1'     }\">$db_fullname{'IVFCAASv1'     }</option>
	<option value=\'Brana_v4.1\'     synonym=\"$db_synonym{'Brana_v4.1'    }\">$db_fullname{'Brana_v4.1'    }</option>
	<option value=\'Chlre_v3.1\'     synonym=\"$db_synonym{'Chlre_v3.1'    }\">$db_fullname{'Chlre_v3.1'    }</option>
	<option value=\'ASM9120v1\'      synonym=\"$db_synonym{'ASM9120v1'     }\">$db_fullname{'ASM9120v1'     }</option>
	<option value=\'Soybn_V1.0\'     synonym=\"$db_synonym{'Soybn_V1.0'    }\">$db_fullname{'Soybn_V1.0'    }</option>
	<option value=\'Horvu_v1\'       synonym=\"$db_synonym{'Horvu_v1'      }\">$db_fullname{'Horvu_v1'      }</option>
	<option value=\'Lperr_V1.4\'     synonym=\"$db_synonym{'Lperr_V1.4'    }\">$db_fullname{'Lperr_V1.4'    }</option>
	<option value=\'MedtrA17_4.0\'   synonym=\"$db_synonym{'MedtrA17_4.0'  }\">$db_fullname{'MedtrA17_4.0'  }</option>
	<option value=\'MA1\'            synonym=\"$db_synonym{'MA1'           }\">$db_fullname{'MA1'           }</option>
	<option value=\'Obart_v1.0\'     synonym=\"$db_synonym{'Obart_v1.0'    }\">$db_fullname{'Obart_v1.0'    }</option>
	<option value=\'Orybr_v1.4b\'    synonym=\"$db_synonym{'Orybr_v1.4b'   }\">$db_fullname{'Orybr_v1.4b'   }</option>
	<option value=\'AGI1.1\'         synonym=\"$db_synonym{'AGI1.1'        }\">$db_fullname{'AGI1.1'        }</option>
	<option value=\'Orygl\'          synonym=\"$db_synonym{'Orygl'         }\">$db_fullname{'Orygl'         }</option>
	<option value=\'Orylo_v0117\'    synonym=\"$db_synonym{'Orylo_v0117'   }\">$db_fullname{'Orylo_v0117'   }</option>
	<option value=\'Oryme_v1.3\'     synonym=\"$db_synonym{'Oryme_v1.3'    }\">$db_fullname{'Oryme_v1.3'    }</option>
	<option value=\'Oryni\'          synonym=\"$db_synonym{'Oryni'         }\">$db_fullname{'Oryni'         }</option>
	<option value=\'Orypu\'          synonym=\"$db_synonym{'Orypu'         }\">$db_fullname{'Orypu'         }</option>
	<option value=\'PRJEB4137\'      synonym=\"$db_synonym{'PRJEB4137'     }\">$db_fullname{'PRJEB4137'     }</option>
	<option value=\'ASM465v1\'       synonym=\"$db_synonym{'ASM465v1'      }\">$db_fullname{'ASM465v1'      }</option>
	<option value=\'ASM9206v1\'      synonym=\"$db_synonym{'ASM9206v1'     }\">$db_fullname{'ASM9206v1'     }</option>
	<option value=\'ASM242v1\'       synonym=\"$db_synonym{'ASM242v1'      }\">$db_fullname{'ASM242v1'      }</option>
	<option value=\'Ptrichocarpa_v3.0\' synonym=\"$db_synonym{'Ptrichocarpa_v3.0'}\">$db_fullname{'Ptrichocarpa_v3.0'}</option>
	<option value=\'Poptr_JGI2.0\'   synonym=\"$db_synonym{'Poptr_JGI2.0'  }\">$db_fullname{'Poptr_JGI2.0'  }</option>
	<option value=\'Prupe1_0\'       synonym=\"$db_synonym{'Prupe1_0'      }\">$db_fullname{'Prupe1_0'      }</option>
	<option value=\'Selml_v1.0\'     synonym=\"$db_synonym{'Selml_v1.0'    }\">$db_fullname{'Selml_v1.0'    }</option>
	<option value=\'Setit_JGIv2.0\'  synonym=\"$db_synonym{'Setit_JGIv2.0' }\">$db_fullname{'Setit_JGIv2.0' }</option>
	<option value=\'SL2.50\'         synonym=\"$db_synonym{'SL2.50'        }\">$db_fullname{'SL2.50'        }</option>
	<option value=\'SolTub_3.0\'     synonym=\"$db_synonym{'SolTub_3.0'    }\">$db_fullname{'SolTub_3.0'    }</option>
	<option value=\'Sorbi1\'         synonym=\"$db_synonym{'Sorbi1'        }\">$db_fullname{'Sorbi1'        }</option>
	<option value=\'Thecc_20110822\' synonym=\"$db_synonym{'Thecc_20110822'}\">$db_fullname{'Thecc_20110822'}</option>
	<option value=\'IWGSC1.0\'       synonym=\"$db_synonym{'IWGSC1.0'      }\">$db_fullname{'IWGSC1.0'      }</option>
	<option value=\'ASM34745v1\'     synonym=\"$db_synonym{'ASM34745v1'    }\">$db_fullname{'ASM34745v1'    }</option>
	<option value=\'IGGP_12x\'       synonym=\"$db_synonym{'IGGP_12x'      }\">$db_fullname{'IGGP_12x'      }</option>
	<option value=\'AGPv3\'          synonym=\"$db_synonym{'AGPv3'         }\">$db_fullname{'AGPv3'         }</option>

	<option value=\'macaque_CE_1\' synonym=\"$db_synonym{'macaque_CE_1'}\">$db_fullname{'macaque_CE_1'}</option>
	<option value=\'bmor1\'   synonym=\"$db_synonym{'bmor1'  }\">$db_fullname{'bmor1'  }</option>
	<option value=\'h7\'           synonym=\"$db_synonym{'h7'          }\">$db_fullname{'h7'          }</option>
	<option value=\'Hydra_RP_1.0\' synonym=\"$db_synonym{'Hydra_RP_1.0'}\">$db_fullname{'Hydra_RP_1.0'}</option>
	<option value=\'pombe\'   synonym=\"$db_synonym{'pombe'  }\">$db_fullname{'pombe'  }</option>
	<option value=\'MG8\'     synonym=\"$db_synonym{'MG8'    }\">$db_fullname{'MG8'    }</option>

	<option value=\'TAIR10\'  synonym=\"$db_synonym{'TAIR10' }\">$db_fullname{'TAIR10' }</option>
	<option value=\'rice\'    synonym=\"$db_synonym{'rice'   }\">$db_fullname{'rice'   }</option>
	<option value=\'sorBic\'  synonym=\"$db_synonym{'sorBic' }\">$db_fullname{'sorBic' }</option>
	<option value=\'lotus_r3.0\'               synonym=\"$db_synonym{'lotus_r3.0'              }\">$db_fullname{'lotus_r3.0'              }</option>
	<option value=\'Niben_v1.0.1\'             synonym=\"$db_synonym{'Niben_v1.0.1'            }\">$db_fullname{'Niben_v1.0.1'            }</option>
	<option value=\'adzuki_ver3\'              synonym=\"$db_synonym{'adzuki_ver3'             }\">$db_fullname{'adzuki_ver3'             }</option>
	<option value=\'RSA_r1.0\'                 synonym=\"$db_synonym{'RSA_r1.0'                }\">$db_fullname{'RSA_r1.0'                }</option>
	<option value=\'Ppatens_251_v3\'           synonym=\"$db_synonym{'Ppatens_251_v3'          }\">$db_fullname{'Ppatens_251_v3'          }</option>
	<option value=\'Smoellendorffii_91_v1\'    synonym=\"$db_synonym{'Smoellendorffii_91_v1'   }\">$db_fullname{'Smoellendorffii_91_v1'   }</option>
	<option value=\'Creinhardtii_281_v5_5\'    synonym=\"$db_synonym{'Creinhardtii_281_v5_5'   }\">$db_fullname{'Creinhardtii_281_v5_5'   }</option>
	<option value=\'Olucimarinus_231_v2\'      synonym=\"$db_synonym{'Olucimarinus_231_v2'     }\">$db_fullname{'Olucimarinus_231_v2'     }</option>
	<option value=\'Cgrandiflora_v1\'          synonym=\"$db_synonym{'Cgrandiflora_v1'         }\">$db_fullname{'Cgrandiflora_v1'         }</option>
	<option value=\'Crubella_v1\'              synonym=\"$db_synonym{'Crubella_v1'             }\">$db_fullname{'Crubella_v1'             }</option>
	<option value=\'Cpapaya_r.Dec2008\'        synonym=\"$db_synonym{'Cpapaya_r.Dec2008'       }\">$db_fullname{'Cpapaya_r.Dec2008'       }</option>
	<option value=\'CsubellipsoideaC169_v2.0\' synonym=\"$db_synonym{'CsubellipsoideaC169_v2.0'}\">$db_fullname{'CsubellipsoideaC169_v2.0'}</option>
	<option value=\'Csativus_v1\'              synonym=\"$db_synonym{'Csativus_v1'             }\">$db_fullname{'Csativus_v1'             }</option>
	<option value=\'Egrandis_v2.0\'            synonym=\"$db_synonym{'Egrandis_v2.0'           }\">$db_fullname{'Egrandis_v2.0'           }</option>
	<option value=\'Fvesca_v1.1\'              synonym=\"$db_synonym{'Fvesca_v1.1'             }\">$db_fullname{'Fvesca_v1.1'             }</option>
	<option value=\'Graimondii_v2.0\'          synonym=\"$db_synonym{'Graimondii_v2.0'         }\">$db_fullname{'Graimondii_v2.0'         }</option>
	<option value=\'Lusitatissimum_BGIv1.0\'   synonym=\"$db_synonym{'Lusitatissimum_BGIv1.0'  }\">$db_fullname{'Lusitatissimum_BGIv1.0'  }</option>
	<option value=\'Mdomestica_v1.0\'          synonym=\"$db_synonym{'Mdomestica_v1.0'         }\">$db_fullname{'Mdomestica_v1.0'         }</option>
	<option value=\'Mesculenta_v6\'            synonym=\"$db_synonym{'Mesculenta_v6'           }\">$db_fullname{'Mesculenta_v6'           }</option>
	<option value=\'MpusillaCCMP1545_v3.0\'    synonym=\"$db_synonym{'MpusillaCCMP1545_v3.0'   }\">$db_fullname{'MpusillaCCMP1545_v3.0'   }</option>
	<option value=\'MpusillaRCC299_v3.0\'      synonym=\"$db_synonym{'MpusillaRCC299_v3.0'     }\">$db_fullname{'MpusillaRCC299_v3.0'     }</option>
	<option value=\'Mguttatus_v2.0\'           synonym=\"$db_synonym{'Mguttatus_v2.0'          }\">$db_fullname{'Mguttatus_v2.0'          }</option>
	<option value=\'Ppersica_v2.0\'            synonym=\"$db_synonym{'Ppersica_v2.0'           }\">$db_fullname{'Ppersica_v2.0'           }</option>
	<option value=\'Rcommunis_TIGR.0.1\'       synonym=\"$db_synonym{'Rcommunis_TIGR.0.1'      }\">$db_fullname{'Rcommunis_TIGR.0.1'      }</option>
	<option value=\'Spolyrhiza_v1\'            synonym=\"$db_synonym{'Spolyrhiza_v1'           }\">$db_fullname{'Spolyrhiza_v1'           }</option>
	<option value=\'Vcarteri_v2\'              synonym=\"$db_synonym{'Vcarteri_v2'             }\">$db_fullname{'Vcarteri_v2'             }</option>

	<option value=\'eboVir3\' synonym=\"$db_synonym{'eboVir3'}\">$db_fullname{'eboVir3'}</option>

	<option disabled>--------------------</option>

	<option value=\'refseq\'      synonym=\"$db_synonym{'refseq'     }\">$db_fullname{'refseq'     }</option>
	<option value=\'hs_refseq70\' synonym=\"$db_synonym{'hs_refseq70'}\">$db_fullname{'hs_refseq70'}</option>
	<option value=\'mm_refseq70\' synonym=\"$db_synonym{'mm_refseq70'}\">$db_fullname{'mm_refseq70'}</option>
	<option value=\'rn_refseq70\' synonym=\"$db_synonym{'rn_refseq70'}\">$db_fullname{'rn_refseq70'}</option>
	<option value=\'prok\'        synonym=\"$db_synonym{'prok'       }\">$db_fullname{'prok'       }</option>
	<option value=\'16SrRNA\'     synonym=\"$db_synonym{'16SrRNA'    }\">$db_fullname{'16SrRNA'    }</option>
	<option value=\'macaque_CE_1_cds\' synonym=\"$db_synonym{'macaque_CE_1_cds'}\">$db_fullname{'macaque_CE_1_cds'}</option>

	<option disabled>--------------------</option>

	<option value=\'ddbj102hum\' synonym=\"$db_synonym{'ddbj102hum'}\">$db_fullname{'ddbj102hum'}</option>
	<option value=\'ddbj102pri\' synonym=\"$db_synonym{'ddbj102pri'}\">$db_fullname{'ddbj102pri'}</option>
	<option value=\'ddbj102rod\' synonym=\"$db_synonym{'ddbj102rod'}\">$db_fullname{'ddbj102rod'}</option>
	<option value=\'ddbj102mam\' synonym=\"$db_synonym{'ddbj102mam'}\">$db_fullname{'ddbj102mam'}</option>
	<option value=\'ddbj102vrt\' synonym=\"$db_synonym{'ddbj102vrt'}\">$db_fullname{'ddbj102vrt'}</option>
	<option value=\'ddbj102inv\' synonym=\"$db_synonym{'ddbj102inv'}\">$db_fullname{'ddbj102inv'}</option>
	<option value=\'ddbj102pln\' synonym=\"$db_synonym{'ddbj102pln'}\">$db_fullname{'ddbj102pln'}</option>
	<option value=\'ddbj102bct\' synonym=\"$db_synonym{'ddbj102bct'}\">$db_fullname{'ddbj102bct'}</option>
	<option value=\'ddbj102vrl\' synonym=\"$db_synonym{'ddbj102vrl'}\">$db_fullname{'ddbj102vrl'}</option>
	<option value=\'ddbj102phg\' synonym=\"$db_synonym{'ddbj102phg'}\">$db_fullname{'ddbj102phg'}</option>
	<option value=\'ddbj102pat\' synonym=\"$db_synonym{'ddbj102pat'}\">$db_fullname{'ddbj102pat'}</option>
	<option value=\'ddbj102env\' synonym=\"$db_synonym{'ddbj102env'}\">$db_fullname{'ddbj102env'}</option>
	<option value=\'ddbj102syn\' synonym=\"$db_synonym{'ddbj102syn'}\">$db_fullname{'ddbj102syn'}</option>
	<option value=\'ddbj102est\' synonym=\"$db_synonym{'ddbj102est'}\">$db_fullname{'ddbj102est'}</option>
	<option value=\'ddbj102tsa\' synonym=\"$db_synonym{'ddbj102tsa'}\">$db_fullname{'ddbj102tsa'}</option>
	<option value=\'ddbj102gss\' synonym=\"$db_synonym{'ddbj102gss'}\">$db_fullname{'ddbj102gss'}</option>
	<option value=\'ddbj102htc\' synonym=\"$db_synonym{'ddbj102htc'}\">$db_fullname{'ddbj102htc'}</option>
	<option value=\'ddbj102htg\' synonym=\"$db_synonym{'ddbj102htg'}\">$db_fullname{'ddbj102htg'}</option>
	<option value=\'ddbj102sts\' synonym=\"$db_synonym{'ddbj102sts'}\">$db_fullname{'ddbj102sts'}</option>
	<option value=\'ddbj102una\' synonym=\"$db_synonym{'ddbj102una'}\">$db_fullname{'ddbj102una'}</option>
	<option value=\'ddbj\'       synonym=\"$db_synonym{'ddbj'      }\">$db_fullname{'ddbj'      }</option>
--EOS--

return 1 ;
