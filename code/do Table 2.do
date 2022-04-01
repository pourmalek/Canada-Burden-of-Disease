
clear all

cd "$pathCanadaBOD"

cd output

capture log close 

log using "log Table 2.smcl", replace

***************************************************************************
* This is "do Table 2.do"

* Project: Canada Burden of Disease                                                                        
* Person: Farshad Pourmalek pourmalek_farshad at yahoo dotcom
* Time (initial): 2022 March 28
***************************************************************************


** Prepares Table 2
* Table 2: All-age DALY rates per 100,000 in Canada in 1990 and 2019 for groups of conditions   


* Metadata for input data described below,
* under each -import delimited using "IHME-GBD_2019_DATA-??.csv"-


** Table 2 Part 1: level 1 causes
* Input data: "IHME-GBD_2019_DATA-21.csv"
* Output data: "Table 2 Part1.dta"

** Table 2 Part 2: level 2 causes
* Input data: "IHME-GBD_2019_DATA-22.csv"
* Output data: "Table 2 Part2.dta"



***********************************************************************
* Prepare Table 2 Part1

* All-age DALY rates per 100,000 in Canada in 1990 and 2019. level 1 causes


* use input data from /data/ folder

cd .. // Canada-Burden-of-Disease-main

cd data

import delimited using "IHME-GBD_2019_DATA-21.csv", clear 

/* "IHME-GBD_2019_DATA-21.csv" Metadata:

Permalink:
https://ghdx.healthdata.org/gbd-results-tool?params=gbd-api-2019-permalink/0cda6e1af2fdb16b3a2942edaf32a1d6

Data settings:

Base: Single
Location: Canada
Year: 1990, 2000, 2010, 2019

Context: Cause
Age: All Ages, Age-standardized
Metric: Rate

Measure: DALY, YLL, YLD
Sex: Male, Female, Both
Cause: level 1 causes (i.e., 3 causes)


Download settings: 
Both IDs and Names 
(ID = variable_id, Name = variable_name)

*/


* save output data in /output/ folder

cd .. // Canada-Burden-of-Disease-main

cd output 

save "IHME-GBD_2019_DATA-21.dta", replace


/*
cause_id	cause_name
295	Communicable, maternal, neonatal, and nutritional diseases
409	Non-communicable diseases
687	Injuries
*/

keep if cause_id == 295 | cause_id == 409 | cause_id == 687

gen cause_id_new = . 
replace cause_id_new = 1 if cause_name == "Communicable, maternal, neonatal, and nutritional diseases"
replace cause_id_new = 2 if cause_name == "Non-communicable diseases"
replace cause_id_new = 3 if cause_name == "Injuries"

replace cause_name = "CMNN" if cause_name == "Communicable, maternal, neonatal, and nutritional diseases"
replace cause_name = "NCDs" if cause_name == "Non-communicable diseases"


drop measure_id location_id location_name age_id cause_id metric_id metric_name


rename cause_name Cause

rename measure_name Measure
replace Measure = "DALYs" if Measure == "DALYs (Disability-Adjusted Life Years)"
replace Measure = "YLDs" if Measure == "YLDs (Years Lived with Disability)"
replace Measure = "YLLs" if Measure == "YLLs (Years of Life Lost)"
qui compress

gen measure_id_new = .
replace measure_id_new = 1 if Measure == "DALYs"
replace measure_id_new = 2 if Measure == "YLLs"
replace measure_id_new = 3 if Measure == "YLDs"


gen age_id_new = .
replace age_id_new = 1 if age_name == "All Ages"
replace age_id_new = 2 if age_name == "Age-standardized"


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

replace Value = round(Value,0.1)
replace Upper_UL = round(Upper_UL,0.1)
replace Lower_UL = round(Lower_UL,0.1)
format Value Upper_UL Lower_UL %5.1fc

rename age_name Age
	
rename year Year 

keep if Year == 1990 | Year == 2019
	
sort measure_id_new sex_id_new age_id_new Year cause_id_new

drop sex_id	measure_id_new sex_id_new age_id_new

order Sex, after(Age)

keep if Measure == "DALYs"

keep if Age == "All Ages"

keep if Year == 1990 | Year == 2019

* gen rank of Value (for DALYs) within Sex-Year combinations

egen Sex_Year = group(Sex Year), lname(name)

bysort Sex_Year: egen rank = rank(-Value)

sort Sex_Year cause_id_new

label var Sex_Year "Sex-Year group"
label var rank "rank of mean DALYs within Sex-Year group"




keep if Sex == "Both sexes"

drop Sex_Year

order Cause Year Value Lower_UL Upper_UL rank

reshape wide Value Lower_UL Upper_UL rank, i(Cause) j(Year)

order rank1990 rank2019, last

gen to = " to "

egen Rank_change = concat(rank1990 to rank2019)
label var Rank_change "Rank change"

label var Value1990	"1990 Value"
label var Lower_UL1990 "1990 Lower_UL"
label var Upper_UL1990 "1990 Upper_UL"
label var Value2019 "2019 Value"
label var Lower_UL2019 "2019 Lower_UL"
label var Upper_UL2019 "2019 Upper_UL"

drop Measure Age Sex cause_id_new

drop rank1990 rank2019 to


save "Table 2 Part1.dta", replace

/* "Table 2 Part1.dta" contents

Base values of 1990 and 2019

Value	Lower UL	Upper UL

DALYs 

Both sexes	Males	Females

All ages	

level 1 causes (i.e., 3 causes)

*/






***********************************************************************
* Prepare Table 2 Part2

* All-age DALY rates per 100,000 in Canada in 1990 and 2019.  level 2 causes


* use input data from /data/ folder

cd .. // Canada-Burden-of-Disease-main

cd data

import delimited using "IHME-GBD_2019_DATA-22.csv", clear 

/* "IHME-GBD_2019_DATA-22.csv" Metadata:

Permalink:
https://ghdx.healthdata.org/gbd-results-tool?params=gbd-api-2019-permalink/a02d127dfc4f606293148ea261862d35

Data settings:

Base: Single
Location: Canada
Year: 1990, 2000, 2010, 2019

Context: Cause
Age: All Ages, Age-standardized
Metric: Rate

Measure: DALY, YLL, YLD
Sex: Male, Female, Both
Cause: level 2 causes (17 causes)


Download settings: 
Both IDs and Names 
(ID = variable_id, Name = variable_name)

*/


* save output data in /output/ folder

cd .. // Canada-Burden-of-Disease-main

cd output 

save "IHME-GBD_2019_DATA-22.dta", replace


gen cause_id_new = . 
replace cause_id_new = 1 if cause_name == "Maternal and neonatal disorders"
replace cause_id_new = 2 if cause_name == "Respiratory infections and tuberculosis"
replace cause_id_new = 3 if cause_name == "Neoplasms"
replace cause_id_new = 4 if cause_name == "Cardiovascular diseases"
replace cause_id_new = 5 if cause_name == "Chronic respiratory diseases"
replace cause_id_new = 6 if cause_name == "Digestive diseases"
replace cause_id_new = 7 if cause_name == "Neurological disorders"
replace cause_id_new = 8 if cause_name == "Mental disorders"
replace cause_id_new = 9 if cause_name == "Substance use disorders"
replace cause_id_new = 10 if cause_name == "Diabetes and kidney diseases"
replace cause_id_new = 11 if cause_name == "Skin and subcutaneous diseases"
replace cause_id_new = 12 if cause_name == "Sense organ diseases"
replace cause_id_new = 13 if cause_name == "Musculoskeletal disorders"
replace cause_id_new = 14 if cause_name == "Other non-communicable diseases"
replace cause_id_new = 15 if cause_name == "Transport injuries"
replace cause_id_new = 16 if cause_name == "Unintentional injuries"
replace cause_id_new = 17 if cause_name == "Self-harm and interpersonal violence"


replace cause_name = "Maternal & neonatal" if cause_name == "Maternal and neonatal disorders"
replace cause_name = "Respiratory infections" if cause_name == "Respiratory infections and tuberculosis"
replace cause_name = "Neoplasms" if cause_name == "Neoplasms"
replace cause_name = "Cardiovascular" if cause_name == "Cardiovascular diseases"
replace cause_name = "Chronic respiratory" if cause_name == "Chronic respiratory diseases"
replace cause_name = "Digestive" if cause_name == "Digestive diseases"
replace cause_name = "Neurological" if cause_name == "Neurological disorders"
replace cause_name = "Mental" if cause_name == "Mental disorders"
replace cause_name = "Substance use" if cause_name == "Substance use disorders"
replace cause_name = "Diabetes & kidney" if cause_name == "Diabetes and kidney diseases"
replace cause_name = "Skin" if cause_name == "Skin and subcutaneous diseases"
replace cause_name = "Sense organ" if cause_name == "Sense organ diseases"
replace cause_name = "Musculoskeletal" if cause_name == "Musculoskeletal disorders"
replace cause_name = "Other NCD" if cause_name == "Other non-communicable diseases"
replace cause_name = "Transport injuries" if cause_name == "Transport injuries"
replace cause_name = "Unintentional injuries" if cause_name == "Unintentional injuries"
replace cause_name = "Self-harm and violence" if cause_name == "Self-harm and interpersonal violence"



drop measure_id location_id location_name age_id cause_id metric_id metric_name



rename cause_name Cause

rename measure_name Measure
replace Measure = "DALYs" if Measure == "DALYs (Disability-Adjusted Life Years)"
replace Measure = "YLDs" if Measure == "YLDs (Years Lived with Disability)"
replace Measure = "YLLs" if Measure == "YLLs (Years of Life Lost)"
qui compress

gen measure_id_new = .
replace measure_id_new = 1 if Measure == "DALYs"
replace measure_id_new = 2 if Measure == "YLLs"
replace measure_id_new = 3 if Measure == "YLDs"


gen age_id_new = .
replace age_id_new = 1 if age_name == "All Ages"
replace age_id_new = 2 if age_name == "Age-standardized"


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

replace Value = round(Value,0.1)
replace Upper_UL = round(Upper_UL,0.1)
replace Lower_UL = round(Lower_UL,0.1)
format Value Upper_UL Lower_UL %5.1fc

rename age_name Age
	
rename year Year 

keep if Year == 1990 | Year == 2019
	
sort measure_id_new sex_id_new age_id_new Year cause_id_new

drop sex_id	measure_id_new sex_id_new age_id_new

order Sex, after(Age)

keep if Measure == "DALYs"

keep if Age == "All Ages"

keep if Year == 1990 | Year == 2019

* gen rank of Value (for DALYs) within Sex-Year combinations

egen Sex_Year = group(Sex Year), lname(name)

bysort Sex_Year: egen rank = rank(-Value)

sort Sex_Year cause_id_new

label var Sex_Year "Sex-Year group"
label var rank "rank of mean DALYs within Sex-Year group"




keep if Sex == "Both sexes"

drop Sex_Year

order Cause Year Value Lower_UL Upper_UL rank

reshape wide Value Lower_UL Upper_UL rank, i(Cause) j(Year)

order rank1990 rank2019, last

gen to = " to "

egen Rank_change = concat(rank1990 to rank2019)
label var Rank_change "Rank change"

label var Value1990	"1990 Value"
label var Lower_UL1990 "1990 Lower_UL"
label var Upper_UL1990 "1990 Upper_UL"
label var Value2019 "2019 Value"
label var Lower_UL2019 "2019 Lower_UL"
label var Upper_UL2019 "2019 Upper_UL"

drop Measure Age Sex cause_id_new

drop rank1990 rank2019 to



save "Table 2 Part2.dta", replace

/* Table 2 Part2.dta" contents

Base values of 1990 and 2019

Value	Lower UL	Upper UL

DALYs 

Both sexes	Males	Females

All ages	

 level 2 causes (17 causes)

*/





************************************************************************
* append (level 1), (level 2) causes

use "Table 2 Part1.dta", clear

append using "Table 2 Part2.dta"

save "Table 2.dta", replace

export excel using "Table 2.xlsx", replace firstrow(varlabels)



********

* remove files no longer needed

shell rm -r "Table 2 Part1.dta"
shell rm -r "Table 2 Part2.dta"










**********************

view "log Table 2.smcl"

log close

cd ..

cd code

exit, clear
