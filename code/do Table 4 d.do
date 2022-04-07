
clear all

cd "$pathCanadaBOD"

cd output

capture log close 

log using "log Table 4 d.smcl", replace

***************************************************************************
* This is "do Table 4 d.do"

* Project: Canada Burden of Disease                                                                        
* Person: Farshad Pourmalek pourmalek_farshad at yahoo dotcom
* Time (initial): 2022 March 28
***************************************************************************



** Prepares Table 4
* Table 4: Relative (%) changes in age-standardized DALY rates in Canada and comparator locations 
* and Canada’s rank in 1990-2019 among all high-income countries. 

* level 2 causes, Canada's Rank in 1990 and Rank in 2019 for Age-standardized DALYs rate in each of 5 group of countries:
* Canada, United States, Western Europe, Australasia, Asia-Pacific


* Metadata for input data described below,
* under each -import delimited using "IHME-GBD_2019_DATA-??.csv"-


** Table 4 Part 3: Level 2 Grouping of Conditions, % change in values 1990-2019
* Input data: "IHME-GBD_2019_DATA-54.csv"
* Output data: "Table 4 Part4.dta"






***********************************************************************
* Prepare Table 4 Part4

** Prepares Table 4, Level 2 Grouping of Conditions
* Table 4: Relative (%) changes in age-standardized DALY rates in Canada and comparator locations 
* and Canada’s rank in 1990-2019 among all high-income countries. 

* level 2 causes, Canada's Rank in 1990 and Rank in 2019 for Age-standardized DALYs rate in each of 6 group of countries:
* Canada, United States, Western Europe, Australasia, Asia-Pacific, Southern Latin America


* use input data from /data/ folder

cd .. // Canada-Burden-of-Disease-main

cd data

import delimited using "IHME-GBD_2019_DATA-54.csv", clear 


/* "IHME-GBD_2019_DATA-54.csv" Metadata:

Permalink:
https://ghdx.healthdata.org/gbd-results-tool?params=gbd-api-2019-permalink/5a652f794f564ee9988223d051289d0b

Data settings:

Base: Single
Location: 36 countries (See "do Table 4 a.do")
Year: 1990, 2019

Context: Cause
Age: Age-standardized
Metric: Rate

Measure: DALYs
Sex: Male, Female, Both
Cause: level 2


Download settings: 
Both IDs and Names 
(ID = variable_id, Name = variable_name)


* Countries in Table 4:

see "do Table 4 a.do"


*/


* save output data in /output/ folder

cd .. // Canada-Burden-of-Disease-main

cd output 

drop measure_id location_id age_id metric_id metric_name

rename measure_name Measure

rename cause_name Cause

replace Cause = "Maternal & neonatal" if Cause == "Maternal and neonatal disorders"
replace Cause = "Respiratory infections" if Cause == "Respiratory infections and tuberculosis"
replace Cause = "Neoplasms" if Cause == "Neoplasms"
replace Cause = "Cardiovascular" if Cause == "Cardiovascular diseases"
replace Cause = "Chronic respiratory" if Cause == "Chronic respiratory diseases"
replace Cause = "Digestive" if Cause == "Digestive diseases"
replace Cause = "Neurological" if Cause == "Neurological disorders"
replace Cause = "Mental" if Cause == "Mental disorders"
replace Cause = "Substance use" if Cause == "Substance use disorders"
replace Cause = "Diabetes & kidney" if Cause == "Diabetes and kidney diseases"
replace Cause = "Skin" if Cause == "Skin and subcutaneous diseases"
replace Cause = "Sense organ" if Cause == "Sense organ diseases"
replace Cause = "Musculoskeletal" if Cause == "Musculoskeletal disorders"
replace Cause = "Other NCD" if Cause == "Other non-communicable diseases"
replace Cause = "Transport injuries" if Cause == "Transport injuries"
replace Cause = "Unintentional injuries" if Cause == "Unintentional injuries"
replace Cause = "Self-harm and violence" if Cause == "Self-harm and interpersonal violence"

gen cause_id_new = .
replace cause_id_new = 1 if Cause == "Maternal & neonatal"
replace cause_id_new = 2 if Cause == "Respiratory infections"
replace cause_id_new = 3 if Cause == "Neoplasms"
replace cause_id_new = 4 if Cause == "Cardiovascular"
replace cause_id_new = 5 if Cause == "Chronic respiratory"
replace cause_id_new = 6 if Cause == "Digestive"
replace cause_id_new = 7 if Cause == "Neurological"
replace cause_id_new = 8 if Cause == "Mental"
replace cause_id_new = 9 if Cause == "Substance use"
replace cause_id_new = 10 if Cause == "Diabetes & kidney"
replace cause_id_new = 11 if Cause == "Skin"
replace cause_id_new = 12 if Cause == "Sense organ"
replace cause_id_new = 13 if Cause == "Musculoskeletal"
replace cause_id_new = 14 if Cause == "Other NCD"
replace cause_id_new = 15 if Cause == "Transport injuries"
replace cause_id_new = 16 if Cause == "Unintentional injuries"
replace cause_id_new = 17 if Cause == "Self-harm and violence"


drop if Cause == "Enteric infections"
drop if Cause == "HIV/AIDS and sexually transmitted infections"
drop if Cause == "Neglected tropical diseases and malaria"
drop if Cause == "Nutritional deficiencies"
drop if Cause == "Other infectious diseases"



gen Sex = ""
replace Sex = "Both sexes" if sex_name == "Both"
replace Sex = "Males" if sex_name == "Male"
replace Sex = "Females" if sex_name == "Female"
drop sex_name


gen sex_id_new = .
replace sex_id_new = 1 if Sex == "Both sexes"
replace sex_id_new = 2 if Sex == "Males"
replace sex_id_new = 3 if Sex == "Females"

rename	val Value
rename upper Upper_UL
rename lower Lower_UL

order Upper_UL, after(Lower_UL)

label var Upper_UL "Upper UL"
label var Lower_UL "Lower UL"

replace Value = round(Value,0.01)
replace Upper_UL = round(Upper_UL,0.1)
replace Lower_UL = round(Lower_UL,0.1)
format Value Upper_UL Lower_UL %5.2fc
	
rename year Year

keep if Year == 1990 | Year == 2019
	
order sex_id cause_id Year, last

order Sex, after(age_name)

rename location_name Location

order Measure age_name, last

sort Location Sex cause_id_new

sort sex_id_new 

qui compress

keep Location Sex Cause Value Year cause_id_new

keep if Sex == "Both sexes"

drop Sex

* 

bysort Year Cause: egen rank = rank(Value)

label var rank "Canada's rank of mean DALYs within Country-Cause-Year"

sort Year rank

keep if Location == "Canada"

sort Year cause_id_new

drop Location Value

reshape wide rank, i(Cause) j(Year)

sort cause_id_new

rename rank1990	Rank_in_1990
rename rank2019	Rank_in_2019

label var Rank_in_1990 "Rank in 1990"
label var Rank_in_2019 "Rank in 2019"

drop cause_id_new

qui compress

save "Table 4 Part4.dta", replace


/* "Table 4 Part4.dta" contents

% change values 1990-2019

DALYs comparator country groups

Both sexes	

level 2 causes

*/














******************************************************************

* merge Table 4 Part1 and Part2, (% change in values 1990-2019) and (Canada's Rank in 1990 and Rank in 2019)
* Level 1 Grouping of Conditions

use "Table 4 Part1.dta", clear

merge m:m Cause using "Table 4 Part2.dta"

drop _merge

sort cause_id_new

drop cause_id_new

save "Table 4 Part1andPart2.dta", replace



* merge Table 4 Part3 and Part4, (% change in values 1990-2019) and (Canada's Rank in 1990 and Rank in 2019)
* level 2 causes

use "Table 4 Part3.dta", clear

merge m:m Cause using "Table 4 Part4.dta"

drop _merge

drop location_id_newAsia_Pacific location_id_newAustralasia location_id_newCanada ///
location_id_newUnited_States location_id_newWestern_Europe 

save "Table 4 Part3andPart4.dta", replace





* append level 1 and level 2 causes 

use "Table 4 Part1andPart2.dta", clear 

append using "Table 4 Part3andPart4.dta"

replace cause_id_new = cause_id_new + 3

replace cause_id_new = 1 in 1 
replace cause_id_new = 2 in 2
replace cause_id_new = 3 in 3 

sort cause_id_new

drop cause_id_new location_id_newSouthern_Latin

qui compress

save "Table 4.dta", replace

export excel using "Table 4.xlsx", replace firstrow(varlabels)




********

* remove files no longer needed

shell rm -r "Table 4 Part1andPart2.dta"
shell rm -r "Table 4 Part1.dta"
shell rm -r "Table 4 Part2.dta"
shell rm -r "Table 4 Part3.dta"
shell rm -r "Table 4 Part3andPart4.dta"
shell rm -r "Table 4 Part4.dta"




/*

* restore native scheme (of the local machine)

set scheme $nativescheme

di c(scheme)

*/



**********************

view "log Table 4 d.smcl"

log close

cd ..

cd code

exit, clear
