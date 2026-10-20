/* **************************************************************************************************************************
Author: 		Wanting Jiang
Contact: 		wjiang96@wisc.edu
Project:	 	Financial Engagement Behaviors of Immigrant Populations
Description: 	Appendix- Figures and Tables
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
 




**# 1. Analysis sample- Descriptive

use "$DATA/final/mergedall_binary.dta", clear

* Recode AFS use: -1 (NIU) and 99 (unknown) to missing
foreach var in huse12pdl huse12pwn huse12rto huse12ral huse12cc huse12mo huse12rm {
    replace `var' = . if `var' == -1 | `var' == 99
}

drop if penatvty == 208

* Outcome variables, scaled by 100
gen unbanked_100 = 100 if unbanked == 1
replace unbanked_100 = 0 if unbanked != 1

gen underbanked_100 = 100 if hbankstatv2 == 2 | hbankstatv2 == 1
replace underbanked_100 = 0 if hbankstatv2 == 3

gen credit_afs_100 = .
replace credit_afs_100 = 100 if huse12pdl == 1 | huse12pwn == 1 | huse12rto == 1 | huse12ral == 1
replace credit_afs_100 = 0 if huse12pdl == 2 & huse12pwn == 2 & huse12rto == 2 & huse12ral == 2

gen dome_tran_afs_100 = .
replace dome_tran_afs_100 = 100 if huse12cc == 1 | huse12mo == 1
replace dome_tran_afs_100 = 0 if huse12cc == 2 & huse12mo == 2

gen remittance_100 = 100 if huse12rm == 1
replace remittance_100 = 0 if huse12rm == 2

foreach var in unbanked_100 credit_afs_100 dome_tran_afs_100 remittance_100 underbanked_100 {
    drop if missing(`var')
}

foreach var in penatvty prinusyr gtcbsa {
    drop if missing(`var')
}



* Controls
local controlvarlist prtage praceeth2_1 praceeth2_2 praceeth2_3 praceeth2_4 praceeth2_5 pempstat1 pempstat2 pempstat3 peducgrp_1 peducgrp_2 peducgrp_3 peducgrp_4 hhtype1 hhtype2 hhtype3 hhtype4 hhtype5 hhtype6 hhincome_1 hhincome_2 hhincome_3 hhincome_4 hhincome_5

foreach var of local controlvarlist {
    drop if missing(`var')
}

* Drop countries of origin with a single observation (singletons)
drop if penatvty == 208
drop if penatvty == 69

count
tempfile common
save `common'




**## 1.1 Table A.1  Four financial engagement outcomes, single-headed households

use `common', clear

keep if hhtype4 == 1 | hhtype5 == 1

#delimit;
	eststo clear;

	local demo = "Y";
	local dor = "Y";
	local coo = "Y";
	local msa = "Y";
	
	/*indicates that the native-born categories of this variable will be omitted in the analysis*/
	char pnativ[omit] 1;
	local count = 1;

	local condition1 = "if pnativ == 2";
	local condition2 = "if pnativ == 3";

		foreach var in unbanked_100 credit_afs_100 dome_tran_afs_100 remittance_100 {;
		
		quietly xi: reg `var' i.pnativ [pweight = hhsupwgt];
		eststo m`count';
		quietly estadd local demo_fes "";
		quietly estadd local dor_fes "";
		quietly estadd local coo_fes "";
		quietly estadd local msa_fes "";

		local ++count;

		quietly xi: reghdfe `var' i.pnativ `controlvarlist' [pweight = hhsupwgt], vce(robust) a(hryear4 penatvty prinusyr gtcbsa);
		eststo m`count';
		quietly estadd local demo_fes "`demo'";
		quietly estadd local dor_fes "`dor'";
		quietly estadd local coo_fes "`coo'";
		quietly estadd local msa_fes "`msa'";

		local ++count;
		
	};


		esttab m1 m2 m3 m4 m5 m6 m7 m8
		using $TABLES/robust_single-hh_4engagement_citizenship_regression.tex, replace
		nogaps nodep nomtitles modelwidth(5) varwidth(9) width(\textwidth) se(2) b(%7.2fc) 
		obslast booktabs alignment(S) 
		nonote fragment star(* 0.10 ** 0.05 *** 0.01)
		stats(demo_fes dor_fes coo_fes msa_fes r2 N, 
			labels("Demographic Controls" "Duration of Residency" "Country of Origin" "CBSA-Level FE" "\midrule R-squared" "N") 
			layout("\multicolumn{1}c{@}""\multicolumn{1}c{@}""\multicolumn{1}c{@}""\multicolumn{1}c{@}""\multicolumn{1}c{@}""\multicolumn{1}c{@}") 
			fmt(%1.0g %1.0g %1.0g %1.0g %9.3f %9.0fc)) 
		keep(_Ipnativ_2 _Ipnativ_3 _cons) substitute (\_ _)
		varlabels(_Ipnativ_2 "Foreign Born Citizen"
					_Ipnativ_3 "Foreign Born Non-Citizen"
					_cons "\textsc{Constant}")
			mgroups("Unbanked" "Credit AFS" "\specialcell{Domestic \\ Transactional AFS}" "Remittances AFS", pattern(1 0 1 0 1 0 1 0) 
			prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}));
			

	#delimit cr;

**## 1.2 Table A.2  Financial engagement by citizenship and occupation type

use `common', clear

drop if penatvty == 60
drop if penatvty == 141
drop if penatvty == 161
drop if penatvty == 425
drop if penatvty == 430
drop if penatvty == 459
drop if penatvty == 511

#delimit;
	/* Occupation groups (2010 Census occupation codes) */
	
	gen occgrp = .;
	replace occgrp = 1 if peio1ocd == -1;
	replace occgrp = 2 if inrange(peio1ocd, 10, 3540);
	replace occgrp = 3 if inrange(peio1ocd, 4700, 5940);
	replace occgrp = 4 if inrange(peio1ocd, 4000, 4250);
	replace occgrp = 5 if inrange(peio1ocd, 3600, 3955) | inrange(peio1ocd, 4300, 4650);
	replace occgrp = 6 if inrange(peio1ocd, 6005, 6130) | inrange(peio1ocd, 6200, 6940);
	replace occgrp = 7 if inrange(peio1ocd, 7000, 9750);
	tab occgrp, m;
	drop if missing(occgrp);
	
	gen byte occ_informal = inlist(occgrp, 4, 6);
	gen byte cit_x_inf = (pnativ == 2) * occ_informal;
	gen byte nc_x_inf  = (pnativ == 3) * occ_informal;
	
	/* Detailed occupation and industry FE, non-employed as own category */
	
	gen occ_fe = peio1ocd;
	replace occ_fe = 9999 if peio1ocd == -1;
	gen ind_fe = peio1icd;
	replace ind_fe = 9999 if peio1icd == -1;
	
	
	/* Set controls: employment-status dummies removed (occupation replaces them);
	   reference categories removed (praceeth2_5 peducgrp_4 hhincome_5) */
	local controlvarlist prtage praceeth2_1 praceeth2_2 praceeth2_3 praceeth2_4 
		peducgrp_1 peducgrp_2 peducgrp_3 
		hhtype1 hhtype2 hhtype3 hhtype4 hhtype5 
		hhincome_1 hhincome_2 hhincome_3 hhincome_4;
	
	/* Drop observations missing values for controls */
	foreach var of local controlvarlist {;
		drop if missing(`var');
	};
	
	drop if penatvty == 208;
	drop if penatvty == 69;
	
	
	/* Common estimation sample from the fullest specification */
	
	char pnativ[omit] 1;
	quietly xi: reghdfe unbanked_100 i.pnativ `controlvarlist' [pweight = hhsupwgt], 
		vce(robust) a(hryear4 penatvty prinusyr gtcbsa occ_fe ind_fe);
	gen byte touse_occ = e(sample);


	eststo clear;

	local demo = "Y";
	local dor = "Y";
	local coo = "Y";
	local msa = "Y";
	
	local count = 1;
	

		foreach var in unbanked_100 credit_afs_100 dome_tran_afs_100  remittance_100 {;
	
		/* (a) informal-occupation interactions */
		xi: reghdfe `var' i.pnativ occ_informal cit_x_inf nc_x_inf `controlvarlist' 
			if touse_occ [pweight = hhsupwgt], vce(robust) a(hryear4 penatvty prinusyr gtcbsa);
		eststo m`count';
		quietly summarize `var' if touse_occ & pnativ == 1 [aweight = hhsupwgt];
		quietly estadd scalar basemean = r(mean);
		quietly test cit_x_inf = nc_x_inf;
		quietly estadd scalar p_diff = r(p);
		quietly estadd local demo_fes "`demo'";
		quietly estadd local dor_fes "`dor'";
		quietly estadd local coo_fes "`coo'";
		quietly estadd local msa_fes "`msa'";
		quietly estadd local occ_fes "";
		local ++count;

		/* (b) detailed occupation and industry FE */
		xi: reghdfe `var' i.pnativ `controlvarlist' 
			if touse_occ [pweight = hhsupwgt], vce(robust) a(hryear4 penatvty prinusyr gtcbsa occ_fe ind_fe);
		eststo m`count';
		quietly summarize `var' if touse_occ & pnativ == 1 [aweight = hhsupwgt];
		quietly estadd scalar basemean = r(mean);
		quietly estadd local demo_fes "`demo'";
		quietly estadd local dor_fes "`dor'";
		quietly estadd local coo_fes "`coo'";
		quietly estadd local msa_fes "`msa'";
		quietly estadd local occ_fes "Y";
		local ++count;
	};
	

		esttab m1 m2 m3 m4 m5 m6 m7 m8
		using $TABLES/robust_occupation_4engagement_citizenship_regression.tex, replace
		nogaps nodep nomtitles varwidth(34) se(2) b(%7.2fc) 
		obslast booktabs alignment(S[table-format=-2.2]) 
		nonote fragment star(* 0.10 ** 0.05 *** 0.01)
		stats(p_diff demo_fes dor_fes coo_fes msa_fes occ_fes basemean r2 N, 
			labels("\midrule p-value: Citizen = Non-Citizen interaction" 
				"Demographic Controls" "Duration of Residency" "Country of Origin" 
				"CBSA-Level FE" "Detailed Occupation and Industry FE" 
				"\midrule Baseline Mean" "R-squared" "N") 
			layout("\multicolumn{1}{c}{@}""\multicolumn{1}{c}{@}""\multicolumn{1}{c}{@}"
				"\multicolumn{1}{c}{@}""\multicolumn{1}{c}{@}""\multicolumn{1}{c}{@}"
				"\multicolumn{1}{c}{@}""\multicolumn{1}{c}{@}""\multicolumn{1}{c}{@}") 
			fmt(%9.3f %1.0g %1.0g %1.0g %1.0g %1.0g %9.3f %9.3f %9.0fc)) 
		keep(_Ipnativ_2 _Ipnativ_3 occ_informal cit_x_inf nc_x_inf) substitute (\_ _)
		order(_Ipnativ_2 _Ipnativ_3 occ_informal cit_x_inf nc_x_inf)
		varlabels(_Ipnativ_2 "Foreign Born Citizen"
					_Ipnativ_3 "Foreign Born Non-Citizen"
					occ_informal "Informal Occupation"
					cit_x_inf "Citizen $\times$ Informal Occupation"
					nc_x_inf "Non-Citizen $\times$ Informal Occupation")
			mgroups(
			"Unbanked" "Credit AFS" "\specialcell{Domestic \\ Transactional AFS}" "Remittances AFS", pattern(1 0 1 0 1 0 1 0) 
			prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}));
			
	#delimit cr;

	
	
	
	
**# 3. Table A.3  Summary statistics for immigrants by enclave concentration

clear

use "$DATA/final/enclaveIV_analysis.dta", clear

#delimit;

local controlvarlist pagegrp2 pagegrp3 pagegrp4 pagegrp5 pagegrp6 
	praceeth2_4 pempstat2 pempstat3 
	peducgrp_4 hhtype2 hhtype3 hhtype4 hhtype5 hhtype6 
	hhincome_2 hhincome_3 hhincome_4 hhincome_5;

egen nmiss = rowmiss(unbanked_100 credit_afs_100 dome_tran_afs_100 
	remittance_100 q2_enclave2 q2_Z_gct `controlvarlist' 
	gtcbsa prinusyr hryear4 hhsupwgt);
keep if inlist(pnativ, 2, 3) & nmiss == 0;
drop nmiss;

count;

foreach var in pagegrp1 pagegrp2 pagegrp3 pagegrp4 pagegrp5 pagegrp6 praceeth2_1 praceeth2_2 praceeth2_3 praceeth2_4 praceeth2_5 pempstat1 pempstat2 pempstat3 peducgrp_1 peducgrp_2 peducgrp_3 peducgrp_4 hhtype1 hhtype2 hhtype3 hhtype4 hhtype5 hhtype6 hhincome_1 hhincome_2 hhincome_3 hhincome_4 hhincome_5 {;
    replace `var' = `var' * 100;
};

	local statistics_list pagegrp1 pagegrp2 pagegrp3 pagegrp4 pagegrp5 pagegrp6 praceeth2_1 praceeth2_2 praceeth2_3 praceeth2_4 praceeth2_5 pempstat1 pempstat2 pempstat3 peducgrp_1 peducgrp_2 peducgrp_3 peducgrp_4 hhtype1 hhtype2 hhtype3 hhtype4 hhtype5 hhtype6 hhincome_1 hhincome_2 hhincome_3 hhincome_4 hhincome_5;

    local condition1 = "";
	local condition2 = "if q2_enclave2 == 0";
	local condition3 = "if q2_enclave2 == 1";

eststo clear;

forval i=1/3 {;
	eststo m`i': estpost tabstat `statistics_list' `condition`i'' [aw=hhsupwgt], statistics(mean sd) columns(statistics);
};

esttab m1 m2 m3

			using "$TABLES/SummaryStat_Enclave.tex", replace		 
			nogap nostar numbers modelwidth(8) collabels(none)
			cells(mean(fmt(%9.2fc) star)) 
			noobs  alignment(S) fragment
			label
			nonote substitute (\_ _)
			mtitles("Full Sample" "\$<\$ Median" "\$>\$ Median")
			mgroups("" "Enclave Concentration" "", pattern(0 1 0) 
				prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}))
			stats(N, labels("Number of Participants") layout("\multicolumn{1}c{@}") fmt(%9.0fc))      	
			varlabels(pagegrp1 "\hspace{2.5mm}15 to 24 years"
						pagegrp2 "\hspace{2.5mm}25 to 34 years"
						pagegrp3 "\hspace{2.5mm}35 to 44 years"
						pagegrp4 "\hspace{2.5mm}45 to 54 years"
						pagegrp5 "\hspace{2.5mm}55 to 64 years"
						pagegrp6 "\hspace{2.5mm}65 years or more"
						praceeth2_1 "\hspace{2.5mm}Black"
						praceeth2_2 "\hspace{2.5mm}Hispanic"
						praceeth2_3 "\hspace{2.5mm}Asian"
						praceeth2_4 "\hspace{2.5mm}White"
						praceeth2_5 "\hspace{2.5mm}Other"
						pempstat1 "\hspace{2.5mm}Employed"
						pempstat2 "\hspace{2.5mm}Unemployed"
						pempstat3 "\hspace{2.5mm}Not in labor force"
						peducgrp_1 "\hspace{2.5mm}No high school diploma"
						peducgrp_2 "\hspace{2.5mm}High school diploma"
						peducgrp_3 "\hspace{2.5mm}Some college"
						peducgrp_4 "\hspace{2.5mm}College degree"
						hhtype1 "\hspace{2.5mm}Married couple"
						hhtype2 "\hspace{2.5mm}Unmarried female-headed family"
						hhtype3 "\hspace{2.5mm}Unmarried male-headed family"
						hhtype4 "\hspace{2.5mm}Female individual"
						hhtype5 "\hspace{2.5mm}Male individual"
						hhtype6 "\hspace{2.5mm}Other"				
						hhincome_1 "\hspace{2.5mm}$<$15K"
						hhincome_2 "\hspace{2.5mm}15K to 30K"
						hhincome_3 "\hspace{2.5mm}30K to 50K"
						hhincome_4 "\hspace{2.5mm}50K to 75K"
						hhincome_5 "\hspace{2.5mm}$>$75K")
						       	
	        refcat(pagegrp1 "\textbf{Age Brackets:}" praceeth2_1 "\textbf{Race/Ethnicity:}" pempstat1 "\textbf{Employment Status:}" peducgrp_1 "\textbf{Education:}" hhtype1 "\textbf{Household Type:}" hhincome_1 "\textbf{Household Income:}", nolabel);
			
#delimit cr



**# 4. Table A.4  Historical enclave concentration and 1990 bank branch exposure

#delimit ;


import delimited "$DATA/raw/ALL_1990.csv", clear stringcols(_all);

keep if usa == "1";
keep if inlist(brsertyp, "11", "12");

gen county_fips = string(real(stcntybr), "%05.0f");

* modern FIPS in re-released file to 1990-era codes used by NHGIS (Miami-Dade to Dade);
replace county_fips = "12025" if county_fips == "12086";

destring depsumbr, gen(branch_dep) ignore(",");

gen one = 1;
collapse (sum) branches = one branch_dep, by(county_fips);
tempfile br;
save `br';

foreach v in 2003 2013 {;
	use "$DATA/intermediate/enclaveIV_share-1990_county_`v'.dta", clear;
	keep county_fips cbsa`v' tot_pop;
	merge 1:1 county_fips using `br', keep(1 3) nogen;
	replace branches = 0 if missing(branches);
	replace branch_dep = 0 if missing(branch_dep);
	collapse (sum) branches branch_dep tot_pop, by(cbsa`v');
	gen branch_per10k = branches / (tot_pop/10000);
	gen dep_percap    = branch_dep / tot_pop;
	keep cbsa`v' branch_per10k dep_percap;

	* mirror the household pipeline's CBSA phase-out patches (2013 vintage only);
	rename cbsa`v' cbsa_num_tmp;
	destring cbsa_num_tmp, gen(cbsa_num) force;
	drop cbsa_num_tmp;
	if `v' == 2013 {;
		replace cbsa_num = 31080 if cbsa_num == 31100;
		replace cbsa_num = 14010 if cbsa_num == 14060;
		replace cbsa_num = 42200 if cbsa_num == 42060;
		replace cbsa_num = 46520 if cbsa_num == 26180;
		replace cbsa_num = 18880 if cbsa_num == 23020;
		replace cbsa_num = 35840 if cbsa_num == 42260;
		replace cbsa_num = 42680 if cbsa_num == 46940;
	};
	gen cbsa`v' = string(cbsa_num, "%05.0f");
	drop cbsa_num;
	* collapse again in case recodes merged two codes into one CBSA;
	collapse (mean) branch_per10k dep_percap, by(cbsa`v');

	save "$DATA/intermediate/cbsa_branch1990_v`v'.dta", replace;
};



foreach v in 2003 2013 {;

	use "$DATA/intermediate/enclaveIV_share-1990_county_`v'.dta", clear;

	* county branch density;
	merge 1:1 county_fips using `br', keep(1 3) nogen;
	replace branches = 0 if missing(branches);
	gen cnty_bp10k = branches / (tot_pop/10000);

	* long: one row per county x origin country;
	keep county_fips cbsa`v' cnty_bp10k penatvty*;
	reshape long penatvty, i(county_fips) j(ctry);
	rename penatvty gcount;

	* group's within-CBSA county weights;
	bysort ctry cbsa`v': egen gtot = total(gcount);
	gen w = gcount / gtot if gtot > 0;

	* exposure-weighted density;
	gen wbd = w * cnty_bp10k;

	collapse (sum) group_branch_exp = wbd (max) gtot, by(ctry cbsa`v');

	gen byte zero1990 = (gtot == 0);
	replace group_branch_exp = . if zero1990;

	* CBSA-average fallback for zero-1990-presence groups;
	merge m:1 cbsa`v' using "$DATA/intermediate/cbsa_branch1990_v`v'.dta",
		keepusing(branch_per10k) keep(1 3) nogen;
	replace group_branch_exp = branch_per10k if zero1990;
	drop branch_per10k;

	rename ctry penatvty;
	keep penatvty cbsa`v' group_branch_exp zero1990;
	save "$DATA/intermediate/group_branch_exposure_v`v'.dta", replace;
};



use "$DATA/final/enclaveIV_analysis.dta", clear;

gen cbsa2003 = cbsa_early;
merge m:1 penatvty cbsa2003 using "$DATA/intermediate/group_branch_exposure_v2003.dta",
	keepusing(group_branch_exp zero1990) keep(1 3) nogen;
rename group_branch_exp gbe_early;
rename zero1990 z90_early;

gen cbsa2013 = cbsa_late;
merge m:1 penatvty cbsa2013 using "$DATA/intermediate/group_branch_exposure_v2013.dta",
	keepusing(group_branch_exp zero1990) keep(1 3) nogen;
rename group_branch_exp gbe_late;
rename zero1990 z90_late;

gen group_branch_exp = cond(inlist(hryear4,2011,2013), gbe_early, gbe_late);
gen byte zero1990    = cond(inlist(hryear4,2011,2013), z90_early, z90_late);
drop gbe_early gbe_late z90_early z90_late;

gen cellcbsa = cond(inlist(hryear4,2011,2013), cbsa_early, cbsa_late);

count if missing(group_branch_exp);
tab cellcbsa if missing(group_branch_exp);
* EXPECT ZERO or near-zero;



local controlvarlist pagegrp2 pagegrp3 pagegrp4 pagegrp5 pagegrp6 
	praceeth2_4 pempstat2 pempstat3 
	peducgrp_4 hhtype2 hhtype3 hhtype4 hhtype5 hhtype6 
	hhincome_2 hhincome_3 hhincome_4 hhincome_5;

capture drop touse_A touse_B;
egen nmiss = rowmiss(unbanked_100 credit_afs_100 dome_tran_afs_100 
	remittance_100 q2_enclave2 q2_Z_gct `controlvarlist' 
	gtcbsa prinusyr hryear4 hhsupwgt);
gen byte touse_A = (pnativ == 2 & nmiss == 0);
gen byte touse_B = (pnativ == 3 & nmiss == 0);
drop nmiss;


keep if touse_A | touse_B;
gen one = 1;
collapse (mean) Z2 = q2_Z_gct group_branch_exp (max) zero1990 
	(sum) cellsize = one, by(penatvty cellcbsa hryear4);
gen byte highZ = Z2 >= .5;

eststo clear;

* (1) cross-metro margin;
reg group_branch_exp highZ [aweight = cellsize], vce(cluster cellcbsa);
eststo gbe_raw;

* (2) within-design test: CBSA and wave fixed effects;
reghdfe group_branch_exp highZ [aweight = cellsize], 
	a(cellcbsa hryear4) vce(cluster cellcbsa);
eststo gbe_fe;

* (3) robustness: exclude zero-1990-presence cells (no imputed fallback);
reghdfe group_branch_exp highZ if zero1990 == 0 [aweight = cellsize], 
	a(cellcbsa hryear4) vce(cluster cellcbsa);
eststo gbe_fe_nz;

esttab gbe_raw gbe_fe gbe_fe_nz 
	using "$TABLES/balance_groupexposure.tex", replace 
	keep(highZ) se(3) b(%9.3f) star(* 0.10 ** 0.05 *** 0.01) 
	mtitles("{Cross-metro}" "{Within-CBSA}" 
		"{\specialcell{Within-CBSA, \\ 1990-present cells}}") 
	varlabels(highZ "High Historical Enclave (Z)") 
	stats(N, labels("Cells") fmt(%9.0fc)) 
	nonote booktabs fragment alignment(S[table-format=-2.3]);

#delimit cr



**# 5. Figure A.1  Distribution of enclave concentration, immigrant sample
*  Sample: IV estimation sample (touse_A | touse_B), matching Tables 5-7

set scheme lean2

use "$DATA/final/enclaveIV_analysis.dta", clear

local controlvarlist pagegrp2 pagegrp3 pagegrp4 pagegrp5 pagegrp6 praceeth2_4 pempstat2 pempstat3 peducgrp_4 hhtype2 hhtype3 hhtype4 hhtype5 hhtype6 hhincome_2 hhincome_3 hhincome_4 hhincome_5

egen nmiss = rowmiss(unbanked_100 credit_afs_100 dome_tran_afs_100 remittance_100 q2_enclave2 q2_Z_gct `controlvarlist' gtcbsa prinusyr hryear4 hhsupwgt)

keep if inlist(pnativ, 2, 3) & nmiss == 0

drop nmiss

count

_pctile enclave2, p(50 75)
local p50 = r(r1)
local p75 = r(r2)
local p50_lbl : display %4.2f `p50'
local p75_lbl : display %4.2f `p75'

twoway (histogram enclave2, ///
		width(0.5) fraction lcolor(black) lwidth(vthin)), ///
		graphregion(fcolor(white) ifcolor(white)) ylabel(,nogrid) ///
		xtitle("Enclave Concentration (%) ") xscale(titlegap(*5)) ///
		ylabel(0(0.1)0.5, angle(horizontal) labsize(small)) ///
		xlabel(0(1)30, labsize(small)) ///
		ytitle(Fraction of Households) ///
		xline(`p50', lpattern(dash) lcolor(black%30)) ///
		xline(`p75', lpattern(dash) lcolor(black%30)) ///
		text(0.4 `=`p50'+1.8' "p(50)=`p50_lbl'", color(black) size(small)) ///
		text(0.45 `=`p75'+2' "p(75)=`p75_lbl'", color(black) size(small))

graph export "$FIGURES/f_enclave_concentration_distrib.png", replace




**# 6. Table A.5 robustness/sensitivity check of 2SLS estimates to continuous enclave measures

use "$DATA/final/enclaveIV_analysis.dta", clear

#delimit ;

local controlvarlist pagegrp2 pagegrp3 pagegrp4 pagegrp5 pagegrp6 
	praceeth2_4 pempstat2 pempstat3 
	peducgrp_4 hhtype2 hhtype3 hhtype4 hhtype5 hhtype6 
	hhincome_2 hhincome_3 hhincome_4 hhincome_5;

local outcomevars unbanked_100 credit_afs_100 dome_tran_afs_100 remittance_100;

capture drop touse_A touse_B;
egen nmiss = rowmiss(unbanked_100 credit_afs_100 dome_tran_afs_100 
	remittance_100 q2_enclave2 q2_Z_gct `controlvarlist' 
	gtcbsa prinusyr hryear4 hhsupwgt);
gen byte touse_A = (pnativ == 2 & nmiss == 0);
gen byte touse_B = (pnativ == 3 & nmiss == 0);
drop nmiss;


/* Alternative enclave measures */

* continuous, per percentage point;
gen c_enclave2 = enclave2;
gen c_Z_gct    = Z_gct;

* continuous, standardized;
quietly sum enclave2;
gen s_enclave2 = (enclave2 - r(mean)) / r(sd);
quietly sum Z_gct;
gen s_Z_gct    = (Z_gct - r(mean)) / r(sd);

label variable q2_enclave2  "Above median (baseline)";
label variable c_enclave2   "Continuous, per 1 pp";
label variable s_enclave2   "Continuous, per 1 SD";


/* 2SLS by specification and panel */

local specs q2 c s;

foreach p in A B {;

	eststo clear;

	foreach sp of local specs {;
		local count = 1;
		foreach var of local outcomevars {;
			quietly ivreghdfe `var' (`sp'_enclave2 = `sp'_Z_gct) `controlvarlist' 
				if touse_`p' [pweight = hhsupwgt],
				vce(cluster gtcbsa) a(gtcbsa hryear4 prinusyr);
			eststo `sp'_`p'`count';
			quietly estadd scalar kpf = e(widstat);
			local ++count;
		};
	};


/* Export, one block per specification, appended into one panel */

	if "`p'" == "A" {;
		local mode replace;
		local ptitle "\textbf{\textit{Panel A. Citizens}} \\ \midrule";
	};
	else {;
		local mode append;
		local ptitle "\midrule \textbf{\textit{Panel B. Non-citizens}} \\ \midrule";
	};

	local first = 1;
	foreach sp of local specs {;

		if `first' == 1 {;
			esttab `sp'_`p'1 `sp'_`p'2 `sp'_`p'3 `sp'_`p'4
				using "$TABLES/enclave_IV-sensitivity.tex", `mode'
				nogaps nodep nonumbers modelwidth(15) varwidth(28) se(3) b(%9.3fc)
				booktabs alignment(S) noobs
				nonote fragment star(* 0.10 ** 0.05 *** 0.01)
				mtitles("Unbanked" "Credit AFS" 
					"\specialcell{Domestic \\ Transactional AFS}" "Remittances")
				keep(`sp'_enclave2) label
				prehead("`ptitle'") prefoot("");
			local first = 0;
		};
		else {;
			esttab `sp'_`p'1 `sp'_`p'2 `sp'_`p'3 `sp'_`p'4
				using "$TABLES/enclave_IV-sensitivity.tex", append
				nogaps nodep nonumbers nomtitles modelwidth(15) varwidth(28) se(3) b(%9.3fc)
				booktabs alignment(S) noobs
				nonote fragment star(* 0.10 ** 0.05 *** 0.01)
				keep(`sp'_enclave2) label
				posthead("") prefoot("");
		};
	};
};

#delimit cr




**# 7. Figure A.2  2SLS estimates under stricter enclave definitions (median to 65th percentile)


use "$DATA/final/enclaveIV_analysis.dta", clear

#delimit ;

local controlvarlist pagegrp2 pagegrp3 pagegrp4 pagegrp5 pagegrp6 
	praceeth2_4 pempstat2 pempstat3 
	peducgrp_4 hhtype2 hhtype3 hhtype4 hhtype5 hhtype6 
	hhincome_2 hhincome_3 hhincome_4 hhincome_5;

local outcomevars unbanked_100 credit_afs_100 dome_tran_afs_100 remittance_100;

capture drop touse_A touse_B;
egen nmiss = rowmiss(unbanked_100 credit_afs_100 dome_tran_afs_100 
	remittance_100 q2_enclave2 q2_Z_gct `controlvarlist' 
	gtcbsa prinusyr hryear4 hhsupwgt);
gen byte touse_A = (pnativ == 2 & nmiss == 0);
gen byte touse_B = (pnativ == 3 & nmiss == 0);
drop nmiss;


/* Cutoff indicators, median to 65th percentile */

foreach p in 50 55 60 65 {;
	_pctile enclave2, p(`p');
	gen byte e`p' = enclave2 > r(r1);
	_pctile Z_gct, p(`p');
	gen byte z`p' = Z_gct > r(r1);
};


/* 2SLS at each cutoff, store coefficient and standard error */

tempfile sweep;
postfile sw str1 panel str20 outcome pctile coef se using `sweep', replace;

foreach pn in A B {;
	foreach var of local outcomevars {;
		foreach p in 50 55 60 65 {;
			quietly ivreghdfe `var' (e`p' = z`p') `controlvarlist' 
				if touse_`pn' [pweight = hhsupwgt],
				vce(cluster gtcbsa) a(gtcbsa hryear4 prinusyr);
			post sw ("`pn'") ("`var'") (`p') (_b[e`p']) (_se[e`p']);
		};
	};
};
postclose sw;


/* Plot: 2 rows (citizenship) x 4 columns (outcomes) */

use `sweep', clear;
gen lo = coef - 1.96 * se;
gen hi = coef + 1.96 * se;

local titles `" "Unbanked" "Credit AFS" "Domestic Transactional AFS" "Remittances" "';
local i = 1;

foreach pn in A B {;
	local pname = cond("`pn'" == "A", "Citizens", "Non-citizens");
	local j = 1;
	foreach var of local outcomevars {;
		local gtitle : word `j' of `titles';
		twoway (rcap hi lo pctile if panel == "`pn'" & outcome == "`var'", lcolor(gs8))
			   (scatter coef pctile if panel == "`pn'" & outcome == "`var'", 
					mcolor(navy) msymbol(circle))
			   (scatter coef pctile if panel == "`pn'" & outcome == "`var'" & pctile == 50, 
					mcolor(maroon) msymbol(diamond) msize(medlarge)),
			yline(0, lpattern(dash) lcolor(black%40))
			xlabel(50(5)65, labsize(small)) ylabel(, angle(horizontal) labsize(small) nogrid)
			xtitle("Cutoff percentile", size(small)) ytitle("")
			title("`pname': `gtitle'", size(medsmall) color(black))
			legend(off) graphregion(color(white)) plotregion(style(none))
			name(g`i', replace);
		local ++i;
		local ++j;
	};
};

graph combine g1 g2 g3 g4 g5 g6 g7 g8,
	cols(4) rows(2) graphregion(color(white)) imargin(small)
	xsize(12) ysize(6);

graph export "$FIGURES/f_enclave_cutoff_sweep.png", replace width(2400);

#delimit cr







