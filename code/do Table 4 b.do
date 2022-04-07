
clear all

cd "$pathCanadaBOD"

cd output

capture log close 

log using "log Table 4 b.smcl", replace

***************************************************************************
* This is "do Table 4 b.do"

* Project: Canada Burden of Disease                                                                        
* Person: Farshad Pourmalek pourmalek_farshad at yahoo dotcom
* Time (initial): 2022 March 28
***************************************************************************



** Prepares Table 4
* Table 4: Relative (%) changes in age-standardized DALY rates in Canada and comparator locations 
* and Canada’s rank in 1990-2019 among all high-income countries. 

* level 1 causes, Canada's Rank in 1990 and Rank in 2019 for Age-standardized DALYs rate among 36 countries:
* Canada, United States, Western Europe, Australasia, Asia-Pacific, Southern Latin America


* Metadata for input data described below,
* under each -import delimited using "IHME-GBD_2019_DATA-??.csv"-


** Table 4 Part 2: Level 1 Grouping of Conditions, Canada's Rank in 1990 and Rank in 2019 
* Input data: "IHME-GBD_2019_DATA-52.csv"
* Output data: "Table 4 Part2.dta"






***********************************************************************
* Prepare Table 4 Part2

** Prepares Table 4, Level 1 Grouping of Conditions
* Table 4: Relative (%) changes in age-standardized DALY rates in Canada and comparator locations 
* and Canada’s rank in 1990-2019 among all high-income countries. 

* level 1 causes, Canada's Rank in 1990 and Rank in 2019 for Age-standardized DALYs rate among 36 countries:
* Canada, United States, Western Europe, Australasia, Asia-Pacific (see below)


* use input data from /data/ folder

cd .. // Canada-Burden-of-Disease-main

cd data

import delimited using "IHME-GBD_2019_DATA-52.csv", clear 


/* "IHME-GBD_2019_DATA-52.csv" Metadata:

Permalink:
https://ghdx.healthdata.org/gbd-results-tool?params=gbd-api-2019-permalink/ed41dbdfb950d3a9a64962694105a5dc

Data settings:

Base: Single
Location: 36 countries (See "do Table 4 a.do")
Year: 1990, 2000, 2010, 2019

Context: Cause
Age: Age-standardized
Metric: Rate

Measure: DALYs
Sex: Both
Cause: level 1


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

order Measure age_name, last

order sex_id sex_name cause_id, last

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

rename location_name Location 



sort Location cause_name

rename cause_name Cause


gen cause_id_new = . 

replace cause_id_new = 1 if Cause == "Communicable, maternal, neonatal, and nutritional diseases"
replace cause_id_new = 2 if Cause == "Non-communicable diseases"
replace cause_id_new = 3 if Cause == "Injuries"

drop if Cause == "All causes"

sort cause_id_new

replace Cause = "MNC" if Cause == "Communicable, maternal, neonatal, and nutritional diseases"
replace Cause = "Non-communicable" if Cause == "Non-communicable diseases"


keep if Year == 1990 | Year == 2019



qui compress

keep Location Cause Year Value cause_id_new

order Cause Year Location Value cause_id_new

sort Cause Year Location


bysort Year Cause: egen rank = rank(Value)

label var rank "Canada's rank of mean DALYs within Country-Cause-Year"

sort Year rank

keep if Location == "Canada"

sort Year cause_id_new

drop Location Value

reshape wide rank, i(Cause) j(Year)

rename rank1990	Rank_in_1990
rename rank2019	Rank_in_2019

label var Rank_in_1990 "Rank in 1990"
label var Rank_in_2019 "Rank in 2019"

sort cause_id_new


drop cause_id_new

qui compress

save "Table 4 Part2.dta", replace 


/* "Table 4 Part2.dta" contents



DALYs comparator countries

Both sexes	

*/








**********************

view "log Table 4 b.smcl"

log close

cd ..

cd code

exit, clear
