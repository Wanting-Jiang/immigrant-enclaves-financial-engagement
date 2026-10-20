/* **************************************************************************************************************************
Author: 		Wanting Jiang
Contact: 		wjiang96@wisc.edu
Project:	 	Financial Engagement Behaviors of Immigrant Populations
Description: 	Analysis and Outputs - Descriptive Sample
Last Update:	10/20/2026

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



**# 0. Analysis sample

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



**# 1. Table 1  Summary statistics by citizenship and place of birth

use `common', clear

* Scale dummies to percent for table display
foreach var in pagegrp1 pagegrp2 pagegrp3 pagegrp4 pagegrp5 pagegrp6 praceeth2_1 praceeth2_2 praceeth2_3 praceeth2_4 praceeth2_5 pempstat1 pempstat2 pempstat3 peducgrp_1 peducgrp_2 peducgrp_3 peducgrp_4 hhtype1 hhtype2 hhtype3 hhtype4 hhtype5 hhtype6 hhincome_1 hhincome_2 hhincome_3 hhincome_4 hhincome_5 {
    replace `var' = `var' * 100
}


#delimit ;
	local statistics_list pagegrp1 pagegrp2 pagegrp3 pagegrp4 pagegrp5 pagegrp6 praceeth2_1 praceeth2_2 praceeth2_3 praceeth2_4 praceeth2_5 pempstat1 pempstat2 pempstat3 peducgrp_1 peducgrp_2 peducgrp_3 peducgrp_4 hhtype1 hhtype2 hhtype3 hhtype4 hhtype5 hhtype6 hhincome_1 hhincome_2 hhincome_3 hhincome_4 hhincome_5;

    local condition1 = "";
	local condition2 = "if pnativ == 1";
	local condition3 = "if pnativ == 2";
	local condition4 = "if pnativ == 3";
	*local condition5 = "if second_immi == 1";
	
eststo clear;

forval i=1/4 {;
	*count `condition`i'';
	*local num_subjects = string(`r(N)',"%9.0fc");
	eststo m`i': estpost tabstat `statistics_list' `condition`i'' [aw=hhsupwgt], statistics(mean sd) columns(statistics);
	*estadd local subjects "`num_subjects'";
};


quietly summarize pnativ [aw=hhsupwgt];
local wtotal = r(sum_w);
forval i = 1/3 {;
    quietly summarize pnativ [aw=hhsupwgt] if pnativ == `i';
    local share`i' = string(100 * r(sum_w) / `wtotal', "%4.1f");
};



esttab m1 m2 m3 m4

			using "$TABLES/SummaryStatFullSample.tex", replace		 
			nogap nostar numbers modelwidth(8) collabels(none)
			cells(mean(fmt(%9.2fc) star)) 
			noobs  alignment(S) fragment
			label
			nonote substitute (\_ _)
			mtitles("\specialcell{Full Sample\\ \\ }" "\specialcell{U.S.-born\\ \\ (`share1'\%)}" "\specialcell{Foreign-born\\ citizen\\ (`share2'\%)}" "\specialcell{Foreign-born\\ non-citizen\\ (`share3'\%)}")
			mgroups("" "By Citizenship and Place of Birth", pattern(0 1 0 0) 
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




**# 2. Figure 1  Banking status by citizenship and place of birth

use `common', clear

#delimit ;
	expand 2, gen(new_obs);
	replace pnativ = 0 if new_obs == 1;
	drop new_obs;
	label define pnativ 0 "Full Sample", add;
	label values pnativ pnativ;
	
	
	bysort pnativ: egen wgt_total = total(hhsupwgt);
	bysort pnativ: egen count_1 = total((hbankstatv2 == 1) * hhsupwgt);
	bysort pnativ: egen count_2 = total((hbankstatv2 == 2) * hhsupwgt);
	bysort pnativ: egen count_3 = total((hbankstatv2 == 3) * hhsupwgt);

	bysort pnativ: replace count_1 = (count_1 / wgt_total) * 100;
	bysort pnativ: replace count_2 = (count_2 / wgt_total) * 100;
	bysort pnativ: replace count_3 = (count_3 / wgt_total) * 100;

	
	bysort pnativ: keep if _n == 1;


	forvalues j = 1/3 {;
		replace count_`j' = . if count_`j' == 0;
	};

	graph bar count_1 count_2 count_3,
		over(pnativ, 
			gap(*0.5) label(labsize(*0.8))
			relabel (0 "Full Sample" 2 "U.S.-Born" 3 "Foreign-born Citizen" 4 "Foreign-born Noncitizen")) 
			stack
			legend( label(1 "Unbanked")
					label(2 "Underbanked")
					label(3 "Fully banked")
				order(1 2 3)
				rows(1) symxsize(*.3) size(*.7) keygap(*0.5) rowgap(*.25) 
				symplacement(2) ring(50) position(6) subtitle("{bf:Banking Status}", size(small)))
		scheme(s2color) plotregion(style(none)) graphregion(color(white))
		blabel(bar, position(center) format(%9.1f) size(small) color(white)) 
		ylabel(0(20)100, angle(horizontal) nogrid)
		ytitle("Percent") 
		xsize(9) ysize(6);

	gr_edit plotregion1.AddLine added_lines editor 25.39758508760735 101.2093646648496 25.39758508760735 -2.034308012730804;
	gr_edit plotregion1.added_lines_new = 1;
	gr_edit plotregion1.added_lines_rec = 1;
	gr_edit plotregion1.added_lines[1].style.editstyle 
		linestyle( width( sztype(relative) val(.2) allow_pct(1)) 
			color(black) pattern(solid) align(inside)) headstyle( symbol(circle) 
		linestyle( width( sztype(relative) val(.2) allow_pct(1)) 
			color(black) pattern(solid) align(inside)) fillcolor(black) 
		size( sztype(relative) val(1.52778) allow_pct(1)) angle(stdarrow) 
		symangle(zero) backsymbol(none) backline( width( sztype(relative) 
			val(.2) allow_pct(1)) color(black) pattern(solid) align(inside)) 
		backcolor(black) backsize( sztype(relative) val(0) allow_pct(1)) backangle(stdarrow) backsymangle(zero)) headpos(neither) editcopy;
	gr_edit plotregion1.added_lines[1].style.editstyle linestyle(pattern(dash)) editcopy;

	graph export "$FIGURES/bankingstatus_stacked.png", replace;
	#delimit cr;





**# 3. Table 2  Unbanked and un(der)banked by citizenship

use `common', clear

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

		foreach var in unbanked_100 underbanked_100 {;
	
		
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


		esttab m1 m2 m3 m4
		using $TABLES/Unbank_underbanked_citizenship_regression.tex, replace
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
			mgroups("Unbanked" "Un(der)banked", pattern(1 0 1 0) 
			prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}));
			

	#delimit cr;





**# 4. Table 3  Reasons for being unbanked by citizenship

use "$DATA/final/mergedall_binary.dta", clear

*drop not in the universe and not select reason
foreach var in hunbnkrm hunbnkrmv2 hunbnkrmv3 hunbnkrmv4 {
    drop if `var' == -1 | `var' == 99 | `var' == 98
}

gen unbankreason_raw = .
replace unbankreason_raw = hunbnkrm if inlist(hryear4, 2011)
replace unbankreason_raw = hunbnkrmv2 if inlist(hryear4, 2013)
replace unbankreason_raw = hunbnkrmv3 if inlist(hryear4, 2015, 2017)
replace unbankreason_raw = hunbnkrmv4 if inlist(hryear4, 2019)

labelbook hunbnkrm hunbnkrmv2 hunbnkrmv3 hunbnkrmv4

gen unbankreason = .

*id, credit, banking history
replace unbankreason = 1 if unbankreason_raw == 2 & hryear4 == 2011
replace unbankreason = 1 if unbankreason_raw == 7 & hryear4 == 2013
replace unbankreason = 1 if unbankreason_raw == 9 & inlist(hryear4, 2015, 2017, 2019)

*inconvenient hour or location
replace unbankreason = 2 if unbankreason_raw == 3 & hryear4 == 2011
replace unbankreason = 2 if unbankreason_raw == 1 & hryear4 == 2013
replace unbankreason = 2 if unbankreason_raw == 1 & inlist(hryear4, 2015, 2017, 2019)
replace unbankreason = 2 if unbankreason_raw == 2 & inlist(hryear4, 2015, 2017, 2019)

*fee too high/unpredictable
replace unbankreason = 3 if unbankreason_raw == 4 & hryear4 == 2011
replace unbankreason = 3 if unbankreason_raw == 2 & hryear4 == 2013
replace unbankreason = 3 if unbankreason_raw == 3 & inlist(hryear4, 2015, 2017, 2019)
replace unbankreason = 3 if unbankreason_raw == 4 & inlist(hryear4, 2015, 2017, 2019)

*not offer needed product
replace unbankreason = 4 if unbankreason_raw == 5 & hryear4 == 2011
replace unbankreason = 4 if unbankreason_raw == 3 & hryear4 == 2013
replace unbankreason = 4 if unbankreason_raw == 5 & inlist(hryear4, 2015, 2017, 2019)

*not like dealing with/trust bank
replace unbankreason = 5 if unbankreason_raw == 6 & hryear4 == 2011
replace unbankreason = 5 if unbankreason_raw == 4 & hryear4 == 2013
replace unbankreason = 5 if unbankreason_raw == 6 & inlist(hryear4, 2015, 2017, 2019)

*not have enough money
replace unbankreason = 6 if unbankreason_raw == 7 & hryear4 == 2011
replace unbankreason = 6 if unbankreason_raw == 5 & hryear4 == 2013
replace unbankreason = 6 if unbankreason_raw == 7 & inlist(hryear4, 2015, 2017, 2019)

*privacy- this quetsion not included in year 2011
replace unbankreason = 7 if unbankreason_raw == 6 & hryear4 == 2013
replace unbankreason = 7 if unbankreason_raw == 8 &inlist(hryear4, 2015, 2017, 2019)

*do not need or want account- only in 2011 but so many people selected 22.11%, so that seperated from other
replace unbankreason = 8 if unbankreason_raw == 9 & hryear4 == 2011

*other + only on year 1 and little selected
replace unbankreason = 9 if unbankreason_raw == 10 & hryear4 == 2011
replace unbankreason = 9 if unbankreason_raw == 8 & hryear4 == 2013
replace unbankreason = 9 if unbankreason_raw == 10 & inlist(hryear4, 2015, 2017, 2019)
replace unbankreason = 9 if unbankreason_raw == 1 & hryear4 == 2011
replace unbankreason = 9 if unbankreason_raw == 8 & hryear4 == 2011


*gen dummies

forvalues i = 1/9 {
    gen unbankreason_`i' = 100 * (unbankreason == `i')
}


#delimit ;

	local statistics_list unbankreason_2 unbankreason_5 unbankreason_4 unbankreason_7 unbankreason_3 unbankreason_6 unbankreason_1 unbankreason_8 unbankreason_9;
	
	*local condition1 = "";
	local condition2 = "if pnativ == 1";
	local condition3 = "if pnativ == 2";
	local condition4 = "if pnativ == 3";
	
eststo clear;
	
forval i=2/4{;
	*count `condition`i'';
	*local num_subjects = string(`r(N)',"%9.0fc");
	eststo m`i': estpost tabstat `statistics_list' `condition`i'', statistics(mean) columns(statistics);
	*estadd local subjects "`num_subjects'";
};

/* **************************************************************************************************
	Run t-test 
*************************************************************************************************** */

count;
local num_subjects = string(`r(N)',"%9.0fc");

eststo m5: estpost ttest `statistics_list' if inlist(pnativ,1,2), by(pnativ);

	matrix mean = e(b);
	estadd matrix mean;
	
	matrix SE = e(se);
	estadd matrix SE;

eststo m6: estpost ttest `statistics_list' if inlist(pnativ,1,3), by(pnativ);

	matrix mean = e(b);
	estadd matrix mean;

	matrix SE = e(se);
	estadd matrix SE;


eststo m7: estpost ttest `statistics_list' if inlist(pnativ,2,3), by(pnativ);

	matrix mean = e(b);
	estadd matrix mean;

	matrix SE = e(se);
	estadd matrix SE;
	

esttab m2 m3 m4 m5 m6 m7

			using "$TABLES/UnbankedReasons.tex", replace		 
			nogap nostar numbers modelwidth(8) collabels(none)
			cells(mean(fmt(%9.2fc) star) SE(fmt(%9.2fc) par)) 
			noobs  alignment(S) fragment
			label
			nonote substitute (\_ _)
			mtitles("U.S.-born" "\specialcell{Foreign-born\\ citizen}" "\specialcell{Foreign-born\\ non-citizen}" "\specialcell{Difference: \\ Cond.1 vs. 2}" "\specialcell{Difference: \\ Cond.1 vs. 3}" "\specialcell{Difference: \\ Cond.2 vs. 3}")
			stats(N, labels("Number of Observations") layout("\multicolumn{1}c{@}") fmt(%9.0fc))      	
			varlabels(unbankreason_2 "\hspace{2.5mm}Inconvenient hours or locations"
						unbankreason_5 "\hspace{2.5mm}Not trust bank or dealing with bank"
						unbankreason_4 "\hspace{2.5mm}Bank does not provide needed services"
						unbankreason_7 "\hspace{2.5mm}Not use bank gives privacy"
						unbankreason_3 "\hspace{2.5mm}Account fee too high or unpredictable"
						unbankreason_6 "\hspace{2.5mm}Not have enough money"
						unbankreason_1 "ID, credit, or banking history problems"
						unbankreason_8 "Do not need an account"
						unbankreason_9 "Other reasons not listed above")
															
			refcat(unbankreason_2 "\textbf{\textit{Customer Services Reason}}" unbankreason_3 "\textbf{\textit{Economic Reasons}}", nolabel);

			
#delimit cr





**# 5. Figure 2  AFS use by citizenship, conditional on being un(der)banked

use `common', clear

#delimit ;
	drop if hbankstatv2 == 3;

	/* Prepare outcome variables */
	gen credit_afs = .;
	replace credit_afs = 1 if huse12pdl == 1 | huse12pwn == 1 | huse12rto == 1 | huse12ral == 1;
	replace credit_afs = 0 if huse12pdl != 1 & huse12pwn != 1 & huse12rto != 1 & huse12ral != 1;
	
	gen dome_tran_afs = .;
	replace dome_tran_afs = 1 if huse12cc == 1 | huse12mo == 1;
	replace dome_tran_afs = 0 if huse12cc == 2 & huse12mo == 2;
	
	gen remittance = 1 if huse12rm == 1;
	replace remittance = 0 if huse12rm == 2;
	
	gen never_afs = 1 if (credit_afs + dome_tran_afs + remittance == 0) & !missing(credit_afs, dome_tran_afs, remittance);
	replace never_afs = 0 if (credit_afs + dome_tran_afs + remittance >0) & !missing(credit_afs, dome_tran_afs, remittance);
	
	local outcomes	credit_afs	dome_tran_afs	remittance		never_afs;
	local colors 	navy 		maroon			forest_green	dkorange;
	local titles	`" "Credit AFS" "Domestic Transactional AFS" "International Remittance AFS" "Never Used" "';
	local letters	a b c d;


**## 5.1 Combined (word manuscript);

	forvalues i = 1/4 {;
		local color		: word `i' of `colors';
		local outcome 	: word `i' of `outcomes';
		local gtitle	: word `i' of `titles';
		local letter	: word `i' of `letters';
		
		preserve;
		
		expand 2, gen(new_obs);
		replace pnativ = 0 if new_obs == 1;
		drop new_obs;
		label define pnativ 0 "Full Sample", add;
		label values pnativ pnativ;
		
		bysort pnativ: egen count_1 = total((`outcome' == 1) * hhsupwgt);
		bysort pnativ: egen count_2 = total((`outcome' == 0) * hhsupwgt);
		bysort pnativ: egen sum_wgt = total(hhsupwgt);
		bysort pnativ: replace count_1 = (count_1/sum_wgt)*100;
		bysort pnativ: replace count_2 = (count_2/sum_wgt)*100;
		bysort pnativ: keep if _n == 1;
		
		forvalues j = 1/2 {;
			replace count_`j' = . if count_`j' == 0;
		};
		
			graph bar count_1,
			over(pnativ, 
				gap(*0.5) label(labsize(*0.55))
				relabel (0 "Full Sample" 2 "U.S.-Born" 3 "FBorn Citizen" 4 "FBorn Noncitizen"))
				scheme(s2color) bar(1, color(`color')) plotregion(style(none)) graphregion(color(white))
				blabel(bar, position(center) format(%9.1f) size(small) color(white)) 
				ylabel(0(10)80, angle(horizontal) nogrid)
				ytitle("Percent") 
				title("(`letter') `gtitle'", size(medsmall) color(black))
				xsize(9) ysize(6)
				name(g`i', replace);
		
			gr_edit plotregion1.AddLine added_lines editor 25.99758508760735 81.2093646648496 25.99758508760735 -2.034308012730804;
			gr_edit plotregion1.added_lines_new = 1;
			gr_edit plotregion1.added_lines_rec = 1;
			gr_edit plotregion1.added_lines[1].style.editstyle 
				linestyle( width( sztype(relative) val(.2) allow_pct(1)) 
					color(black) pattern(solid) align(inside)) headstyle( symbol(circle) 
				linestyle( width( sztype(relative) val(.2) allow_pct(1)) 
					color(black) pattern(solid) align(inside)) fillcolor(black) 
				size( sztype(relative) val(1.52778) allow_pct(1)) angle(stdarrow) 
				symangle(zero) backsymbol(none) backline( width( sztype(relative) 
					val(.2) allow_pct(1)) color(black) pattern(solid) align(inside)) 
				backcolor(black) backsize( sztype(relative) val(0) allow_pct(1)) backangle(stdarrow) backsymangle(zero)) headpos(neither) editcopy;
			gr_edit plotregion1.added_lines[1].style.editstyle linestyle(pattern(dash)) editcopy;
		
			restore;
	};
	
	graph combine g1 g2 g3 g4,
		cols(2) rows(2)
		graphregion(color(white))
		imargin(medium)
		xsize(9) ysize(6.5);
	
	graph export "$FIGURES/AFS_combined.png", replace width(2400);


**## 5.2 Four separate panels (overleaf manuscript);

	forvalues i = 1/4 {;
		local color		: word `i' of `colors';
		local outcome 	: word `i' of `outcomes';
		
		preserve;
		
		expand 2, gen(new_obs);
		replace pnativ = 0 if new_obs == 1;
		drop new_obs;
		label define pnativ 0 "Full Sample", add;
		label values pnativ pnativ;
		
		bysort pnativ: egen count_1 = total((`outcome' == 1) * hhsupwgt);
		bysort pnativ: egen count_2 = total((`outcome' == 0) * hhsupwgt);
		bysort pnativ: egen sum_wgt = total(hhsupwgt);
		bysort pnativ: replace count_1 = (count_1/sum_wgt)*100;
		bysort pnativ: replace count_2 = (count_2/sum_wgt)*100;
		bysort pnativ: keep if _n == 1;
		
		forvalues j = 1/2 {;
			replace count_`j' = . if count_`j' == 0;
		};
		
			graph bar count_1,
			over(pnativ, 
				gap(*0.5) label(labsize(*0.8))
				relabel (0 "Full Sample" 2 "U.S.-Born" 3 "Foreign-born Citizen" 4 "Foreign-born Noncitizen"))
				scheme(s2color) bar(1, color(`color')) plotregion(style(none)) graphregion(color(white))
				blabel(bar, position(center) format(%9.1f) size(small) color(white)) 
				ylabel(0(10)80, angle(horizontal) nogrid)
				ytitle("Percent") 
				xsize(9) ysize(6);
		
			gr_edit plotregion1.AddLine added_lines editor 25.99758508760735 81.2093646648496 25.99758508760735 -2.034308012730804;
			gr_edit plotregion1.added_lines_new = 1;
			gr_edit plotregion1.added_lines_rec = 1;
			gr_edit plotregion1.added_lines[1].style.editstyle 
				linestyle( width( sztype(relative) val(.2) allow_pct(1)) 
					color(black) pattern(solid) align(inside)) headstyle( symbol(circle) 
				linestyle( width( sztype(relative) val(.2) allow_pct(1)) 
					color(black) pattern(solid) align(inside)) fillcolor(black) 
				size( sztype(relative) val(1.52778) allow_pct(1)) angle(stdarrow) 
				symangle(zero) backsymbol(none) backline( width( sztype(relative) 
					val(.2) allow_pct(1)) color(black) pattern(solid) align(inside)) 
				backcolor(black) backsize( sztype(relative) val(0) allow_pct(1)) backangle(stdarrow) backsymangle(zero)) headpos(neither) editcopy;
			gr_edit plotregion1.added_lines[1].style.editstyle linestyle(pattern(dash)) editcopy;
		
			graph export "$FIGURES/AFS_cond_un_underbanked_`i'.png", replace;
			
			restore;
	};

#delimit cr





**# 6. Table 4  AFS use by citizenship

use `common', clear

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

		foreach var in credit_afs_100 dome_tran_afs_100  remittance_100 {;
		
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


		esttab m1 m2 m3 m4 m5 m6
		using $TABLES/AFS_citizenship_regression.tex, replace
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
			mgroups("Credit AFS" "\specialcell{Domestic \\ Transactional AFS}" "Remittances AFS", pattern(1 0 1 0 1 0) 
			prefix(\multicolumn{@span}{c}{) suffix(}) span erepeat(\cmidrule(lr){@span}));
			

	#delimit cr;
