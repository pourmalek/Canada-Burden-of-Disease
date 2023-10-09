
clear all

cd "$pathCanadaBOD"

cd output

capture log close 

log using "log Table S5.smcl", replace

***************************************************************************
* This is "do Table S5.do"

* Project: Canada Burden of Disease 1990-2019                                                                        
* Person: Farshad Pourmalek
* Time (initial): 2022 March 28
***************************************************************************



** Prepares Table S5
* Table S5. Age-standardized DALY rates for 204 countries and high-income regions in 1990 and 2019 and relative change (males and females combined)



* Metadata for input data described below,
* under each -import delimited using "IHME-GBD_2019_DATA-??.dta"-






***********************************************************************
* Prepare Table S5 Part 1

** Table S5 Part 1: Base values



* use input data from /data/ folder

cd .. // Canada-Burden-of-Disease-main

cd data

import delimited using "IHME-GBD_2019_DATA-104.csv", clear 

/* "IHME-GBD_2019_DATA-104.csv" Metadata:

Permalink:
https://ghdx.healthdata.org/gbd-results-tool?params=gbd-api-2019-permalink/75d3353d294bb8422dc47e0368c06244

Data settings:

Base: Single
Location: 204 countries, 5 high-income regions, all high-income countries
Year: 2019, 2019

Context: Cause
Age: Age-standardized
Metric: Rate

Measure: DALY
Sex: Male, Female, Both
Cause: All cause


Download settings: 
Both IDs and Names 
(ID = variable_id, Name = variable_name)

*/


* save output data in /output/ folder

cd .. // Canada-Burden-of-Disease-main

cd output 

drop measure_id location_id age_id metric_id metric_name ///
measure_name sex_id sex_name age_name cause_id cause_name

qui compress

rename	val Value
rename upper Upper_UL
rename lower Lower_UL

order Upper_UL, after(Lower_UL)

label var Upper_UL "Upper UL"
label var Lower_UL "Lower UL"

replace Value = round(Value,0.1)
replace Upper_UL = round(Upper_UL,0.1)
replace Lower_UL = round(Lower_UL,0.1)
format Value Upper_UL Lower_UL %5.1f
	
rename year Year 

gsort Year Value

rename location_name Location

qui compress

save "IHME-GBD_2019_DATA-104.dta", replace




*****************************
* Table S5 2019

use "IHME-GBD_2019_DATA-104.dta",clear

keep if Year == 2019

drop Year

rename (Value Lower_UL Upper_UL) (Value_2019 Lower_UL_2019 Upper_UL_2019)

sort Value

save "Table S5 2019.dta", replace







*****************************
* Table S5 1990

use "IHME-GBD_2019_DATA-104.dta",clear

keep if Year == 1990

drop Year

rename (Value Lower_UL Upper_UL) (Value_1990 Lower_UL_1990 Upper_UL_1990)

sort Value

save "Table S5 1990.dta", replace






******************************
* merge 2019 and 1990 

use "Table S5 2019.dta", clear 

merge m:m Location using "Table S5 1990.dta"

drop _merge

sort Value_2019

order Location Value_1990 Lower_UL_1990 Upper_UL_1990 Value_2019 Lower_UL_2019 Upper_UL_2019


gen dash = "-"
gen Lower_UL_1990_str = strofreal(Lower_UL_1990, "%2.1f")
gen Upper_UL_1990_str = strofreal(Upper_UL_1990, "%2.1f")

egen Value_1990_UI = concat(Lower_UL_1990 dash Upper_UL_1990)
label var Value_1990_UI "Value 1990 UI"

order Value_1990_UI, after(Value_1990)


gen Lower_UL_2019_str = strofreal(Lower_UL_2019, "%2.1f")
gen Upper_UL_2019_str = strofreal(Upper_UL_2019, "%2.1f")

egen Value_2019_UI = concat(Lower_UL_2019 dash Upper_UL_2019)
label var Value_2019_UI "Value 2019 UI"

order Value_2019_UI, after(Value_2019)

drop Lower_UL_1990_str Upper_UL_1990_str Lower_UL_2019_str Upper_UL_2019_str

drop dash 

gen location_type = 2
replace location_type = 1 if Location == "High-income Asia Pacific"
replace location_type = 1 if Location == "Western Europe"
replace location_type = 1 if Location == "Australasia"
replace location_type = 1 if Location == "High-income"
replace location_type = 1 if Location == "Southern Latin America"
replace location_type = 1 if Location == "High-income North America"

label define location_type 1 "Region" 2 "Country"
label values location_type location_type

sort location_type Value_2019

gen rank_country = _n 
replace rank = rank_country - 6
replace rank = . if rank_country < 1

gen rank_region = _n
replace rank_region = . if rank_region > 6 
 
gen alpha_region = "" // comes before location name in Table
replace alpha_region = "R1. " if Location == "High-income Asia Pacific"
replace alpha_region = "R2. " if Location == "Western Europe"
replace alpha_region = "R3. " if Location == "Australasia"
replace alpha_region = "R4. " if Location == "High-income"
replace alpha_region = "R5. " if Location == "Southern Latin America"
replace alpha_region = "R6. " if Location == "High-income North America"


gen Location_original = Location

replace Location = "Bolivia" if Location == "Bolivia (Plurinational State of)"
replace Location = "Côte d'Ivoire" if Location == "CÃ´te d'Ivoire"
replace Location = "North Korea" if Location == "Democratic People's Republic of Korea"
replace Location = "Democratic Republic of Congo" if Location == "Democratic Republic of the Congo"
replace Location = "Iran" if Location == "Iran (Islamic Republic of)"
replace Location = "Lao" if Location == "Lao People's Democratic Republic"
replace Location = "Micronesia" if Location == "Micronesia (Federated States of)"
replace Location = "Saint Vincent and Grenadines" if Location == "Saint Vincent and the Grenadines"
replace Location = "Syria" if Location == "Syrian Arab Republic"
replace Location = "Taiwan" if Location == "Taiwan (Province of China)"
replace Location = "Venezuela" if Location == "Venezuela (Bolivarian Republic of)"




gen dot = "." 
gen under = "_"

egen alpha_country = concat(rank_country dot under)

gen alpha_location = alpha_country
replace alpha_location = alpha_region if location_type == 1

egen beta_location = concat(alpha_location Location)

replace beta_location = subinstr(beta_location, "_", " ",.)

order beta_location, first

order Location, last
rename Location Location_edited
rename beta_location Location

drop location_type rank_country rank_region alpha_region dot under alpha_country alpha_location


sort Value_2019


qui compress

save "Table S5 Part 1.dta", replace
















***********************************************************************
* Prepare Table S5 Part 2

** Table S5 Part 2: Change 1990-2019



* use input data from /data/ folder

cd .. // Canada-Burden-of-Disease-main

cd data

import delimited using "IHME-GBD_2019_DATA-105.csv", clear 

/* "IHME-GBD_2019_DATA-105.csv" Metadata:

Permalink:
https://ghdx.healthdata.org/gbd-results-tool?params=gbd-api-2019-permalink/695590e099d5fe7dbaaef52dd38f0bd0

Data settings:

Base: Change
Location: 204 countries, 5 high-income regions, all high-income countries
Year range: 2019-2019

Context: Cause
Age: Age-standardized
Metric: Rate

Measure: DALY
Sex: Male, Female, Both
Cause: All cause


Download settings: 
Both IDs and Names 
(ID = variable_id, Name = variable_name)

*/



* save output data in /output/ folder

cd .. // Canada-Burden-of-Disease-main

cd output 

drop measure_id location_id age_id metric_id metric_name ///
measure_name sex_id sex_name age_name cause_id cause_name


rename	val Value
rename upper Upper_UL
rename lower Lower_UL

order Upper_UL, after(Lower_UL)

label var Upper_UL "Upper UL"
label var Lower_UL "Lower UL"
	
drop year_start year_end

rename Value Change_Value
rename Lower_UL Change_Lower_UL
rename Upper_UL Change_Upper_UL

* transform proportion to percent
replace Change_Value = Change_Value * 100
replace Change_Lower_UL = Change_Lower_UL * 100
replace Change_Upper_UL = Change_Upper_UL * 100

replace Change_Value = round(Change_Value,0.1)
replace Change_Lower_UL = round(Change_Lower_UL,0.1)
replace Change_Upper_UL = round(Change_Upper_UL,0.1)
format Change_Value Change_Lower_UL Change_Upper_UL %5.1f


gen Change_Lower_UL_str = strofreal(Change_Lower_UL, "%2.1f")
gen Change_Upper_UL_str = strofreal(Change_Upper_UL, "%2.1f")
gen to = " to "
egen Change_UI = concat(Change_Lower_UL_str to Change_Upper_UL_str)
label var Change_UI "Change 1990-2019 UI"
drop to

order Change_UI, after(Change_Value)

rename location_name location_original

drop Change_Lower_UL_str Change_Upper_UL_str

rename location_original Location_original

qui compress

save "Table S5 Part 2.dta", replace







**********************************
* merge the two parts of Table S5

use "Table S5 Part 1.dta", clear 

merge m:m Location_original using "Table S5 Part 2.dta"

drop _merge

sort Value_2019

order Location Value_1990 Value_1990_UI Value_2019 Value_2019_UI Change_Value Change_UI

gen VarsNotInTable = "VarsNotInTable"

order VarsNotInTable, after(Change_UI)


label var Value_1990 "Value 1990"
label var Value_2019 "Value 2019"
label var Change_Value "Change 1990-2019"

qui compress

save "Table S5.dta", replace

keep Location Value_1990 Value_1990_UI Value_2019 Value_2019_UI Change_Value Change_UI

export excel using "Table S5.xlsx", replace firstrow(varlabels) keepcellfmt





* omit files no longer needed

shell rm -r "Table S5 2019.dta"
shell rm -r "Table S5 1990.dta"
shell rm -r "Table S5 Part 1.dta"
shell rm -r "Table S5 Part 2.dta"










**********************

view "log Table S5.smcl"

log close

cd ..

cd code

exit, clear
