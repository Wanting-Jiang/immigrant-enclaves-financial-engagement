/* **************************************************************************************************************************
Author: 		Wanting Jiang
Contact: 		wjiang96@wisc.edu
Project:	 	Financial Engagement Behaviors of Immigrant Populations
Description: 	Data Cleaning - Descriptive Sample
Last Update:	10/12/2026

Note:			FDIC data download: https://www.fdic.gov/household-survey/data-downloads-and-resources
				CPS basic monthly data download (NBER Version): https://www.nber.org/research/data/current-population-survey-cps-basic-monthly-data
				
				Open navigator for better illustration of the cleaning flow


*************************************************************************************************************************/



clear

global account = "YOUR PATH"
 
global HOME "/$account"
global DATA "/$account/YOUR FOLDER NAME"
global LOGS "/$account/YOUR FOLDER NAME"
global TABLES "/$account/YOUR FOLDER NAME"
global FIGURES "/$account/YOUR FOLDER NAME"
global DOFILES "/$account/YOUR FOLDER NAME"
 




**# 1. Merge FDIC supplement to CPS basic monthly, wave by wave

foreach yy in 11 13 15 17 19 {

    * FDIC supplement
    clear
    set type double
    import delimited using "$DATA/raw/hh20`yy'_analys.csv", clear
    sort occurnum qstnum prpertyp
    save "$DATA/intermediate/FDIC_JUNE_`yy'.dta", replace

    * CPS basic monthly: destring IDs in memory, raw NBER file untouched
    use "$DATA/raw/cpsb20`yy'06.dta", clear
    destring occurnum qstnum hrhhid hrhhid2, replace
    sort occurnum qstnum prpertyp

    merge 1:1 occurnum qstnum prpertyp using "$DATA/intermediate/FDIC_JUNE_`yy'.dta"
    tab _merge

    save "$DATA/intermediate/merged20`yy'raw.dta", replace
}

**# 2. Append the five waves

use "$DATA/intermediate/merged2011raw.dta", clear
foreach yy in 13 15 17 19 {
    append using "$DATA/intermediate/merged20`yy'raw.dta"
}
save "$DATA/intermediate/mergedALLraw.dta", replace

**# 3. Sample restrictions

* Keep persons present in both CPS and FDIC supplement
keep if _merge == 3
drop _merge

* Drop households that did not respond to the FDIC supplement
drop if hbaseresp == 0

* Supplement respondents and banking status
drop if hsupresp == 0
drop if hbankstatv2 == 4
gen unbanked = 1 if hbankstatv2 == 1
replace unbanked = 0 if unbanked == .

**# 4. Value labels

label define hunbnkrmv4 1 "Bank hours are inconvenient" 2 "Bank locations are inconvenient" ///
    3 "Bank account fees are too high" 4 "Bank account fees are too unpredictable" ///
    5 "Banks do not offer needed products and services" 6 "Do not trust banks" ///
    7 "Do not have enough money to meet minimum balance requirements" ///
    8 "Avoiding a bank gives more privacy" ///
    9 "Personal identification, credit, or former bank account problems" ///
    10 "Other reason" 98 "Did not select a reason" -1 "NIU"
label values hunbnkrmv4 hunbnkrmv4

label define hunbnkrmv3 1 "Inconvenient hours" 2 "Inconvenient locations" ///
    3 "Account fees too high" 4 "Account fees unpredictable" ///
    5 "Banks do not offer needed products or services" 6 "Do not trust banks" ///
    7 "Do not have enough money to keep in account" ///
    8 "Avoiding bank gives more privacy" ///
    9 "ID, credit, or former bank account problems" ///
    10 "Other reason" 98 "Did not select a reason" -1 "NIU"
label values hunbnkrmv3 hunbnkrmv3

label define hunbnkrmv2 1 "Inconvenient hours or locations" ///
    2 "Account fees too high or unpredictable" ///
    3 "Banks do not offer needed products or services" ///
    4 "Do not like dealing with or do not trust banks" ///
    5 "Do not have enough money to keep in account or meet minimum balance" ///
    6 "Not using bank provides more privacy" ///
    7 "ID, credit, or banking history problems" ///
    8 "Other reason" 99 "Unknown reason" -1 "NIU"
label values hunbnkrmv2 hunbnkrmv2


label define hunbnkrm 1 "Previously had an account but the bank closed it" ///
    2 "ID, credit, or banking history problems" ///
    3 "Banks do not have convenient hours or locations" ///
    4 "Bank account fees or minimum balance requirements are too high" ///
    5 "Banks do not offer the needed products or services" ///
    6 "Do not like dealing with and/or do not trust banks" ///
    7 "Do not have enough money" ///
    8 "Do not know how to open or manage an account" ///
    9 "Do not need or want an account" ///
    10 "Other/None of the above" 99 "Unknown" -1 "NIU"
label values hunbnkrm hunbnkrm

label define hbankstatv2 1 "Unbanked" 2 "Banked: Underbanked" ///
    3 "Banked: Fully banked" 4 "Banked: Underbanked status unknown"
label values hbankstatv2 hbankstatv2

label define pnativ 1 "U.S.-born" 2 "Foreign-born citizen" 3 "Foreign-born noncitizen"
label values pnativ pnativ

label define pnativ2 1 "U.S.-born" 2 "Foreign-born"
label values pnativ2 pnativ2

cap label drop prinusyr
label variable prinusyr "Year of Entry"
label define prinusyr 0 "Not Foreign Born" 1 "Before 1950" 2 "1950-1959" ///
    3 "1960-1964" 4 "1965-1969" 5 "1970-1974" 6 "1975-1979" 7 "1980-1981" ///
    8 "1982-1983" 9 "1984-1985" 10 "1986-1987" 11 "1988-1989" 12 "1990-1991" ///
    13 "1992-1993" 14 "1994-1995" 15 "1996-1997" 16 "1998-1999" 17 "2000-2001" ///
    18 "2002-2003" 19 "2004-2005" 20 "2006-2007" 21 "2008-2009" 22 "2010-2011" ///
    23 "2012-2013" 24 "2014-2015" 25 "2016-2019"
label values prinusyr prinusyr

label define huse2afsc_lbl 1 "Has used" 2 "Has not used" 99 "Unknown"
label values huse2afsc huse2afsc_lbl

**# 5. gen binary indicators from categorical covariates

forval i = 1/6 {
    gen pagegrp`i' = (pagegrp == `i') if !missing(pagegrp)
    replace pagegrp`i' = 0 if missing(pagegrp`i')
}
label variable pagegrp1 "15 to 24 years"
label variable pagegrp2 "25 to 34 years"
label variable pagegrp3 "35 to 44 years"
label variable pagegrp4 "45 to 54 years"
label variable pagegrp5 "55 to 64 years"
label variable pagegrp6 "65 years or more"

forval i = 1/4 {
    gen peducgrp_`i' = (peducgrp == `i') if !missing(peducgrp)
    replace peducgrp_`i' = 0 if missing(peducgrp_`i')
}
label variable peducgrp_1 "No high school diploma"
label variable peducgrp_2 "High school diploma"
label variable peducgrp_3 "Some college"
label variable peducgrp_4 "College degree"

forval i = 1/3 {
    gen pempstat`i' = (pempstat == `i') if !missing(pempstat)
    replace pempstat`i' = 0 if missing(pempstat`i')
}
label variable pempstat1 "Employed"
label variable pempstat2 "Unemployed"
label variable pempstat3 "Not in labor force"

forval i = 1/5 {
    gen praceeth2_`i' = (praceeth2 == `i') if !missing(praceeth2)
    replace praceeth2_`i' = 0 if missing(praceeth2_`i')
}

forval i = 1/5 {
    gen hhincome_`i' = (hhincome == `i') if !missing(hhincome)
    replace hhincome_`i' = 0 if missing(hhincome_`i')
}
label variable hhincome_1 "Less than $15,000"
label variable hhincome_2 "$15,000 to $30,000"
label variable hhincome_3 "$30,000 to $50,000"
label variable hhincome_4 "$50,000 to $75,000"
label variable hhincome_5 "At least $75,000"

forval i = 1/6 {
    gen hhtype`i' = (hhtype == `i') if !missing(hhtype)
    replace hhtype`i' = 0 if missing(hhtype`i')
}
label variable hhtype1 "Married couple"
label variable hhtype2 "Unmarried female-headed family"
label variable hhtype3 "Unmarried male-headed family"
label variable hhtype4 "Female individual"
label variable hhtype5 "Male individual"
label variable hhtype6 "Other"

**# 6. Save

save "$DATA/final/mergedall_binary.dta", replace
