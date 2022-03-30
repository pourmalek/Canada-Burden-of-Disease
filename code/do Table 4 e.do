
clear all

cd "$pathCanadaBOD"

cd output

capture log close 

log using "log Table 4 e.smcl", replace

***************************************************************************
* This is "do Table 4 e.do"

* Project: Canada Burden of Disease                                                                        
* Person: Farshad Pourmalek pourmalek_farshad at yahoo dotcom
* Time (initial): 2022 March 28
***************************************************************************



** Prepares Table 4, Post Neonatal mortality 
* Table 4: Canada’s rank in the world for 5 health indicators (age-standardized rates) 
* from 1990 to 2019, by sex and age


* Metadata for input data described below,
* under each -import delimited using "IHME-GBD_2019_DATA-??.csv"-


** Table 4 Part 7: YLDs, Life expectancy
* Input data: "IHME-GBD_2019_DATA-48.csv"
* Output data: "Table 4.xlsx", sheet("Part8")






***********************************************************************
* Prepare Table 4 Part7

* Table 4: Canada’s rank in the world for 5 health indicators (age-standardized rates) 
* from 1990 to 2019, by sex and age

* DALYS	1990	2000	2010	2019

* Post Neonatal mortality



* use input data from /data/ folder

cd .. // Canada-Burden-of-Disease-main

cd data

import delimited using "IHME-GBD_2019_DATA-48.csv", clear 


/* "IHME-GBD_2019_DATA-48.csv" Metadata:

Permalink:
https://ghdx.healthdata.org/gbd-results-tool?params=gbd-api-2019-permalink/17aa77d2e7698990f2133ad310976857

Data settings:

Base: Single
Location: Countries and territories (204)
Year: 1990, 2000, 2010, 2019

Context: All Cause Mortality
Age: <1 year
Metric: Years

Measure: Life Expectancy
Sex: Male, Female, Both
Cause: (Not applicable)


Download settings: 
Both IDs and Names 
(ID = variable_id, Name = variable_name)

*/


* save output data in /output/ folder

cd .. // Canada-Burden-of-Disease-main

cd output 

drop measure_id location_id age_id metric_id metric_name

rename measure_name Measure



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


sort sex_id_new Year 

drop sex_id sex_id_new 


* gen Sex-Year combinations  

egen Sex_Year = group(Sex Year), lname(name)

label var Sex_Year "Sex-Year group"

save "IHME-GBD_2019_DATA-48.dta", replace
	


bysort Sex_Year: egen rank = rank(Value)

label var rank "rank of mean YLDs within Sex-Year group"

sort Sex_Year rank

label var location_name "Country"

keep if location_name == "Canada"

export excel using "Table 4.xlsx", sheet("Part8") firstrow(varlabels) 


/* "Table 4.xlsx", sheet("Part7") contents

Base values of 1990 2000 2010 2019

Value	Lower UL	Upper UL

Life expectancy 

Both sexes	Males	Females

*/








**********************

view "log Table 4 e.smcl"

log close

cd ..

cd code

exit, clear
