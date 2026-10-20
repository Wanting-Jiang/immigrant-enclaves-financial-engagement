/* **************************************************************************************************************************
Author: 		Wanting Jiang
Contact: 		wjiang96@wisc.edu
Project:	 	Financial Engagement Behaviors of Immigrant Populations
Description: 	Analysis and Outputs - Enclave Sample
Last Update:	10/13/2026

Note:			



*************************************************************************************************************************/


clear

global account = "YOUR PATH"
 
global HOME "/$account"
global DATA "/$account/YOUR FOLDER NAME"
global LOGS "/$account/YOUR FOLDER NAME"
global TABLES "/$account/YOUR FOLDER NAME"
global FIGURES "/$account/YOUR FOLDER NAME"
global DOFILES "/$account/YOUR FOLDER NAME"
 



**# 1. Table 5  First-stage and reduced-form estimates by citizenship

use "$DATA/final/enclaveIV_analysis.dta", clear

#delimit;

local controlvarlist pagegrp2 pagegrp3 pagegrp4 pagegrp5 pagegrp6 
	praceeth2_4 pempstat2 pempstat3 
	peducgrp_4 hhtype2 hhtype3 hhtype4 hhtype5 hhtype6
	hhincome_2 hhincome_3 hhincome_4 hhincome_5;

local outcomevars unbanked_100 credit_afs_100 dome_tran_afs_100 remittance_100;


*common estimation sample per panel;

capture drop touse_A touse_B;

egen nmiss = rowmiss(unbanked_100 credit_afs_100 dome_tran_afs_100 
	remittance_100 q2_enclave2 q2_Z_gct `controlvarlist' 
	gtcbsa prinusyr hryear4 hhsupwgt);

gen byte touse_A = (pnativ == 2 & nmiss == 0);
gen byte touse_B = (pnativ == 3 & nmiss == 0);
drop nmiss;


eststo clear;


*F statistics;
	quietly ivreghdfe unbanked_100 (q2_enclave2 = q2_Z_gct) `controlvarlist' if touse_A [pweight = hhsupwgt],
		vce(cluster gtcbsa) a(gtcbsa hryear4 prinusyr);
	local kpf_A = e(widstat);


		/* First stage */
		quietly reghdfe q2_enclave2 q2_Z_gct `controlvarlist' if touse_A [pweight = hhsupwgt],
			vce(cluster gtcbsa) a(gtcbsa hryear4 prinusyr);
			
		eststo fsA;
		quietly estadd scalar kpf = `kpf_A';
		quietly estadd local demo_fes "Y";
		quietly estadd local dor_fes  "Y";
		quietly estadd local msa_fes  "Y";

		/* Reduced forms */
		local rfcount = 1;
		
		foreach var of local outcomevars {;
			
			quietly reghdfe `var' q2_Z_gct `controlvarlist' if touse_A [pweight = hhsupwgt],
				vce(cluster gtcbsa) a(gtcbsa hryear4 prinusyr);
			eststo rfA`rfcount';
			quietly estadd local demo_fes "Y";
			quietly estadd local dor_fes  "Y";
			quietly estadd local msa_fes  "Y";
			
			local ++rfcount;
			
		};


*F statistics;
	quietly ivreghdfe unbanked_100 (q2_enclave2 = q2_Z_gct) `controlvarlist' if touse_B [pweight = hhsupwgt],
		vce(cluster gtcbsa) a(gtcbsa hryear4 prinusyr);
	local kpf_B = e(widstat);


		/* First stage */
		quietly reghdfe q2_enclave2 q2_Z_gct `controlvarlist' if touse_B [pweight = hhsupwgt],
			vce(cluster gtcbsa) a(gtcbsa hryear4 prinusyr);
		
		eststo fsB;
		quietly estadd scalar kpf = `kpf_B';
		quietly estadd local demo_fes "Y";
		quietly estadd local dor_fes  "Y";
		quietly estadd local msa_fes  "Y";


		/* Reduced forms */
		local rfcount = 1;
		
		foreach var of local outcomevars {;
		
			quietly reghdfe `var' q2_Z_gct `controlvarlist' if touse_B [pweight = hhsupwgt],
				vce(cluster gtcbsa) a(gtcbsa hryear4 prinusyr);
				
			eststo rfB`rfcount';
			quietly estadd local demo_fes "Y";
			quietly estadd local dor_fes  "Y";
			quietly estadd local msa_fes  "Y";
			
			local ++rfcount;
			
		};


*#delimit;

	esttab fsA rfA1 rfA2 rfA3 rfA4
			using $TABLES/enclave_IV-fs-rf.tex, replace
			nogaps nodep modelwidth(15) varwidth(25) width(\textwidth) se(3) b(%9.3fc) 
			obslast booktabs alignment(S) 
			nonote fragment star(* 0.10 ** 0.05 *** 0.01)
			mtitles("\specialcell{Contemporary \\ Enclave}" "Unbanked" "Credit AFS" 
				"\specialcell{Domestic \\ Transactional \\ AFS}" "Remittances")
			stats(demo_fes dor_fes msa_fes kpf r2 N, 
				labels("Demographic Controls" "Duration of Residency" "CBSA-Level FE" 
					"\midrule Kleibergen-Paap F" "R-squared" "N") 
				layout("\multicolumn{1}c{@}""\multicolumn{1}c{@}""\multicolumn{1}c{@}"
					"\multicolumn{1}c{@}""\multicolumn{1}c{@}""\multicolumn{1}c{@}") 
				fmt(%1.0g %1.0g %1.0g %9.1f %9.3f %9.0fc)) 
			keep(q2_Z_gct) substitute (\_ _)
			varlabels(q2_Z_gct "Historical Enclave (1990)")
			mgroups("First Stage" "Reduced Form", pattern(1 1 0 0 0)
				prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))
			prehead("\textbf{\textit{Panel A. Citizens}} \\ \midrule");

	esttab fsB rfB1 rfB2 rfB3 rfB4
			using $TABLES/enclave_IV-fs-rf.tex, append
			nogaps nodep modelwidth(15) varwidth(25) width(\textwidth) se(3) b(%9.3fc) 
			obslast booktabs alignment(S) 
			nonote fragment star(* 0.10 ** 0.05 *** 0.01)
			mtitles("\specialcell{Contemporary \\ Enclave}" "Unbanked" "Credit AFS" 
				"\specialcell{Domestic \\ Transactional \\ AFS}" "Remittances")
			stats(demo_fes dor_fes msa_fes kpf r2 N, 
				labels("Demographic Controls" "Duration of Residency" "CBSA-Level FE" 
					"\midrule Kleibergen-Paap F" "R-squared" "N") 
				layout("\multicolumn{1}c{@}""\multicolumn{1}c{@}""\multicolumn{1}c{@}"
					"\multicolumn{1}c{@}""\multicolumn{1}c{@}""\multicolumn{1}c{@}") 
				fmt(%1.0g %1.0g %1.0g %9.1f %9.3f %9.0fc)) 
			keep(q2_Z_gct) substitute (\_ _)
			varlabels(q2_Z_gct "Historical Enclave (1990)")
			mgroups("First Stage" "Reduced Form", pattern(1 1 0 0 0)
				prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))
			prehead("\midrule \textbf{\textit{Panel B. Non-citizens}} \\ \midrule");


**# 2. Table 6  Effects of enclave concentration, OLS and 2SLS by citizenship;

	eststo clear;
	local count = 1;


		foreach var of local outcomevars {;
			
			/* OLS */
			quietly reghdfe `var' q2_enclave2 `controlvarlist' if touse_A [pweight = hhsupwgt],
				vce(cluster gtcbsa) a(gtcbsa hryear4 prinusyr);

			eststo m`count';
			quietly summarize `var' if touse_A & q2_enclave2 == 0 [aweight = hhsupwgt];
			quietly estadd scalar basemean = r(mean);
			quietly estadd local demo_fes "Y";
			quietly estadd local dor_fes  "Y";
			quietly estadd local msa_fes  "Y";
			
			local ++count;

			/* 2SLS */
			quietly ivreghdfe `var' (q2_enclave2 = q2_Z_gct) `controlvarlist' if touse_A [pweight = hhsupwgt],
				vce(cluster gtcbsa) a(gtcbsa hryear4 prinusyr);

			eststo m`count';
			quietly summarize `var' if touse_A & q2_enclave2 == 0 [aweight = hhsupwgt];
			quietly estadd scalar basemean = r(mean);
			quietly estadd local demo_fes "Y";
			quietly estadd local dor_fes  "Y";
			quietly estadd local msa_fes  "Y";
			
			local ++count;

		};


		foreach var of local outcomevars {;
			
			/* OLS */
			quietly reghdfe `var' q2_enclave2 `controlvarlist' if touse_B [pweight = hhsupwgt],
				vce(cluster gtcbsa) a(gtcbsa hryear4 prinusyr);
				
			eststo m`count';
			quietly summarize `var' if touse_B & q2_enclave2 == 0 [aweight = hhsupwgt];
			quietly estadd scalar basemean = r(mean);
			quietly estadd local demo_fes "Y";
			quietly estadd local dor_fes  "Y";
			quietly estadd local msa_fes  "Y";
			
			local ++count;

			/* 2SLS */
			quietly ivreghdfe `var' (q2_enclave2 = q2_Z_gct) `controlvarlist' if touse_B [pweight = hhsupwgt],
				vce(cluster gtcbsa) a(gtcbsa hryear4 prinusyr);
			
			eststo m`count';
			quietly summarize `var' if touse_B & q2_enclave2 == 0 [aweight = hhsupwgt];
			quietly estadd scalar basemean = r(mean);
			quietly estadd local demo_fes "Y";
			quietly estadd local dor_fes  "Y";
			quietly estadd local msa_fes  "Y";
			
			local ++count;

		};


	esttab m1 m2 m3 m4 m5 m6 m7 m8
			using $TABLES/enclave_IV-regression.tex, replace
			nogaps nodep modelwidth(15) varwidth(7) width(\textwidth) se(3) b(%9.3fc) 
			obslast booktabs alignment(S) 
			nonote fragment star(* 0.10 ** 0.05 *** 0.01)
			mtitles("OLS" "2SLS" "OLS" "2SLS" "OLS" "2SLS" "OLS" "2SLS")
			stats(demo_fes dor_fes msa_fes basemean r2 N, 
				labels("Demographic Controls" "Duration of Residency" "CBSA-Level FE" 
					"\midrule Baseline Mean" "R-squared" "N") 
				layout("\multicolumn{1}c{@}""\multicolumn{1}c{@}"
					"\multicolumn{1}c{@}""\multicolumn{1}c{@}""\multicolumn{1}c{@}""\multicolumn{1}c{@}") 
				fmt(%1.0g %1.0g %1.0g %9.3f %9.3f %9.0fc)) 
			keep(q2_enclave2) substitute (\_ _)
			varlabels(q2_enclave2 "Enclave")
			mgroups("Unbanked" "Credit AFS" "\specialcell{Domestic \\ Transactional AFS}" "Remittances", 
				pattern(1 0 1 0 1 0 1 0)
				prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))
			prehead("\textbf{\textit{Panel A. Citizens}} \\ \midrule");

	esttab m9 m10 m11 m12 m13 m14 m15 m16
			using $TABLES/enclave_IV-regression.tex, append
			nogaps nodep modelwidth(15) varwidth(7) width(\textwidth) se(3) b(%9.3fc) 
			obslast booktabs alignment(S) 
			nonote fragment star(* 0.10 ** 0.05 *** 0.01)
			mtitles("OLS" "2SLS" "OLS" "2SLS" "OLS" "2SLS" "OLS" "2SLS")
			stats(demo_fes dor_fes msa_fes basemean r2 N, 
				labels("Demographic Controls" "Duration of Residency" "CBSA-Level FE" 
					"\midrule Baseline Mean" "R-squared" "N") 
				layout("\multicolumn{1}c{@}""\multicolumn{1}c{@}""\multicolumn{1}c{@}"
					"\multicolumn{1}c{@}""\multicolumn{1}c{@}""\multicolumn{1}c{@}") 
				fmt(%1.0g %1.0g %1.0g %9.3f %9.3f %9.0fc)) 
			keep(q2_enclave2) substitute (\_ _)
			varlabels(q2_enclave2 "Enclave")
			mgroups("Unbanked" "Credit AFS" "\specialcell{Domestic \\ Transactional AFS}" "Remittances", 
				pattern(1 0 1 0 1 0 1 0)
				prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))
			prehead("\midrule \textbf{\textit{Panel B. Non-citizens}} \\ \midrule");


#delimit cr




**# 3. Table 7  Partner-country placebo instrument

#delimit ;

/* 1. national 1990 sizes by origin code */

use "$DATA/intermediate/enclaveIV_share-1990_county_2013.dta", clear;

keep penatvty*;

collapse (sum) penatvty*;

gen one = 1;
reshape long penatvty, i(one) j(ctry);
rename penatvty natsize;
drop one;

gen region = 1 if inrange(ctry,100,199);
replace region = 2 if inrange(ctry,200,299);
replace region = 3 if inrange(ctry,300,399);
replace region = 4 if inrange(ctry,400,499);
replace region = 5 if inrange(ctry,500,599);

tempfile natall;
save `natall';

* partner CANDIDATES: parent codes only;
keep if inlist(ctry,102,103,106,155,108,109,110,116,117) |
	inlist(ctry,119,120,156,157,126,127,128,132,134) |
	inlist(ctry,136,137,105,129,138,147,165,100) |
	inlist(ctry,200,205,206,207,209,210,211,212,213) |
	inlist(ctry,214,215,216,223,224,226,231,233,235) |
	inlist(ctry,239,240,242,243,247,217,202) |
	inlist(ctry,301,303,321,323,324,327,329,330,332) |
	inlist(ctry,333,341,310,311,312,313,314,315,316) |
	inlist(ctry,360,361,362,363,364,365,368,370,372,373,328,369) |
	inlist(ctry,408,414,421,427,436,440,444,449,416,400) |
	inlist(ctry,501,508,515,523,527,511);
rename (ctry natsize region) (pctry pnatsize pregion);
tempfile cands;
save `cands';


/* 2. partner maps, rank 1 and rank 2 */

use `natall', clear;
cross using `cands';
keep if pregion != region;
drop if pctry == ctry;
gen gap = abs(pnatsize - natsize);
bysort ctry (gap pctry): keep if _n <= 2;
bysort ctry (gap pctry): gen rank = _n;
keep ctry pctry rank;
reshape wide pctry, i(ctry) j(rank);
rename (ctry pctry1 pctry2) (penatvty pctry_r1 pctry_r2);
save "$DATA/intermediate/partner_map2.dta", replace;

* eyeball both partners for the biggest groups;
preserve;
use `natall', clear;
rename ctry penatvty;
merge 1:1 penatvty using "$DATA/intermediate/partner_map2.dta", keep(3) nogen;
gsort -natsize;
list penatvty pctry_r1 pctry_r2 natsize in 1/15;
restore;


/* 3. partner Z files by CBSA, per vintage */

foreach v in 2003 2013 {;
	use "$DATA/intermediate/1990_share_`v'.dta", clear;
	keep cbsa`v' penatvty enclave2_1990;

	capture confirm numeric variable cbsa`v';
	if !_rc {;
		gen cbsakey = string(cbsa`v', "%05.0f");
	};
	else {;
		gen cbsakey = substr(trim(cbsa`v'), 1, 5);
	};
	drop cbsa`v';
	rename cbsakey cbsa`v';

	rename (penatvty enclave2_1990) (pctry Zpartner`v');
	keep cbsa`v' pctry Zpartner`v';
	save "$DATA/intermediate/partnerZ_`v'.dta", replace;
};


/* 4 attach BOTH placebo Z's + within-partner split */

use "$DATA/final/enclaveIV_analysis.dta", clear;
merge m:1 penatvty using "$DATA/intermediate/partner_map2.dta", keep(1 3) nogen;

gen cbsa2003 = cbsa_early;
gen cbsa2013 = cbsa_late;

foreach r in r1 r2 {;
	rename pctry_`r' pctry;
	merge m:1 pctry cbsa2003 using "$DATA/intermediate/partnerZ_2003.dta", keep(1 3) nogen;
	merge m:1 pctry cbsa2013 using "$DATA/intermediate/partnerZ_2013.dta", keep(1 3) nogen;
	gen Zpartner_`r' = cond(inlist(hryear4,2011,2013), Zpartner2003, Zpartner2013);
	drop Zpartner2003 Zpartner2013;
	rename pctry pctry_`r';

	count if missing(Zpartner_`r');
	* EXPECT ZERO;

	* within-partner median split;
	bysort pctry_`r': egen medZp_`r' = median(Zpartner_`r');
	gen byte q2_Zp_`r' = Zpartner_`r' > medZp_`r';
	drop medZp_`r';
};

* diagnostics: balance, independence from own-Z, and from each other;
tab q2_Zp_r1;
tab q2_Zp_r2;
tab q2_Z_gct q2_Zp_r1, cell;
tab q2_Z_gct q2_Zp_r2, cell;
tab q2_Zp_r1 q2_Zp_r2, cell;


/*5 estimation flags (mirror main do-file) */

local controlvarlist pagegrp2 pagegrp3 pagegrp4 pagegrp5 pagegrp6 
	praceeth2_4 pempstat2 pempstat3 
	peducgrp_4 hhtype2 hhtype3 hhtype4 hhtype5 hhtype6 
	hhincome_2 hhincome_3 hhincome_4 hhincome_5;

capture drop touse_A touse_B;
egen nmiss = rowmiss(unbanked_100 credit_afs_100 dome_tran_afs_100 
	remittance_100 q2_enclave2 q2_Z_gct q2_Zp_r1 q2_Zp_r2 
	`controlvarlist' gtcbsa prinusyr hryear4 hhsupwgt);
gen byte touse_A = (pnativ == 2 & nmiss == 0);
gen byte touse_B = (pnativ == 3 & nmiss == 0);
drop nmiss;


/* 6. reduced forms: own-origin Z, placebo rank 1, placebo rank 2 */

local outcomevars unbanked_100 credit_afs_100 dome_tran_afs_100 remittance_100;

eststo clear;
foreach p in A B {;
	local count = 1;
	foreach var of local outcomevars {;

		reghdfe `var' q2_Z_gct `controlvarlist' 
			if touse_`p' [pweight = hhsupwgt], 
			a(gtcbsa prinusyr hryear4) vce(cluster gtcbsa);
		eststo own`p'`count';
		quietly estadd local demo_fes "Y";
		quietly estadd local dor_fes  "Y";
		quietly estadd local msa_fes  "Y";

		reghdfe `var' q2_Zp_r1 `controlvarlist' 
			if touse_`p' [pweight = hhsupwgt], 
			a(gtcbsa prinusyr hryear4) vce(cluster gtcbsa);
		eststo p1`p'`count';
		quietly estadd local demo_fes "Y";
		quietly estadd local dor_fes  "Y";
		quietly estadd local msa_fes  "Y";

		reghdfe `var' q2_Zp_r2 `controlvarlist' 
			if touse_`p' [pweight = hhsupwgt], 
			a(gtcbsa prinusyr hryear4) vce(cluster gtcbsa);
		eststo p2`p'`count';
		quietly estadd local demo_fes "Y";
		quietly estadd local dor_fes  "Y";
		quietly estadd local msa_fes  "Y";

		local ++count;
	};
};


	esttab ownA1 p2A1 ownA2 p2A2 ownA3 p2A3 ownA4 p2A4
			using "$TABLES/placebo_partner_r2.tex", replace
			nogaps nodep varwidth(30) se(3) b(%9.3f)
			obslast booktabs alignment(S[table-format=-2.3])
			nonote fragment star(* 0.10 ** 0.05 *** 0.01)
			mtitles("{Own}" "{Placebo}" "{Own}" "{Placebo}"
				"{Own}" "{Placebo}" "{Own}" "{Placebo}")
			keep(q2_Z_gct q2_Zp_r2)
			varlabels(q2_Z_gct "Own-origin Z (1990)"
				q2_Zp_r2 "Partner-country Z (1990)")
			stats(demo_fes dor_fes msa_fes N,
				labels("Demographic Controls" "Duration of Residency"
					"CBSA-Level FE" "N") fmt(%1.0g %1.0g %1.0g %9.0fc)
				layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"
					"\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"))
			mgroups("Unbanked" "Credit AFS"
				"\specialcell{Domestic \\ Transactional AFS}" "Remittances",
				pattern(1 0 1 0 1 0 1 0)
				prefix(\multicolumn{@span}{c}{) suffix(}) span
				erepeat(\cmidrule(lr){@span}))
			prehead("\textbf{\textit{Panel A. Citizens}} \\ \midrule");

			
	esttab ownB1 p2B1 ownB2 p2B2 ownB3 p2B3 ownB4 p2B4
			using "$TABLES/placebo_partner_r2.tex", append
			nogaps nodep varwidth(30) se(3) b(%9.3f)
			obslast booktabs alignment(S[table-format=-2.3])
			nonote fragment star(* 0.10 ** 0.05 *** 0.01)
			mtitles("{Own}" "{Placebo}" "{Own}" "{Placebo}"
				"{Own}" "{Placebo}" "{Own}" "{Placebo}")
			keep(q2_Z_gct q2_Zp_r2)
			varlabels(q2_Z_gct "Own-origin Z (1990)"
				q2_Zp_r2 "Partner-country Z (1990)")
			stats(demo_fes dor_fes msa_fes N,
				labels("Demographic Controls" "Duration of Residency"
					"CBSA-Level FE" "N") fmt(%1.0g %1.0g %1.0g %9.0fc)
				layout("\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"
					"\multicolumn{1}{c}{@}" "\multicolumn{1}{c}{@}"))
			mgroups("Unbanked" "Credit AFS"
				"\specialcell{Domestic \\ Transactional AFS}" "Remittances",
				pattern(1 0 1 0 1 0 1 0)
				prefix(\multicolumn{@span}{c}{) suffix(}) span
				erepeat(\cmidrule(lr){@span}))
			prehead("\midrule \textbf{\textit{Panel B. Non-citizens}} \\ \midrule");

#delimit cr
