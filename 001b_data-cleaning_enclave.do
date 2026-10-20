/* **************************************************************************************************************************
Author: 		Wanting Jiang
Contact: 		wjiang96@wisc.edu
Project:	 	Financial Engagement Behaviors of Immigrant Populations
Description: 	Data Cleaning - Enclave Sample
Last Update:	10/12/2026

Note:			 1. IPUMS NHGIS, ACS 5-year estimates (Nativity and Citizenship Status)&(Place of Birth for the Foreign-Born)
				https://www.nhgis.org
					nhgis0013_csv/   ACS 2007-2011, CBSA level   (contemporary enclave, FDIC 2011-2013 waves)
					nhgis0021_csv/   ACS 2015-2019, CBSA level   (new CBSA codes only, FDIC 2015-2019 waves)
					nhgis0022_csv/   ACS 2007-2011, NECTA level  (New England metro areas)

				2. IPUMS NHGIS, 1990 Decennial Census, county level (total population)&(foreign-born by place of birth)
					nhgis0027_csv/   

				3. U.S. Census Bureau, Metropolitan and Micropolitan Delineation Files (county-to-CBSA crosswalks)
					030606omb-cbsa-csa.xlsx   OMB Bulletin 03-04, June 6, 2003 (2003 vintage)
					list1.xlsx                February 2013 delineation file (2013 vintage)
					
				
*************************************************************************************************************************/



clear

global account = "YOUR PATH"
 
global HOME "/$account"
global DATA "/$account/YOUR FOLDER NAME"
global LOGS "/$account/YOUR FOLDER NAME"
global TABLES "/$account/YOUR FOLDER NAME"
global FIGURES "/$account/YOUR FOLDER NAME"
global DOFILES "/$account/YOUR FOLDER NAME"




**# 1. Enclave index
**## 1.1 ACS 2007-2011 CBSA (NHGIS extract nhgis0013)

clear

quietly do "$DATA/raw/nhgis0013_csv/nhgis0013_ds185_20115_cbsa.do"


* Check total US population size
*egen total_mxse001= total(mxse001)
*browse total_mxse001


drop regiona-anrca
drop csaa-pumaa


	/* Rename penatvty variable prepare for merging */
	
	rename	mxse001					tot_pop

	rename	mx8e059					penatvty210
	rename	mx8e132					penatvty333
	rename	mx8e017					penatvty110
	rename 	mx8e050					penatvty207 /*China Mainland*/
	rename	mx8e023					penatvty120
	rename 	mx8e095					penatvty427
	rename	mx8e076					penatvty247
	rename 	mx8e138					penatvty303
	rename	mx8e053					penatvty215
	rename 	mx8e142					penatvty313
	rename 	mx8e131					penatvty332
	rename 	mx8e160					penatvty301
	rename	mx8e118					penatvty501
	rename 	mx8e094					penatvty416 
	rename 	mx8e005					penatvty138
	rename	mx8e006					penatvty139
	rename	mx8e007					penatvty140
	rename 	mx8e016					penatvty109
	rename 	mx8e025					penatvty134
	rename	mx8e113 				penatvty447
	rename 	mx8e157					penatvty373
	rename 	mx8e129					penatvty329
	rename 	mx8e127					penatvty327
	rename	mx8e134					penatvty341
	rename  mx8e054					penatvty220
	rename	mx8e155					penatvty370
	rename  mx8e030					penatvty104
	rename  mx8e041					penatvty164
	rename  mx8e112					penatvty440
	rename  mx8e040					penatvty163
	rename  mx8e073					penatvty233
	rename  mx8e130					penatvty330
	rename  mx8e141					penatvty312
	rename	mx8e083					penatvty224
	rename  mx8e008					penatvty119
	rename  mx8e102					penatvty436
	rename	mx8e038					penatvty128
	rename 	mx8e101					penatvty414
	rename  mx8e068					penatvty206
	rename  mx8e110					penatvty421
	rename  mx8e145					penatvty316
	rename  mx8e072					penatvty205
	rename	mx8e051					penatvty209
	rename	mx8e034					penatvty156
	rename  mx8e143					penatvty314
	rename  mx8e148					penatvty360
	rename  mx8e088					penatvty158
	rename 	mx8e153					penatvty365
	rename  mx8e087					penatvty243
	rename  mx8e152					penatvty364
	rename  mx8e052					penatvty240
	rename	mx8e060					penatvty212
	rename  mx8e154					penatvty368
	rename	mx8e063					penatvty231
	rename 	mx8e080					penatvty214
	rename 	mx8e150					penatvty362
	rename  mx8e064					penatvty238
	rename  mx8e039					penatvty132
	rename  mx8e024					penatvty129
	rename	mx8e071					penatvty226
	rename  mx8e075					penatvty242
	rename	mx8e082					penatvty222
	rename  mx8e093					penatvty417
	rename	mx8e079					penatvty213
	rename  mx8e035					penatvty157
	rename	mx8e057					penatvty200
	rename  mx8e111					penatvty429
	rename	mx8e032					penatvty148
	rename  mx8e031					penatvty151
	rename  mx8e070					penatvty223
	rename  mx8e084					penatvty235
	rename  mx8e033					penatvty117
	rename  mx8e139					penatvty310
	rename  mx8e065					penatvty246
	rename  mx8e126					penatvty324
	rename	mx8e149					penatvty361
	rename 	mx8e140					penatvty311
	rename	mx8e119					penatvty515 /* Estimates: Oceania: Australia and New Zealand Subregion: Other Australian and Ne*/
	rename	mx8e086					penatvty248
	rename 	mx8e036					penatvty152
	rename  mx8e069					penatvty211
	rename 	mx8e014					penatvty102
	rename 	mx8e058					penatvty202
	rename  mx8e022					penatvty116
	rename  mx8e042					penatvty150
	rename  mx8e081					penatvty216
	rename	mx8e018					penatvty126
	rename	mx8e028					penatvty100
	rename  mx8e009					penatvty106
	rename  mx8e085					penatvty239
	rename	mx8e144					penatvty315
	rename 	mx8e125					penatvty323
	rename 	mx8e109					penatvty408
	rename 	mx8e029					penatvty160
	rename	mx8e156					penatvty372
	rename  mx8e043					penatvty147
	rename  mx8e133					penatvty340
	rename  mx8e011					penatvty136
	rename 	mx8e151					penatvty363
	rename  mx8e019					penatvty137
	rename	mx8e015					penatvty103
	rename  mx8e010					penatvty127
	rename	mx8e044					penatvty154
	rename	mx8e037					penatvty162
	rename	mx8e120					penatvty508
	rename 	mx8e098					penatvty407
	rename 	mx8e103					penatvty451
	rename 	mx8e128					penatvty328
	rename 	mx8e062					penatvty229
	rename	mx8e074					penatvty236
	
	*********************************************
	gen 	penatvty217=			penatvty220
	rename 	mx8e136					penatvty338 /* St. Kitts--Nevis; no espserate counting in ACS, coded as other Caribbean. Future same situation need duplicate this variable*/ 
	rename 	mx8e061 				penatvty218
	rename	mx8e104					penatvty430 /* Libya; no espserate counting in ACS, coded as northern Africa.  Future same situation need duplicate this variabl */
	rename 	mx8e077					penatvty203 /* Bhutan; no espserate counting in ACS, coded as south eastern Asian*/ 
	rename 	mx8e089					penatvty245 /* United Arab Emirates; coded as other western asia*/
	rename	mx8e114					penatvty454 /* Togo; coded as other western Africa*/
	gen 	penatvty423=			penatvty454 /* Guinea; coded as other western Africa*/
	rename	mx8e107					penatvty460 /* Zambia; coded as other southern africa*/
	rename	mx8e121					penatvty512 /* Micronesia; coded as nec Oceania */
	rename	mx8e099					penatvty412 /* Congo; coded as other middle africa*/
	gen 	penatvty425=			penatvty454 /* Ivory Coast; coded as western africa*/
	gen 	penatvty511=			penatvty512 /* Marshall Islands; nec oceania */
	rename 	mx8e012					penatvty155 /* Estonia; other northern euripe */
	rename 	mx8e055					penatvty228 /* Mongolia; other eastern asia */
	gen 	penatvty459=			penatvty412 /* Zaire; other middle Africa */
	rename 	mx8e026					penatvty168 /* Montenegro; other southern europe*/
	rename	mx8m148					penatvty369 /* Paraguay; other SOUTHERN america */
	rename 	mx8m090					penatvty249 /* Asia not specified */
	gen  	penatvty400=			penatvty430 /* Algeria; other northern africa*/
	rename	mx8e046					penatvty166 /* Europe, not specified */
	gen 	penatvty321=			penatvty338 /* Caribbean; other Caribbean */
	rename 	mx8e135					penatvty343
	rename 	mx8m115					penatvty462 /* Africa, nec*/
	gen 	penatvty165=			penatvty163 /* USSR, coded as Russia */
	rename	mx8e096					penatvty448 /* Somalis, coded as other eastern africa*/
	gen 	penatvty108=			penatvty155 /* Finland, coded as other northern europe */
	gen 	penatvty523=			penatvty512 /* Tonga, coded as nec Oceania */
	gen		penatvty453=			penatvty448 /* Tanzania, coded as other east africa */
	rename	mx8e158					penatvty374	/* South America, nec*/
	rename	mx8e106					penatvty449 /* South Africa */
	gen 	penatvty149=			penatvty148 /* Slovakia */
	gen 	penatvty130=			penatvty129 /*Azores */
	gen 	penatvty444=			penatvty454 /*Senegal */
	gen 	penatvty105=			penatvty148 /* Czechoslovakia */
	gen 	penatvty528=			penatvty512 /*Oceania nec*/
	gen		penatvty461=			penatvty449 /*Zimbabwe; coded as south africa */
	gen 	penatvty527= 			penatvty512 /* Samoa */
	rename	mx8m096					penatvty457 /* Uganda; coded as east africa*/
	gen		penatvty339=			penatvty338 /* St. Lucia; coded other Caribean */
	rename	mx8e045					penatvty161 /* Geprgia; other eastern europe */
	gen 	penatvty159=			penatvty245 /* other western asia */


	/* Check to see how many `country's of origin' in my data: 151 */

	ds penatvty*
	local num_vars : word count `r(varlist)'

	display "Number of variables starting with 'penatvty': `num_vars'"


	/* Full loop */
	
		ds penatvty*
		local country_vars `r(varlist)' 
		
		foreach var in `country_vars'  {  
			
			/* Compute percentage at the MSA level */
			
			gen p_msa_`var' = `var' / tot_pop 
			
			
			/* Compute national-level percentage */
		
			quietly sum `var'
			local nat_pop = r(sum)
			
			quietly sum tot_pop
			local nat_total = r(sum) 
			
			gen p_national_`var' = `nat_pop' / `nat_total'
	

			/* Enclave Index */	
			
			gen enclave_`var' = p_msa_`var' / p_national_`var'
	
			}


		/* drop irrelevant variable */	
		keep cbsaa tot_pop enclave_penatvty* p_msa_penatvty*
		
		/* reshape wide to long */	
		reshape long enclave_penatvty p_msa_penatvty, i(cbsaa) j(penatvty)

		gen flag_high = (p_msa_penatvty > 0.5 & p_msa_penatvty != .)
		
		rename enclave_penatvty enclave
		rename p_msa_penatvty enclave2	
		
		drop flag_high
					
					
		/* x100 for interpretation */	
			
		replace enclave = enclave * 100
		replace enclave2 = enclave2 * 100
		
		
		rename cbsaa gtcbsa
		
		*use "$DATA/intermediate/MSA_enclave-index.dta", clear
		
		destring gtcbsa, replace
		
		
		save "$DATA/intermediate/MSA_enclave-index.dta", replace
		
		

**## 1.2 Enclave index, ACS 2015-2019 CBSA (NHGIS extract nhgis0021), new CBSA codes only

clear


quietly do "$DATA/raw/nhgis0021_csv/nhgis0021_ds245_20195_cbsa.do"


* Check total US population size
*egen total_al4ze001= total(al4ze001)
*browse total_al4ze001


	rename al4ze001					tot_pop

	rename al5fe032					penatvty104
	rename al5fe016					penatvty109
	rename al5fe017					penatvty110
	rename al5fe022					penatvty116
	rename al5fe018					penatvty126
	rename al5fe040					penatvty128
	rename al5fe024					penatvty129
	rename al5fe041					penatvty132
	rename al5fe019					penatvty137
	rename al5fe008					penatvty138 /* UK */
	rename al5fe010					penatvty139 /* England */
	rename al5fe011					penatvty140 /* Scottland */
	rename al5fe043					penatvty147 /* common name Serbia */
	rename al5fe033					penatvty151
	rename al5fe038					penatvty152
	rename al5fe079					penatvty158
	rename al5fe089					penatvty159 /* Azerbaijan; other western asia */
	rename al5fe042					penatvty163
	rename al5fe044					penatvty164
	gen    penatvty165=				penatvty163
	rename al5fe058					penatvty202
	rename al5fe068					penatvty205
	rename al5fe069					penatvty206
	rename al5fe050					penatvty207
	rename al5fe051					penatvty209
	rename al5fe059					penatvty210
	rename al5fe070					penatvty211
	rename al5fe060					penatvty212
	rename al5fe080					penatvty213
	rename al5fe081					penatvty214
	rename al5fe053					penatvty215
	rename al5fe082					penatvty216
	rename al5fe054					penatvty217
	gen    penatvty220=				penatvty217
	rename al5fe083					penatvty222
	rename al5fe084					penatvty224
	rename al5fe072					penatvty226
	rename al5fe062					penatvty229
	rename al5fe063					penatvty231
	rename al5fe073					penatvty233
	rename al5fe085					penatvty235
	rename al5fe074					penatvty236
	rename al5fe086					penatvty239
	rename al5fe052					penatvty240
	rename al5fe075					penatvty242
	rename al5fe087					penatvty243
	rename al5fe076					penatvty247
	rename al5fe088					penatvty248
	rename al5fe090					penatvty249
	rename al5fe167					penatvty301
	rename al5fe150					penatvty303
	rename al5fe146					penatvty311
	rename al5fe147					penatvty312
	rename al5fe148					penatvty313
	rename al5fe149					penatvty314
	rename al5fe151					penatvty315
	rename al5fe152					penatvty316
	rename al5fe134					penatvty327
	rename al5fe137					penatvty330
	rename al5fe139					penatvty333
	rename al5fe141					penatvty341
	rename al5fe155					penatvty360
	rename al5fe156					penatvty361
	rename al5fe157					penatvty362
	rename al5fe158					penatvty363
	rename al5fe159					penatvty364
	rename al5fe160					penatvty365
	rename al5fe161					penatvty368
	rename al5fe162					penatvty370
	rename al5fe164					penatvty373
	rename al5fe106					penatvty414
	rename al5fe094					penatvty416
	rename al5fe116					penatvty429
	rename al5fe109					penatvty430 /* Libya; coded as other northern africa */
	rename al5fe107					penatvty436
	rename al5fe117					penatvty440
	rename al5fe111					penatvty449
	rename al5fe104					penatvty459 /* Zaire; coded as other middle africa */
	rename al5fe124					penatvty501
	rename al5fe128					penatvty527 /* Somoa; coded as Oceania NEC */
	
	rename al5fe014					penatvty102
	rename al5fe007					penatvty136
	rename al5fe065					penatvty246
	rename al5fe126					penatvty508
	gen    penatvty511=				penatvty527
	gen    penatvty512=				penatvty527
	rename al5fe125					penatvty515
	gen    penatvty523=				penatvty527 
	rename al5fe029					penatvty100
	rename al5fe015					penatvty103
	rename al5fe034					penatvty105
	rename al5fe005					penatvty106
	rename al5fe012					penatvty108 /* Finland; other northern europe */
	rename al5fe035					penatvty117
	rename al5fe004					penatvty119
	rename al5fe023					penatvty120
	rename al5fe006					penatvty127
	rename al5fe025					penatvty130
	rename al5fe026					penatvty134
	gen    penatvty148= 			penatvty105
	gen    penatvty149=				penatvty105
	rename al5fe031					penatvty150
	gen penatvty154=				penatvty147
	gen penatvty155=				penatvty108 /* Estonia, other northern europe */
	rename al5fe036					penatvty156
	rename al5fe037					penatvty157
	rename al5fe030					penatvty160
	rename al5fe045					penatvty161 /* Georgia, other eastern europe */
	rename al5fe039					penatvty162
	rename al5fe046					penatvty166 /*europe, nec */
	rename al5fe027					penatvty168 /* Montenegro, other southern europe */
	rename al5fe057					penatvty200
	rename al5fe055					penatvty203 /* Bhutan, other eastern asia */
	rename al5fe061					penatvty218
	rename al5fe071					penatvty223
	gen    penatvty228=				penatvty203 /* Mongolia, other eastern asia */
	rename al5fe064					penatvty238
	gen    penatvty245=				penatvty159 /* United Arab Emirates, other western asia */
	rename al5fe145					penatvty310
	rename al5fe143					penatvty321 /* Antigua and Barbuda, other Caribbean */
	rename al5fe132					penatvty323
	rename al5fe133					penatvty324
	rename al5fe135					penatvty328
	rename al5fe136					penatvty329
	rename al5fe138					penatvty332
	gen    penatvty338=				penatvty321 /*  St. Kitts--Nevis, other Caribbean */
	gen    penatvty339= 			penatvty321 /*  St. Lucia, other Caribbean */
	rename al5fe140					penatvty340
	rename al5fe142					penatvty343
	rename al5fm165					penatvty369 /* Paraguay, other sourth america */
	rename al5fe163					penatvty372
	gen penatvty374=				penatvty369 /* South America not specified */
	gen penatvty400=				penatvty430 /* Algeria, other northern africa */
	rename al5fe101					penatvty407
	rename al5fe114					penatvty408
	rename al5fe102					penatvty412
	rename al5fe093					penatvty417
	rename al5fe115					penatvty421
	rename al5fe120					penatvty423 /* Guinea, other western africa */
	gen penatvty425=				penatvty423 /* Ivory Coast, other western africa */
	rename al5fe095					penatvty427
	gen penatvty444=				penatvty423 /* Senegal, other western africa */
	rename al5fe119					penatvty447
	rename al5fe096					penatvty448
	rename al5fe108					penatvty451
	rename al5fe099					penatvty453 /* Tanzania, other eastern africa */
	gen penatvty454=				penatvty423 /* Togo, other western africa */
	rename al5fe097					penatvty457
	gen penatvty460=				penatvty369 /* Zambia, other southern africa */
	rename al5fe098					penatvty461
	rename al5fe121					penatvty462
	gen penatvty528=				penatvty527 /* Oceania nec */ 


	/* Check to see how many `country's of origin' in my data: 80 */

	ds penatvty*
	local num_vars : word count `r(varlist)'

	display "Number of variables starting with 'penatvty': `num_vars'"


	/* Full loop */
	
		ds penatvty*
		local country_vars `r(varlist)' 
		
		foreach var in `country_vars'  {  
			
			/* Compute percentage at the MSA level */
			
			gen p_msa_`var' = `var' / tot_pop 
			
			/* Compute national-level percentage */
		
			quietly sum `var'
			local nat_pop = r(sum)
			
			quietly sum tot_pop
			local nat_total = r(sum) 
			
			gen p_national_`var' = `nat_pop' / `nat_total'
			

			/* Enclave Index */	
			
			gen enclave_`var' = p_msa_`var' / p_national_`var'
	
			}


		/* drop irrelevant variable */	
		keep cbsaa tot_pop enclave_penatvty* p_msa_penatvty*
		
		/* reshape wide to long */	
		reshape long enclave_penatvty p_msa_penatvty, i(cbsaa) j(penatvty)
		
		gen flag_high = (p_msa_penatvty > 0.5 & p_msa_penatvty != .)

		rename enclave_penatvty enclave
		rename p_msa_penatvty enclave2
		
		/* x100 for interpretation */	
			
		replace enclave = enclave * 100
		replace enclave2 = enclave2 * 100
		
		
		rename cbsaa gtcbsa
		
		*use "$DATA/intermediate/MSA_enclave-index.dta", clear
		
		destring gtcbsa, replace
		
		/* keep only new CBSA code */
		
		keep if inlist(gtcbsa, 31080, 46520, 42200, 14010, 15680, 29200) /**/
		
		drop flag_high
		
		save "$DATA/intermediate/MSA_enclave-index_2.dta", replace
		
		


**## 1.3 Enclave index, ACS 2007-2011 NECTA (NHGIS extract nhgis0022), New England NECTA codes only

/* 2007-2011 ACS NECTA estimation */


cd "$DATA/raw/nhgis0022_csv"
quietly do "nhgis0022_ds185_20115_necta.do"
cd "$HOME"
	
	
* Check total US population size
*egen total_myee001= total(myee001)
*browse total_myee001


	/* Rename penatvty variable prepare for merging */
	
	rename	myee001					tot_pop

	rename	mx8e059					penatvty210
	rename	mx8e132					penatvty333
	rename	mx8e017					penatvty110
	rename 	mx8e050					penatvty207 /*China Mainland*/
	rename	mx8e023					penatvty120
	rename 	mx8e095					penatvty427
	rename	mx8e076					penatvty247
	rename 	mx8e138					penatvty303
	rename	mx8e053					penatvty215
	rename 	mx8e142					penatvty313
	rename 	mx8e131					penatvty332
	rename 	mx8e160					penatvty301
	rename	mx8e118					penatvty501
	rename 	mx8e094					penatvty416 
	rename 	mx8e005					penatvty138
	rename	mx8e006					penatvty139
	rename	mx8e007					penatvty140
	rename 	mx8e016					penatvty109
	rename 	mx8e025					penatvty134
	rename	mx8e113 				penatvty447
	rename 	mx8e157					penatvty373
	rename 	mx8e129					penatvty329
	rename 	mx8e127					penatvty327
	rename	mx8e134					penatvty341
	rename  mx8e054					penatvty220
	rename	mx8e155					penatvty370
	rename  mx8e030					penatvty104
	rename  mx8e041					penatvty164
	rename  mx8e112					penatvty440
	rename  mx8e040					penatvty163
	rename  mx8e073					penatvty233
	rename  mx8e130					penatvty330
	rename  mx8e141					penatvty312
	rename	mx8e083					penatvty224
	rename  mx8e008					penatvty119
	rename  mx8e102					penatvty436
	rename	mx8e038					penatvty128
	rename 	mx8e101					penatvty414
	rename  mx8e068					penatvty206
	rename  mx8e110					penatvty421
	rename  mx8e145					penatvty316
	rename  mx8e072					penatvty205
	rename	mx8e051					penatvty209
	rename	mx8e034					penatvty156
	rename  mx8e143					penatvty314
	rename  mx8e148					penatvty360
	rename  mx8e088					penatvty158
	rename 	mx8e153					penatvty365
	rename  mx8e087					penatvty243
	rename  mx8e152					penatvty364
	rename  mx8e052					penatvty240
	rename	mx8e060					penatvty212
	rename  mx8e154					penatvty368
	rename	mx8e063					penatvty231
	rename 	mx8e080					penatvty214
	rename 	mx8e150					penatvty362
	rename  mx8e064					penatvty238
	rename  mx8e039					penatvty132
	rename  mx8e024					penatvty129
	rename	mx8e071					penatvty226
	rename  mx8e075					penatvty242
	rename	mx8e082					penatvty222
	rename  mx8e093					penatvty417
	rename	mx8e079					penatvty213
	rename  mx8e035					penatvty157
	rename	mx8e057					penatvty200
	rename  mx8e111					penatvty429
	rename	mx8e032					penatvty148
	rename  mx8e031					penatvty151
	rename  mx8e070					penatvty223
	rename  mx8e084					penatvty235
	rename  mx8e033					penatvty117
	rename  mx8e139					penatvty310
	rename  mx8e065					penatvty246
	rename  mx8e126					penatvty324
	rename	mx8e149					penatvty361
	rename 	mx8e140					penatvty311
	rename	mx8e119					penatvty515 /* Estimates: Oceania: Australia and New Zealand Subregion: Other Australian and Ne*/
	rename	mx8e086					penatvty248
	rename 	mx8e036					penatvty152
	rename  mx8e069					penatvty211
	rename 	mx8e014					penatvty102
	rename 	mx8e058					penatvty202
	rename  mx8e022					penatvty116
	rename  mx8e042					penatvty150
	rename  mx8e081					penatvty216
	rename	mx8e018					penatvty126
	rename	mx8e028					penatvty100
	rename  mx8e009					penatvty106
	rename  mx8e085					penatvty239
	rename	mx8e144					penatvty315
	rename 	mx8e125					penatvty323
	rename 	mx8e109					penatvty408
	rename 	mx8e029					penatvty160
	rename	mx8e156					penatvty372
	rename  mx8e043					penatvty147
	rename  mx8e133					penatvty340
	rename  mx8e011					penatvty136
	rename 	mx8e151					penatvty363
	rename  mx8e019					penatvty137
	rename	mx8e015					penatvty103
	rename  mx8e010					penatvty127
	rename	mx8e044					penatvty154
	rename	mx8e037					penatvty162
	rename	mx8e120					penatvty508
	rename 	mx8e098					penatvty407
	rename 	mx8e103					penatvty451
	rename 	mx8e128					penatvty328
	rename 	mx8e062					penatvty229
	rename	mx8e074					penatvty236
	
	*********************************************
	gen 	penatvty217=			penatvty220
	rename 	mx8e136					penatvty338 /* St. Kitts--Nevis; no espserate counting in ACS, coded as other Caribbean. Future same situation need duplicate this variable*/ 
	rename 	mx8e061 				penatvty218
	rename	mx8e104					penatvty430 /* Libya; no espserate counting in ACS, coded as northern Africa.  Future same situation need duplicate this variabl */
	rename 	mx8e077					penatvty203 /* Bhutan; no espserate counting in ACS, coded as south eastern Asian*/ 
	rename 	mx8e089					penatvty245 /* United Arab Emirates; coded as other western asia*/
	rename	mx8e114					penatvty454 /* Togo; coded as other western Africa*/
	gen 	penatvty423=			penatvty454 /* Guinea; coded as other western Africa*/
	rename	mx8e107					penatvty460 /* Zambia; coded as other southern africa*/
	rename	mx8e121					penatvty512 /* Micronesia; coded as nec Oceania */
	rename	mx8e099					penatvty412 /* Congo; coded as other middle africa*/
	gen 	penatvty425=			penatvty454 /* Ivory Coast; coded as western africa*/
	gen 	penatvty511=			penatvty512 /* Marshall Islands; nec oceania */
	rename 	mx8e012					penatvty155 /* Estonia; other northern euripe */
	rename 	mx8e055					penatvty228 /* Mongolia; other eastern asia */
	gen 	penatvty459=			penatvty412 /* Zaire; other middle Africa */
	rename 	mx8e026					penatvty168 /* Montenegro; other southern europe*/
	rename	mx8m148					penatvty369 /* Paraguay; other SOUTHERN america */
	rename 	mx8m090					penatvty249 /* Asia not specified */
	gen  	penatvty400=			penatvty430 /* Algeria; other northern africa*/
	rename	mx8e046					penatvty166 /* Europe, not specified */
	gen 	penatvty321=			penatvty338 /* Caribbean; other Caribbean */
	rename 	mx8e135					penatvty343
	rename 	mx8m115					penatvty462 /* Africa, nec*/
	gen 	penatvty165=			penatvty163 /* USSR, coded as Russia */
	rename	mx8e096					penatvty448 /* Somalis, coded as other eastern africa*/
	gen 	penatvty108=			penatvty155 /* Finland, coded as other northern europe */
	gen 	penatvty523=			penatvty512 /* Tonga, coded as nec Oceania */
	gen		penatvty453=			penatvty448 /* Tanzania, coded as other east africa */
	rename	mx8e158					penatvty374	/* South America, nec*/
	rename	mx8e106					penatvty449 /* South Africa */
	gen 	penatvty149=			penatvty148 /* Slovakia */
	gen 	penatvty130=			penatvty129 /*Azores */
	gen 	penatvty444=			penatvty454 /*Senegal */
	gen 	penatvty105=			penatvty148 /* Czechoslovakia */
	gen 	penatvty528=			penatvty512 /*Oceania nec*/
	gen		penatvty461=			penatvty449 /*Zimbabwe; coded as south africa */
	gen 	penatvty527= 			penatvty512 /* Samoa */
	rename	mx8m096					penatvty457 /* Uganda; coded as east africa*/
	gen		penatvty339=			penatvty338 /* St. Lucia; coded other Caribean */
	rename	mx8e045					penatvty161 /* Geprgia; other eastern europe */
	gen 	penatvty159=			penatvty245 /* other western asia */


	/* Check to see how many `country's of origin' in my data: 152 */

	ds penatvty*
	local num_vars : word count `r(varlist)'

	display "Number of variables starting with 'penatvty': `num_vars'"


	/* Full loop */
	
		ds penatvty*
		local country_vars `r(varlist)' 
		
		foreach var in `country_vars'  {  
			
			/* Compute percentage at the MSA level */
			
			gen p_msa_`var' = `var' / tot_pop 
			
			/* Compute national-level percentage */
		
			quietly sum `var'
			local nat_pop = r(sum)
			
			quietly sum tot_pop
			local nat_total = r(sum) 
			
			gen p_national_`var' = `nat_pop' / `nat_total'
			

			/* Enclave Index */	
			
			gen enclave_`var' = p_msa_`var' / p_national_`var'
	
			}


		/* drop irrelevant variable */	
		keep nectaa tot_pop enclave_penatvty* p_msa_penatvty*
		
		/* reshape wide to long */	
		reshape long enclave_penatvty p_msa_penatvty, i(nectaa) j(penatvty)
		
		gen flag_high = (p_msa_penatvty > 0.5 & p_msa_penatvty != .)

		rename enclave_penatvty enclave
		rename p_msa_penatvty enclave2
		
		
		/* x100 for interpretation */	
			
		replace enclave = enclave * 100
		replace enclave2 = enclave2 * 100
		
		
		rename nectaa gtcbsa
		
		*use "$DATA/intermediate/MSA_enclave-index.dta", clear
		
		destring gtcbsa, replace
				
		/* keep only new CBSA code */
		
		keep if inlist(gtcbsa, 71650, 77200, 71950, 73450, 75700, 72400, 72850, 79600, 76750, 78700, 77350, 78100, 70750, 76450, 70900, 74500) 
		
		drop flag_high


		save "$DATA/intermediate/MSA_enclave-index_3.dta", replace

		
		
		
**# 2. Merge enclave index onto CPS-FDIC analysis file

clear


use "$DATA/final/mergedall_binary.dta", clear


*In full sample, 28% of CBSA are not identifiable. I think I should drop the all MSA not identifiable even for us born to make sure the I'm compare apple to apple, and maybe need a balance table to show difference

tab gtcbsa, m

drop if gtcbsa == 0

/*
555 elsewhere
96 Other us island
399 americas, not specified
300	Bermuda
78	U. S. VIRGIN ISLANDS
66	GUAM
142	Northern Ireland
208	Cyprus
118 not existing in CPS code
*/

drop if inlist(penatvty, 555, 96, 399, 300, 78, 66, 142, 208, 118) & pnativ != 1

*patches for vintage OMB fips code
replace gtcbsa = 18880 if gtcbsa == 23020 & inlist(hryear4, 2011, 2013, 2015) & pnativ != 1
replace gtcbsa = 35840 if gtcbsa == 42260 & inlist(hryear4, 2011, 2013, 2015) & pnativ != 1
replace gtcbsa = 42680 if gtcbsa == 46940 & inlist(hryear4, 2011, 2013, 2015) & pnativ != 1


merge m:1 gtcbsa penatvty using "$DATA/intermediate/MSA_enclave-index.dta", update generate(_merge2)

/* 
    Result                      Number of obs
    -----------------------------------------
    Not matched                       257,855
        from master                   117,195  (_merge2==1)
        from using                    140,660  (_merge2==2)

    Matched                            18,721
        not updated                    18,721  (_merge2==3)
        missing updated                     0  (_merge2==4)
        nonmissing conflict                 0  (_merge2==5)
    -----------------------------------------


*/


drop if _merge2 == 2


merge m:1 gtcbsa penatvty using "$DATA/intermediate/MSA_enclave-index_2.dta", update generate(_merge3)


/*    

    Result                      Number of obs
    -----------------------------------------
    Not matched                       135,569
        from master                   134,786  (_merge3==1)
        from using                        783  (_merge3==2)

    Matched                             1,130
        not updated                         0  (_merge3==3)
        missing updated                 1,130  (_merge3==4)
        nonmissing conflict                 0  (_merge3==5)
    -----------------------------------------


*/


tab gtcbsa if pnativ != 1 & _merge2 == 1 & _merge3 == 1, sort nol

drop if _merge3 == 2


merge m:1 gtcbsa penatvty using "$DATA/intermediate/MSA_enclave-index_3.dta", update generate(_merge4)


/*

    Result                      Number of obs
    -----------------------------------------
    Not matched                       137,212
        from master                   135,099  (_merge4==1)
        from using                      2,113  (_merge4==2)

    Matched                               817
        not updated                         0  (_merge4==3)
        missing updated                   817  (_merge4==4)
        nonmissing conflict                 0  (_merge4==5)
    -----------------------------------------


*/


drop if _merge4 == 2
drop if pnativ != 1 & _merge2 == 1 & _merge3 == 1 & _merge4 == 1

/*(0 observations deleted!!!!)*/


save "$DATA/final/mergedall_binary-enclave.dta", replace





**# 3. Historical enclave concentration and immigrant IV analysis sample

**## 3.1 County-to-CBSA crosswalks, OMB 2003 and 2013

/* CBSA 2003 <-> County Fips corresponding file */

import excel "$DATA/raw/030606omb-cbsa-csa.xlsx", sheet("CBSAs and CSAs June 6, 2003") firstrow case(lower) allstring clear

keep cbsacode cbsatitle componentname state fips

rename fips county_fips
rename cbsacode cbsa2003

sort county_fips

replace county_fips = "12025" if county_fips == "12086"   // Miami-Dade -> Dade
replace county_fips = "35061" if county_fips == "35006"   // Cibola -> Valencia

drop if county_fips == "35061" & cbsa2003 == "24380"

isid county_fips

save "$DATA/intermediate/cbsa-county_2003.dta", replace


/* CBSA 2013 <-> County Fips corresponding file */

import excel "$DATA/raw/list1.xlsx", sheet("List 1") firstrow case(lower) allstring clear

keep cbsacode cbsatitle countycountyequivalent statename fipsstatecode fipscountycode

rename countycountyequivalent componentname 
rename statename state

gen county_fips = string(real(fipsstatecode), "%02.0f") + string(real(fipscountycode), "%03.0f")

drop fipsstatecode fipscountycode
rename cbsacode cbsa2013

sort county_fips
drop in 1/3

replace county_fips = "12025" if county_fips == "12086"   // Miami-Dade -> Dade
replace county_fips = "35061" if county_fips == "35006"   // Cibola -> Valencia

drop if county_fips == "35061" & cbsa2013 == "24380"

isid county_fips


save "$DATA/intermediate/cbsa-county_2013.dta", replace

**## 3.2 1990 Census county counts by country of origin (NHGIS)

/* Import 1990 county-level data from census, and merge foreign-born info and tot_pop info  */

import delimited "$DATA/raw/nhgis0027_csv/nhgis0027_ds123_1990_county.csv", clear 


egen tot_pop = rowtotal(e3n001-e3n009)


gen county_fips = string(statea, "%02.0f") + string(countya, "%03.0f")

keep tot_pop county_fips

save "$DATA/intermediate/nhgis0027_ds123_1990_county.dta", replace


import delimited "$DATA/raw/nhgis0027_csv/nhgis0027_ds124_1990_county.csv", clear

gen county_fips = string(statea, "%02.0f") + string(countya, "%03.0f")


save "$DATA/intermediate/nhgis0027_ds124_1990_county.dta", replace


merge 1:1 county_fips using "$DATA/intermediate/nhgis0027_ds123_1990_county.dta", nogen


	/* Rename variabe to match with CPS naming conventions */


	rename	e8o001					penatvty102 /* Austria */
	rename	e8o002					penatvty103 /* Belgium */
	rename	e8o004					penatvty106 /* Denmark */
	rename	e8o005					penatvty155 /* Estonia; 1990 separates Baltics from USSR */
	rename	e8o006					penatvty108 /* Finland */
	rename	e8o007					penatvty109 /* France */
	rename	e8o008					penatvty110 /* Germany (1990 codes 110-114) */
	rename	e8o009					penatvty116 /* Greece */
	rename	e8o010					penatvty117 /* Hungary */
	rename	e8o011					penatvty119 /* Ireland */
	rename	e8o012					penatvty120 /* Italy */
	rename	e8o013					penatvty156 /* Latvia */
	rename	e8o014					penatvty157 /* Lithuania */
	rename	e8o015					penatvty126 /* Netherlands */
	rename	e8o016					penatvty127 /* Norway */
	rename	e8o017					penatvty128 /* Poland */
	rename	e8o019					penatvty132 /* Romania */
	rename	e8o020					penatvty134 /* Spain */
	rename	e8o021					penatvty136 /* Sweden */
	rename	e8o022					penatvty137 /* Switzerland */

	rename	e8o003					penatvty105 /* Czechoslovakia; 1990 predates 1993 split */
	gen 	penatvty148=			penatvty105 /* Czech Republic */
	gen 	penatvty149=			penatvty105 /* Slovakia */
	rename	e8o018					penatvty129 /* Portugal (1990 codes 129-130, incl Azores) */
	gen 	penatvty130=			penatvty129 /* Azores */
	rename	e8o023					penatvty138 /* United Kingdom (1990 codes 138-145) */
	gen 	penatvty139=			penatvty138 /* England */
	gen 	penatvty140=			penatvty138 /* Scotland */
	rename	e8o024					penatvty147 /* Yugoslavia; 1990 predates breakup */
	gen 	penatvty150=			penatvty147 /* Bosnia & Herzegovina */
	gen 	penatvty151=			penatvty147 /* Croatia */
	gen 	penatvty152=			penatvty147 /* Macedonia */
	gen 	penatvty154=			penatvty147 /* Serbia */
	gen 	penatvty168=			penatvty147 /* Montenegro */
	rename	e8o026					penatvty165 /* Soviet Union (1990 code 180) */
	gen 	penatvty158=			penatvty165 /* Armenia */
	gen 	penatvty159=			penatvty165 /* Azerbaijan */
	gen 	penatvty160=			penatvty165 /* Belarus */
	gen 	penatvty161=			penatvty165 /* Georgia */
	gen 	penatvty162=			penatvty165 /* Moldova */
	gen 	penatvty163=			penatvty165 /* Russia */
	gen 	penatvty164=			penatvty165 /* Ukraine */
	gen 	penatvty218=			penatvty165 /* Kazakhstan; CPS files under Asia, 1990 under USSR */
	gen 	penatvty246=			penatvty165 /* Uzbekistan; CPS files under Asia, 1990 under USSR */

	rename	e8o025					penatvty100 /* Albania; no separate 1990 count, other Europe */
	gen 	penatvty104=			penatvty100 /* Bulgaria; other Europe */
	gen 	penatvty166=			penatvty100 /* Europe, not specified */

	rename	e8o027					penatvty200 /* Afghanistan */
	rename	e8o028					penatvty205 /* Myanmar (Burma) */
	rename	e8o029					penatvty206 /* Cambodia */
	rename	e8o030					penatvty207 /* China */
	rename	e8o031					penatvty209 /* Hong Kong */
	rename	e8o032					penatvty210 /* India */
	rename	e8o033					penatvty211 /* Indonesia */
	rename	e8o034					penatvty212 /* Iran */
	rename	e8o035					penatvty213 /* Iraq */
	rename	e8o036					penatvty214 /* Israel */
	rename	e8o037					penatvty215 /* Japan */
	rename	e8o038					penatvty216 /* Jordan */
	rename	e8o040					penatvty223 /* Laos */
	rename	e8o041					penatvty224 /* Lebanon */
	rename	e8o042					penatvty226 /* Malaysia */
	rename	e8o043					penatvty231 /* Pakistan */
	rename	e8o044					penatvty233 /* Philippines */
	rename	e8o045					penatvty235 /* Saudi Arabia */
	rename	e8o046					penatvty239 /* Syria */
	rename	e8o047					penatvty240 /* Taiwan */
	rename	e8o048					penatvty242 /* Thailand */
	rename	e8o049					penatvty243 /* Turkey */
	rename	e8o050					penatvty247 /* Vietnam */


	rename	e8o039					penatvty217 /* Korea (1990 codes 217-219) */
	gen 	penatvty220=			penatvty217 /* South Korea */


	rename	e8o051					penatvty202 /* Bangladesh; no separate 1990 count, other Asia */
	gen 	penatvty203=			penatvty202 /* Bhutan */
	gen 	penatvty222=			penatvty202 /* Kuwait */
	gen 	penatvty228=			penatvty202 /* Mongolia */
	gen 	penatvty229=			penatvty202 /* Nepal */
	gen 	penatvty236=			penatvty202 /* Singapore */
	gen 	penatvty238=			penatvty202 /* Sri Lanka */
	gen 	penatvty245=			penatvty202 /* United Arab Emirates */
	gen 	penatvty248=			penatvty202 /* Yemen */
	gen 	penatvty249=			penatvty202 /* Asia, not specified */


	rename	e8o052					penatvty301 /* Canada */
	rename	e8o053					penatvty303 /* Mexico */
	rename	e8o054					penatvty321 /* Antigua and Barbuda */
	rename	e8o055					penatvty323 /* Bahamas */
	rename	e8o056					penatvty324 /* Barbados */
	rename	e8o057					penatvty327 /* Cuba */
	rename	e8o058					penatvty329 /* Dominican Republic */
	rename	e8o059					penatvty330 /* Grenada */
	rename	e8o060					penatvty332 /* Haiti */
	rename	e8o061					penatvty333 /* Jamaica */
	rename	e8o062					penatvty341 /* Trinidad and Tobago */
	rename	e8o064					penatvty310 /* Belize */
	rename	e8o065					penatvty311 /* Costa Rica */
	rename	e8o066					penatvty312 /* El Salvador */
	rename	e8o067					penatvty313 /* Guatemala */
	rename	e8o068					penatvty314 /* Honduras */
	rename	e8o069					penatvty315 /* Nicaragua */
	rename	e8o070					penatvty316 /* Panama */
	rename	e8o073					penatvty360 /* Argentina */
	rename	e8o074					penatvty361 /* Bolivia */
	rename	e8o075					penatvty362 /* Brazil */
	rename	e8o076					penatvty363 /* Chile */
	rename	e8o077					penatvty364 /* Colombia; CPS label spells "Columbia" */
	rename	e8o078					penatvty365 /* Ecuador */
	rename	e8o079					penatvty368 /* Guyana */
	rename	e8o080					penatvty370 /* Peru */
	rename	e8o081					penatvty372 /* Uruguay */
	rename	e8o082					penatvty373 /* Venezuela */


	rename	e8o063					penatvty328 /* Dominica; no separate 1990 count, other Caribbean */
	gen 	penatvty338=			penatvty328 /* St. Kitts--Nevis */
	gen 	penatvty339=			penatvty328 /* St. Lucia */
	gen 	penatvty340=			penatvty328 /* St. Vincent and the Grenadines */
	gen 	penatvty343=			penatvty328 /* West Indies, not specified */
	rename	e8o083					penatvty369 /* Paraguay; other South America */
	gen 	penatvty374=			penatvty369 /* South America, not specified */


	rename	e8o084					penatvty408 /* Cape Verde */
	rename	e8o085					penatvty414 /* Egypt */
	rename	e8o087					penatvty421 /* Ghana */
	rename	e8o088					penatvty427 /* Kenya */
	rename	e8o089					penatvty436 /* Morocco */
	rename	e8o090					penatvty440 /* Nigeria */
	rename	e8o091					penatvty444 /* Senegal */
	rename	e8o092					penatvty449 /* South Africa */


	rename	e8o086					penatvty416 /* Ethiopia; 1990 predates 1993 Eritrean independence */
	gen 	penatvty417=			penatvty416 /* Eritrea */


	rename	e8o093					penatvty400 /* Algeria; no separate 1990 count, other Africa */
	gen 	penatvty407=			penatvty400 /* Cameroon */
	gen 	penatvty412=			penatvty400 /* Congo */
	gen 	penatvty423=			penatvty400 /* Guinea */
	gen 	penatvty425=			penatvty400 /* Ivory Coast */
	gen 	penatvty429=			penatvty400 /* Liberia */
	gen 	penatvty430=			penatvty400 /* Libya */
	gen 	penatvty447=			penatvty400 /* Sierra Leone */
	gen 	penatvty448=			penatvty400 /* Somalia */
	gen 	penatvty451=			penatvty400 /* Sudan */
	gen 	penatvty453=			penatvty400 /* Tanzania */
	gen 	penatvty454=			penatvty400 /* Togo */
	gen 	penatvty457=			penatvty400 /* Uganda */
	gen 	penatvty459=			penatvty400 /* Zaire */
	gen 	penatvty460=			penatvty400 /* Zambia */
	gen 	penatvty461=			penatvty400 /* Zimbabwe */
	gen 	penatvty462=			penatvty400 /* Africa, not specified */


	rename	e8o094					penatvty501 /* Australia */
	rename	e8o095					penatvty508 /* Fiji */
	rename	e8o096					penatvty515 /* New Zealand */
	rename	e8o097					penatvty523 /* Tonga */
	rename	e8o098					penatvty527 /* Samoa (1990: Western Samoa) */


	rename	e8o099					penatvty511 /* Marshall Islands; no separate 1990 count, other Oceania */
	gen 	penatvty512=			penatvty511 /* Micronesia */
	gen 	penatvty528=			penatvty511 /* Oceania, not specified */

* unused residuals; drop or keep for audit
	drop	e8o071					
	drop	e8o072					
	drop	e8o100					


save "$DATA/intermediate/enclaveIV_share-1990_county.dta", replace

**## 3.3 Aggregate to CBSA, compute 1990 enclave concentration

/* Merge CBSA and County corresponding file by year */


use "$DATA/intermediate/enclaveIV_share-1990_county.dta", clear
merge 1:1 county_fips using "$DATA/intermediate/cbsa-county_2003.dta"

drop if substr(county_fips, 1, 2) == "72" & _merge == 2

drop if _merge == 2
rename _merge merge2

keep if merge2 == 3


save "$DATA/intermediate/enclaveIV_share-1990_county_2003.dta", replace


use "$DATA/intermediate/enclaveIV_share-1990_county.dta", clear
merge 1:1 county_fips using "$DATA/intermediate/cbsa-county_2013.dta"
drop if substr(county_fips, 1, 2) == "72" & _merge == 2
drop if _merge == 2
rename _merge merge3

keep if merge3 == 3

save "$DATA/intermediate/enclaveIV_share-1990_county_2013.dta", replace


/* Collapse to CBSA and historical enclave concentration construction, 2003 and 2013 seperately  */


use "$DATA/intermediate/enclaveIV_share-1990_county_2003.dta", clear

keep cbsa2003 cbsatitle tot_pop penatvty*

collapse (sum) penatvty* tot_pop, by(cbsa2003)

order cbsa2003 tot_pop penatvty*


	/* Full loop */
	
		ds penatvty*
		local country_vars `r(varlist)' 
		
		foreach var in `country_vars'  {  
			
			/* Compute percentage at the MSA level */
			
			gen p_msa_`var' = `var' / tot_pop 
			
			/* Compute national-level percentage */
		
			quietly sum `var'
			local nat_pop = r(sum)
			
			quietly sum tot_pop
			local nat_total = r(sum) 
			
			gen p_national_`var' = `nat_pop' / `nat_total'
			

			/* Enclave Index */	
			
			gen enclave_`var' = p_msa_`var' / p_national_`var'
	
			}
			
			
		/* drop irrelevant variable */	
		keep cbsa2003 tot_pop enclave_penatvty* p_msa_penatvty*
		
		/* reshape wide to long */	
		reshape long enclave_penatvty p_msa_penatvty, i(cbsa2003) j(penatvty)


		rename enclave_penatvty enclave_1990
		rename p_msa_penatvty enclave2_1990
		
	save "$DATA/intermediate/1990_share_2003.dta", replace


use "$DATA/intermediate/enclaveIV_share-1990_county_2013.dta", clear

keep cbsa2013 cbsatitle tot_pop penatvty*

collapse (sum) penatvty* tot_pop, by(cbsa2013)

order cbsa2013 tot_pop penatvty*


	/* Full loop */
	
		ds penatvty*
		local country_vars `r(varlist)' 
		
		foreach var in `country_vars'  {  
			
			/* Compute percentage at the MSA level */
			
			gen p_msa_`var' = `var' / tot_pop 
			
			/* Compute national-level percentage */
		
			quietly sum `var'
			local nat_pop = r(sum)
			
			quietly sum tot_pop
			local nat_total = r(sum) 
			
			gen p_national_`var' = `nat_pop' / `nat_total'
			

			/* Enclave Index */	
			
			gen enclave_`var' = p_msa_`var' / p_national_`var'
	
			}
			
			
		/* drop irrelevant variable */	
		keep cbsa2013 tot_pop enclave_penatvty* p_msa_penatvty*
		
		/* reshape wide to long */	
		reshape long enclave_penatvty p_msa_penatvty, i(cbsa2013) j(penatvty)


		rename enclave_penatvty enclave_1990
		rename p_msa_penatvty enclave2_1990
		
	save "$DATA/intermediate/1990_share_2013.dta", replace
	
	
	

**## 3.4 Immigrant IV sample
clear

use "$DATA/final/mergedall_binary-enclave.dta",clear


foreach var in huse12pdl huse12pwn huse12rto huse12ral {
    replace `var' = . if `var' == -1 | `var' == 99
	drop if `var' == .
}

foreach var in huse12cc huse12mo huse12rm {
    replace `var' = . if `var' == -1 | `var' == 99
	drop if `var' == .
}


#delimit;
	
	/* Prepare outcome variables */
	
	gen unbanked_100 = 100 if unbanked == 1;
	replace unbanked_100 = 0 if unbanked != 1;
	*gen underbanked100 = 100 if underbanked == 1;
	*replace underbanked100 = 0 if underbanked != 1;
	
	gen credit_afs_100 = .;
	replace credit_afs_100 = 100 if huse12pdl == 1 | huse12pwn == 1 | huse12rto == 1 | huse12ral == 1;
	replace credit_afs_100 = 0 if huse12pdl == 2 & huse12pwn == 2 & huse12rto == 2 & huse12ral == 2;
	
	gen dome_tran_afs_100 = .;
	replace dome_tran_afs_100 = 100 if huse12cc == 1 | huse12mo == 1;
	replace dome_tran_afs_100 = 0 if huse12cc == 2 & huse12mo == 2;
	
	gen remittance_100 = 100 if huse12rm == 1;
	replace remittance_100 = 0 if huse12rm == 2;
	
	foreach var in unbanked_100 credit_afs_100 dome_tran_afs_100 remittance_100 {;
		drop if missing(`var');
	};

	foreach var in penatvty prinusyr gtcbsa {;
		drop if missing(`var');
	};
		

	/* Set controls */
	local controlvarlist pagegrp1 pagegrp2 pagegrp3 pagegrp4 pagegrp5 pagegrp6 praceeth2_4 pempstat1 pempstat2 pempstat3 peducgrp_1 peducgrp_2 peducgrp_3 peducgrp_4 hhtype1 hhtype2 hhtype3 hhtype4 hhtype5 hhtype6 hhincome_1 hhincome_2 hhincome_3 hhincome_4 hhincome_5;
	
	/* Drop observations missing values for controls */
	foreach var of local controlvarlist {;
		drop if missing(`var');
	};
	
	drop if pnativ == 1;
	
	#delimit cr


gen cbsa = gtcbsa

* New England NECTA -> county-based CBSA
replace cbsa = 12620 if gtcbsa==70750    // Bangor, ME
replace cbsa = 12700 if gtcbsa==70900    // Barnstable, MA
replace cbsa = 14460 if gtcbsa==71650    // Boston
replace cbsa = 14860 if gtcbsa==71950    // Bridgeport-Stamford-Norwalk
replace cbsa = 15540 if gtcbsa==72400    // Burlington, VT
replace cbsa = 14860 if gtcbsa==72850    // Danbury -> Bridgeport CBSA (Fairfield County)
replace cbsa = 25540 if gtcbsa==73450    // Hartford
replace cbsa = 49340 if gtcbsa==74500    // Leominster-Fitchburg-Gardner -> Worcester CBSA
replace cbsa = 35300 if gtcbsa==75700    // New Haven
replace cbsa = 35980 if gtcbsa==76450    // Norwich-New London
replace cbsa = 38860 if gtcbsa==76750    // Portland, ME
replace cbsa = 39300 if gtcbsa==77200    // Providence
replace cbsa = 40100 if gtcbsa==77350    // Rochester-Dover, NH-ME  [VERIFY]
replace cbsa = 44140 if gtcbsa==78100    // Springfield, MA
replace cbsa = 35300 if gtcbsa==78700    // Waterbury -> New Haven CBSA (New Haven County)
replace cbsa = 49340 if gtcbsa==79600    // Worcester, MA

count if inrange(cbsa,70000,79999)

* CBSA phase-out patch (same fix as ACS-enclave merge)
replace cbsa = 18880 if cbsa == 23020
replace cbsa = 35840 if cbsa == 42260
replace cbsa = 42680 if cbsa == 46940


* split early waves (2003 CBSA vintage)
preserve
keep if inlist(hryear4, 2011, 2013)


replace cbsa = 23020 if cbsa == 18880
replace cbsa = 42260 if cbsa == 35840
replace cbsa = 46940 if cbsa == 42680


gen cbsa2003 = string(cbsa, "%05.0f")        

merge m:1 penatvty cbsa2003 using "$DATA/intermediate/1990_share_2003.dta"
rename _merge merge5
tab merge5
tab cbsa2003 if merge5 == 1                   // inspect unmatched NSUUH persons

drop if merge5==2        
                     
rename cbsa2003 cbsa_early                   
save "$DATA/intermediate/enclaveIV_early.dta", replace
restore


* CBSA phase-out issue

replace cbsa = 31080 if cbsa==31100    // Los Angeles: 31100 -> 31080
replace cbsa = 14010 if cbsa==14060    // Bloomington-Normal IL: 14060 -> 14010
replace cbsa = 42200 if cbsa==42060    // Santa Barbara: 42060 -> 42200
replace cbsa = 46520 if cbsa==26180    // Honolulu: 26180 -> 46520


* CBSA phase-out patch (same fix as ACS-enclave merge)
replace cbsa = 18880 if cbsa == 23020
replace cbsa = 35840 if cbsa == 42260
replace cbsa = 42680 if cbsa == 46940


* split late waves (2013 CBSA vintage)
preserve
keep if inlist(hryear4, 2015, 2017, 2019)

gen cbsa2013 = string(cbsa, "%05.0f")        

merge m:1 penatvty cbsa2013 using "$DATA/intermediate/1990_share_2013.dta"
rename _merge merge6
tab merge6
tab cbsa2013 if merge6 == 1                   // inspect unmatched NSUUH persons

drop if merge6==2 
drop if merge6==1                   

rename cbsa2013 cbsa_late                   
save "$DATA/intermediate/enclaveIV_late.dta", replace
restore

* recombine 
use "$DATA/intermediate/enclaveIV_early.dta", clear
append using "$DATA/intermediate/enclaveIV_late.dta"

replace enclave_1990 = enclave_1990*100
replace enclave2_1990 = enclave2_1990*100


	gen Z_gct = enclave2_1990
	
	sum Z_gct
	count if missing(Z_gct)
	
	*drop if prinusyr < 8
	
	xtile q2_enclave2 = enclave2, n(2)
	replace q2_enclave2 = q2_enclave2 -1 
	
	bysort q2_enclave2: sum enclave2
	
	
	xtile q2_Z_gct = Z_gct, n(2)
	replace q2_Z_gct = q2_Z_gct -1

	bysort q2_Z_gct: sum Z_gct
	
	
save "$DATA/final/enclaveIV_analysis.dta", replace
