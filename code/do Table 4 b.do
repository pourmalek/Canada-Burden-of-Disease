

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



** Prepares Table 4, YLLs
* Table 4: Canada’s rank in the world for 5 health indicators (age-standardized rates) 
* from 1990 to 2019, by sex and age


* Metadata for input data described below,
* under each -import delimited using "IHME-GBD_2019_DATA-??.csv"-


** Table 4 Part 3: YLLs, Age-standardized
* Input data: "IHME-GBD_2019_DATA-43.csv"
* Output data: "Table 4 Part3.dta"

** Table 4 Part 4: YLLs, Age: <5, 5-14, 15-49, 50-69, 70+
* Input data: "IHME-GBD_2019_DATA-44.csv"
* Output data: ""Table 4 Part4.dta"




***********************************************************************
* Prepare Table 4 Part3

* Table 4: Canada’s rank in the world for 5 health indicators (age-standardized rates) 
* from 1990 to 2019, by sex and age

* DALYS	1990	2000	2010	2019

* (age-standardized rates)
*    Both	
*    Male	
*    Female	



* use input data from /data/ folder

cd .. // Canada-Burden-of-Disease-main

cd data

import delimited using "IHME-GBD_2019_DATA-43.csv", clear 


/* "IHME-GBD_2019_DATA-43.csv" Metadata:

Permalink:
https://ghdx.healthdata.org/gbd-results-tool?params=gbd-api-2019-permalink/e3d46c870342223239f833088ed4ba10

Data settings:

Base: Single
Location: Countries and territories (204)
Year: 1990, 2000, 2010, 2019

Context: Cause
Age: Age-standardized
Metric: Rate

Measure: YLLs
Sex: Male, Female, Both
Cause: Total All Causes


Download settings: 
Both IDs and Names 
(ID = variable_id, Name = variable_name)

*/


* save output data in /output/ folder

cd .. // Canada-Burden-of-Disease-main

cd output 

drop measure_id location_id age_id metric_id metric_name

rename cause_name Cause

rename measure_name Measure
replace Measure = "YLLs" if Measure == "YLLs (Years of Life Lost)"
qui compress


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


sort sex_id_new Year 

drop sex_id sex_id_new cause_id

order Sex, after(Age)


* gen Sex-Year combinations  

egen Sex_Year = group(Sex Year), lname(name)

label var Sex_Year "Sex-Year group"

save "IHME-GBD_2019_DATA-43.dta", replace


* for YLLs 1990 2000 2010 2019 All Ages
	
keep if Measure == "YLLs"


bysort Sex_Year: egen rank = rank(Value)

label var rank "rank of mean YLLs within Sex-Year group"

sort Sex_Year rank

label var location_name "Country"

keep if location_name == "Canada"

*

drop Value Lower_UL Upper_UL Sex_Year

drop location_name Cause

order Measure Sex Age rank 

reshape wide rank, i(Measure Sex Age) j(Year)

qui compress

save "Table 4 Part3.dta", replace


/* "Table 4 Part3.dta" contents

Base values of 1990 2000 2010 2019

Value	Lower UL	Upper UL

YLLs 

Both sexes	Males	Females

Age-standardized	

All causes

*/










***********************************************************************
* Prepare Table 4 Part4

* Table 4: Canada’s rank in the world for 5 health indicators (age-standardized rates) 
* from 1990 to 2019, by sex and age

* DALYS	1990	2000	2010	2019

* Age (Both sexes)
*     <5	
*     5-14	
*     15-49	
*     50-69	
*     70+	
 
 

* use input data from /data/ folder

cd .. // Canada-Burden-of-Disease-main

cd data

import delimited using "IHME-GBD_2019_DATA-44.csv", clear 


/* "IHME-GBD_2019_DATA-44.csv" Metadata:

Permalink:
https://ghdx.healthdata.org/gbd-results-tool?params=gbd-api-2019-permalink/bc7221a695d811b6f058c86cbf586362

Data settings:

Base: Single
Location: Countries and territories (204)
Year: 1990, 2000, 2010, 2019

Context: Cause
Age: <5, 5-14, 15-49, 50-69, 70+
Metric: Rate

Measure: YLLs
Sex: Male, Female, Both
Cause: Total All Causes


Download settings: 
Both IDs and Names 
(ID = variable_id, Name = variable_name)

*/


 

* save output data in /output/ folder

cd .. // Canada-Burden-of-Disease-main

cd output 

drop measure_id location_id age_id metric_id metric_name

rename cause_name Cause

rename measure_name Measure
replace Measure = "YLLs" if Measure == "YLLs (Years of Life Lost)"
qui compress


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


sort sex_id_new Year 

drop sex_id cause_id

order Sex, after(Age)



gen age_id_new = .
replace age_id_new = 1 if Age == "Under 5"
replace age_id_new = 2 if Age == "5-14 years"
replace age_id_new = 3 if Age == "15-49 years"
replace age_id_new = 4 if Age == "50-69 years"
replace age_id_new = 5 if Age == "70+ years"

replace Age = "0-5" if Age == "Under 5"
replace Age = "5-14" if Age == "5-14 years"
replace Age = "15-49" if Age == "15-49 years"
replace Age = "50-69" if Age == "50-69 years"
replace Age = "70+" if Age == "70+ years"
 

* gen Sex-Year-Age combinations  

egen Sex_Year_Age = group(Sex Year Age), lname(name)

label var Sex_Year_Age "Sex-Year-Age group"

save "IHME-GBD_2019_DATA-44.dta", replace


* for YLLs 1990 2000 2010 2019 All Ages
	
keep if Measure == "YLLs"


bysort Sex_Year_Age: egen rank = rank(Value)

label var rank "rank of mean YLLs within Sex_Year_Age group"

sort Sex_Year_Age rank

label var location_name "Country"

keep if location_name == "Canada"

* 

drop Value Lower_UL Upper_UL Sex_Year

drop location_name Cause

order Measure Sex Age rank 

reshape wide rank, i(Measure Sex Age) j(Year)

qui compress

save "Table 4 Part4.dta", replace


/* "Table 4 Part4.dta" contents

Base values of 1990 2000 2010 2019

Value	Lower UL	Upper UL

YLLs 

Both sexes	Males	Females

Age: <5, 5-14, 15-49, 50-69, 70+	

All causes

*/

 
 
 
 
 
 
 
 
 
 
 
 
 



**********************

view "log Table 4 b.smcl"

log close

cd ..

cd code

exit, clear
