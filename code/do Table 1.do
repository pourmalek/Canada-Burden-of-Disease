
clear all

cd "$pathCanadaBOD"

cd output

capture log close 

log using "log Table 1.smcl", replace

***************************************************************************
* This is "do Table 1.do"

* Project: Canada Burden of Disease                                                                        
* Person: Farshad Pourmalek pourmalek_farshad at yahoo dotcom
* Time (initial): 2022 March 28
***************************************************************************

cd .. // Canada-Burden-of-Disease-main

cd data

import delimited using "IHME-GBD_2019_DATA-1.csv", clear 

cd .. // Canada-Burden-of-Disease-main

cd output 

save "IHME-GBD_2019_DATA-1.dta", replace

drop measure_id location_id location_name age_id cause_id cause_name metric_id metric_name


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

replace Value = round(Value,0.1)
replace Upper_UL = round(Upper_UL,0.1)
replace Lower_UL = round(Lower_UL,0.1)
format %12.1fc Value Upper_UL Lower_UL

rename age_name Age
	
rename year Year 

keep if Year == 1990 | Year == 2019
	
sort measure_id_new sex_id_new age_id_new Year

drop sex_id	measure_id_new	sex_id_new age_id_new

order Sex, after(Age)

save "IHME-GBD_2019_DATA-1.dta", replace

export delimited using "Table 1 Part 1.csv", replace





**********************

view "log Table 1.smcl"

log close

exit, clear
