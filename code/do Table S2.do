
clear all

cd "$pathCanadaBOD"

cd output

capture log close 

log using "log Table S2.smcl", replace

***************************************************************************
* This is "do Table S2.do"

* Project: Canada Burden of Disease                                                                        
* Person: Farshad Pourmalek pourmalek_farshad at yahoo dotcom
* Time (initial): 2022 March 28
***************************************************************************



** Prepares Table S2
* Table S2: Top 10 causes of DALYs, YLDs and YLLs in Canada in 2019 by sex 
* and percent change from 1990 to 2019


/*

Value2019 lower upper Change1990-2019 lower upper

(top 10 causes)

1 DALYs, All Ages, Males
2 DALYs, All Ages, Females
3 DALYs, Age-standardized, Males
4 DALYs, Age-standardized, Females
5 YLLs, All Ages, Males
6 YLLs, All Ages, Females
7 YLLs, Age-standardized, Males
8 YLLs, Age-standardized, Females
9 YLDs, All Ages, Males
10 YLDs, All Ages, Females
11 YLDs, Age-standardized, Males 
12 YLDs, Age-standardized, Females

*/


* Metadata for input data described below,
* under each -import delimited using "IHME-GBD_2019_DATA-??.dta"-






***********************************************************************
* Prepare Table S2 Part 1

** Table S2 Part 1:
* DALYs, YLDs and YLLs in Canada in 2019, All Ages and Age-standardized, Males and Females
* Input data: "IHME-GBD_2019_DATA-102.csv"
* Output data: "Table S2 Part1.dta"



* use input data from /data/ folder

cd .. // Canada-Burden-of-Disease-main

cd data

import delimited using "IHME-GBD_2019_DATA-102.csv", clear 

/* "IHME-GBD_2019_DATA-102.csv" Metadata:

Permalink:
https://ghdx.healthdata.org/gbd-results-tool?params=gbd-api-2019-permalink/194355b4181a4e1d97905261d302770b

Data settings:

Base: Single
Location: Canada
Year: 2019

Context: Cause
Age: All-ages, Age-standardized
Metric: Rate

Measure: DALY, YLL, YLD
Sex: Male, Female, Both
Cause: level-3 causes


Download settings: 
Both IDs and Names 
(ID = variable_id, Name = variable_name)

*/


* save output data in /output/ folder

cd .. // Canada-Burden-of-Disease-main

cd output 

drop measure_id location_id location_name age_id metric_id metric_name

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

drop sex_id

gsort measure_id_new age_id_new sex_id_new Year - Value

order Measure Age Sex Year Value Lower_UL Upper_UL

rename cause_name Cause

qui compress

save "IHME-GBD_2019_DATA-102.dta", replace




*****************************
* 1 DALYs, All Ages, Males

use "IHME-GBD_2019_DATA-102.dta",clear

keep if Measure == "DALYs"
keep if Age == "All Ages"
keep if Sex == "Males"

gen rank = _n

keep if rank <= 10

drop Year

save "Canada 2019 1 DALYs, All Ages, Males.dta", replace




*****************************
* 2 DALYs, All Ages, Females

use "IHME-GBD_2019_DATA-102.dta",clear

keep if Measure == "DALYs"
keep if Age == "All Ages"
keep if Sex == "Females"

gen rank = _n

keep if rank <= 10

drop Year

save "Canada 2019 2 DALYs, All Ages, Females.dta", replace






*****************************
* 3 DALYs, Age-standardized, Males

use "IHME-GBD_2019_DATA-102.dta",clear

keep if Measure == "DALYs"
keep if Age == "Age-standardized"
keep if Sex == "Males"

gen rank = _n

keep if rank <= 10

drop Year

save "Canada 2019 3 DALYs, Age-standardized, Males.dta", replace




*****************************
* 4 DALYs, Age-standardized, Females

use "IHME-GBD_2019_DATA-102.dta",clear

keep if Measure == "DALYs"
keep if Age == "Age-standardized"
keep if Sex == "Females"

gen rank = _n

keep if rank <= 10

drop Year

save "Canada 2019 4 DALYs, Age-standardized, Females.dta", replace




*****************************
* 5 YLLs, All Ages, Males

use "IHME-GBD_2019_DATA-102.dta",clear

keep if Measure == "YLLs"
keep if Age == "All Ages"
keep if Sex == "Males"

gen rank = _n

keep if rank <= 10

drop Year

save "Canada 2019 5 YLLs, All Ages, Males.dta", replace




*****************************
* 6 YLLs, All Ages, Females

use "IHME-GBD_2019_DATA-102.dta",clear

keep if Measure == "YLLs"
keep if Age == "All Ages"
keep if Sex == "Females"

gen rank = _n

keep if rank <= 10

drop Year

save "Canada 2019 6 YLLs, All Ages, Females.dta", replace




*****************************
* 7 YLLs, Age-standardized, Males

use "IHME-GBD_2019_DATA-102.dta",clear

keep if Measure == "YLLs"
keep if Age == "Age-standardized"
keep if Sex == "Males"

gen rank = _n

keep if rank <= 10

drop Year

save "Canada 2019 7 YLLs, Age-standardized, Males.dta", replace





*****************************
* 8 YLLs, Age-standardized, Females

use "IHME-GBD_2019_DATA-102.dta",clear

keep if Measure == "YLLs"
keep if Age == "Age-standardized"
keep if Sex == "Females"

gen rank = _n

keep if rank <= 10

drop Year

save "Canada 2019 8 YLLs, Age-standardized, Females.dta", replace





*****************************
* 9 YLDs, All Ages, Males

use "IHME-GBD_2019_DATA-102.dta",clear

keep if Measure == "YLDs"
keep if Age == "All Ages"
keep if Sex == "Males"

gen rank = _n

keep if rank <= 10

drop Year

save "Canada 2019 9 YLDs, All Ages, Males.dta", replace





*****************************
* 10 YLDs, All Ages, Females

use "IHME-GBD_2019_DATA-102.dta",clear

keep if Measure == "YLDs"
keep if Age == "All Ages"
keep if Sex == "Females"

gen rank = _n

keep if rank <= 10

drop Year

save "Canada 2019 10 YLDs, All Ages, Females.dta", replace





*****************************
* 11 YLDs, Age-standardized, Males

use "IHME-GBD_2019_DATA-102.dta",clear

keep if Measure == "YLDs"
keep if Age == "Age-standardized"
keep if Sex == "Males"

gen rank = _n

keep if rank <= 10

drop Year

save "Canada 2019 11 YLDs, Age-standardized, Males.dta", replace

 
 
 
 
*****************************
* 12 YLDs, Age-standardized, Females

use "IHME-GBD_2019_DATA-102.dta",clear

keep if Measure == "YLDs"
keep if Age == "Age-standardized"
keep if Sex == "Females"

gen rank = _n

keep if rank <= 10

drop Year

save "Canada 2019 12 YLDs, Age-standardized, Females.dta", replace 
 
 
 
 

******************************

* append parts of Table S2

use "Canada 2019 1 DALYs, All Ages, Males.dta", clear 
append using "Canada 2019 2 DALYs, All Ages, Females.dta" 
append using "Canada 2019 3 DALYs, Age-standardized, Males.dta"
append using "Canada 2019 4 DALYs, Age-standardized, Females.dta"
append using "Canada 2019 5 YLLs, All Ages, Males.dta"
append using "Canada 2019 6 YLLs, All Ages, Females.dta"
append using "Canada 2019 7 YLLs, Age-standardized, Males.dta"
append using "Canada 2019 8 YLLs, Age-standardized, Females.dta"
append using "Canada 2019 9 YLDs, All Ages, Males.dta"
append using "Canada 2019 10 YLDs, All Ages, Females.dta"
append using "Canada 2019 11 YLDs, Age-standardized, Males.dta"
append using "Canada 2019 12 YLDs, Age-standardized, Females.dta"


replace Cause = "AR Hearing loss" if Cause == "Age-related and other hearing loss"
replace Cause = "Alzheimer's" if Cause == "Alzheimer's disease and other dementias"
replace Cause = "Anxiety" if Cause == "Anxiety disorders"
replace Cause = "Breast ca" if Cause == "Breast cancer"
replace Cause = "COPD" if Cause == "Chronic obstructive pulmonary disease"
replace Cause = "Colorectal ca" if Cause == "Colon and rectum cancer"
replace Cause = "Congenital BD" if Cause == "Congenital birth defects"
replace Cause = "Depression" if Cause == "Depressive disorders"
replace Cause = "Diabetes" if Cause == "Diabetes mellitus"
replace Cause = "Drug use" if Cause == "Drug use disorders"
replace Cause = "Falls" if Cause == "Falls"
replace Cause = "Gynecological" if Cause == "Gynecological diseases"
replace Cause = "Headaches" if Cause == "Headache disorders"
replace Cause = "IHD" if Cause == "Ischemic heart disease"
replace Cause = "LBP" if Cause == "Low back pain"
replace Cause = "Neck pain" if Cause == "Neck pain"
replace Cause = "Neonatal" if Cause == "Neonatal disorders"
replace Cause = "Osteoarthritis" if Cause == "Osteoarthritis"
replace Cause = "Other MSK" if Cause == "Other musculoskeletal disorders"
replace Cause = "Road injuries" if Cause == "Road injuries"
replace Cause = "Self-harm" if Cause == "Self-harm"
replace Cause = "Stroke" if Cause == "Stroke"
replace Cause = "Lung ca" if Cause == "Tracheal, bronchus, and lung cancer"

drop measure_id_new age_id_new sex_id_new rank

order cause_id, last

qui compress

save "Table S2 Part1.dta", replace 















***********************************************************************
* Prepare Table S2 Part 2

** Table S2 Part 2:
* DALYs, YLDs and YLLs in Canada, percent change from 1990 to 2019
* Input data: "IHME-GBD_2019_DATA-103.dta"
* Output data: "Table S2 Part3.dta"




* use input data from /data/ folder

cd .. // Canada-Burden-of-Disease-main

cd data

import delimited using "IHME-GBD_2019_DATA-103.csv", clear 

/* "IHME-GBD_2019_DATA-103.csv" Metadata:

Permalink:
https://ghdx.healthdata.org/gbd-results-tool?params=gbd-api-2019-permalink/f99eff64829dec35200a3936ecc97078

Data settings:

Base: Change
Location: Canada
Year range: 1990-2019

Context: Cause
Age: All-ages, Age-standardized
Metric: Rate

Measure: DALY, YLL, YLD
Sex: Male, Female, Both
Cause: level-3 causes


Download settings: 
Both IDs and Names 
(ID = variable_id, Name = variable_name)

*/



* save output data in /output/ folder

cd .. // Canada-Burden-of-Disease-main

cd output 

drop measure_id location_id location_name age_id metric_id metric_name

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

rename val Value
rename upper Upper_UL
rename lower Lower_UL

* transform proportion to percent
replace Value = Value * 100
replace Upper_UL = Upper_UL * 100
replace Lower_UL = Lower_UL * 100

order Upper_UL, after(Lower_UL)

label var Upper_UL "Upper UL"
label var Lower_UL "Lower UL"

replace Value = round(Value,0.1)
replace Upper_UL = round(Upper_UL,0.1)
replace Lower_UL = round(Lower_UL,0.1)
format Upper_UL Lower_UL Value %5.1f

rename age_name Age
	
drop sex_id

gsort measure_id_new age_id_new sex_id_new - Value

order Measure Age Sex Value Lower_UL Upper_UL

rename Value Change_Value
rename Lower_UL Change_Lower_UL
rename Upper_UL Change_Upper_UL

drop year_start	year_end

rename cause_name Cause

qui compress

save "IHME-GBD_2019_DATA-103.dta", replace

 


*****************************
* 1 DALYs, All Ages, Males

use "IHME-GBD_2019_DATA-103.dta",clear

merge m:m Measure Age Sex cause_id using "Canada 2019 1 DALYs, All Ages, Males.dta"

keep if _merge==3

drop _merge cause_id measure_id_new age_id_new sex_id_new

sort rank

order Measure Age Sex Cause Value Lower_UL Upper_UL  	

qui compress

save "Canada 2019 Base and Change 1 DALYs, All Ages, Males.dta", replace





*****************************
* 2 DALYs, All Ages, Females

use "IHME-GBD_2019_DATA-103.dta",clear

merge m:m Measure Age Sex cause_id using "Canada 2019 2 DALYs, All Ages, Females.dta"

keep if _merge==3

drop _merge cause_id measure_id_new age_id_new sex_id_new

sort rank

order Measure Age Sex Cause Value Lower_UL Upper_UL  	

qui compress

save "Canada 2019 Base and Change 2 DALYs, All Ages, Females.dta", replace






*****************************
* 3 DALYs, Age-standardized, Males

use "IHME-GBD_2019_DATA-103.dta",clear

merge m:m Measure Age Sex cause_id using "Canada 2019 3 DALYs, Age-standardized, Males.dta"

keep if _merge==3

drop _merge cause_id measure_id_new age_id_new sex_id_new

sort rank

order Measure Age Sex Cause Value Lower_UL Upper_UL  	

qui compress

save "Canada 2019 Base and Change 3 DALYs, Age-standardized, Males.dta", replace




*****************************
* 4 DALYs, Age-standardized, Females

use "IHME-GBD_2019_DATA-103.dta",clear

merge m:m Measure Age Sex cause_id using "Canada 2019 4 DALYs, Age-standardized, Females.dta"

keep if _merge==3

drop _merge cause_id measure_id_new age_id_new sex_id_new

sort rank

order Measure Age Sex Cause Value Lower_UL Upper_UL  	

qui compress

save "Canada 2019 Base and Change 4 DALYs, Age-standardized, Females.dta", replace




*****************************
* 5 YLLs, All Ages, Males

use "IHME-GBD_2019_DATA-103.dta",clear

merge m:m Measure Age Sex cause_id using "Canada 2019 5 YLLs, All Ages, Males.dta"

keep if _merge==3

drop _merge cause_id measure_id_new age_id_new sex_id_new

sort rank

order Measure Age Sex Cause Value Lower_UL Upper_UL  	

qui compress

save "Canada 2019 Base and Change 5 YLLs, All Ages, Males.dta", replace




*****************************
* 6 YLLs, All Ages, Females

use "IHME-GBD_2019_DATA-103.dta",clear

merge m:m Measure Age Sex cause_id using "Canada 2019 6 YLLs, All Ages, Females.dta"

keep if _merge==3

drop _merge cause_id measure_id_new age_id_new sex_id_new

sort rank

order Measure Age Sex Cause Value Lower_UL Upper_UL  	

qui compress

save "Canada 2019 Base and Change 6 YLLs, All Ages, Females.dta", replace




*****************************
* 7 YLLs, Age-standardized, Males

use "IHME-GBD_2019_DATA-103.dta",clear

merge m:m Measure Age Sex cause_id using "Canada 2019 7 YLLs, Age-standardized, Males.dta"

keep if _merge==3

drop _merge cause_id measure_id_new age_id_new sex_id_new

sort rank

order Measure Age Sex Cause Value Lower_UL Upper_UL  	

qui compress

save "Canada 2019 Base and Change 7 YLLs, Age-standardized, Males.dta", replace





*****************************
* 8 YLLs, Age-standardized, Females

use "IHME-GBD_2019_DATA-103.dta",clear

merge m:m Measure Age Sex cause_id using "Canada 2019 8 YLLs, Age-standardized, Females.dta"

keep if _merge==3

drop _merge cause_id measure_id_new age_id_new sex_id_new

sort rank

order Measure Age Sex Cause Value Lower_UL Upper_UL  	

qui compress

save "Canada 2019 Base and Change 8 YLLs, Age-standardized, Females.dta", replace





*****************************
* 9 YLDs, All Ages, Males

use "IHME-GBD_2019_DATA-103.dta",clear

merge m:m Measure Age Sex cause_id using "Canada 2019 9 YLDs, All Ages, Males.dta"

keep if _merge==3

drop _merge cause_id measure_id_new age_id_new sex_id_new

sort rank

order Measure Age Sex Cause Value Lower_UL Upper_UL  	

qui compress

save "Canada 2019 Base and Change 9 YLDs, All Ages, Males.dta", replace





*****************************
* 10 YLDs, All Ages, Females

use "IHME-GBD_2019_DATA-103.dta",clear

merge m:m Measure Age Sex cause_id using "Canada 2019 10 YLDs, All Ages, Females.dta"

keep if _merge==3

drop _merge cause_id measure_id_new age_id_new sex_id_new

sort rank

order Measure Age Sex Cause Value Lower_UL Upper_UL  	

qui compress

save "Canada 2019 Base and Change 10 YLDs, All Ages, Females.dta", replace





*****************************
* 11 YLDs, Age-standardized, Males

use "IHME-GBD_2019_DATA-103.dta",clear

merge m:m Measure Age Sex cause_id using "Canada 2019 11 YLDs, Age-standardized, Males.dta"

keep if _merge==3

drop _merge cause_id measure_id_new age_id_new sex_id_new

sort rank

order Measure Age Sex Cause Value Lower_UL Upper_UL  	

qui compress

save "Canada 2019 Base and Change 11 YLDs, Age-standardized, Males.dta", replace

 
 
 
 
*****************************
* 12 YLDs, Age-standardized, Females

use "IHME-GBD_2019_DATA-103.dta",clear

merge m:m Measure Age Sex cause_id using "Canada 2019 12 YLDs, Age-standardized, Females.dta"

keep if _merge==3

drop _merge cause_id measure_id_new age_id_new sex_id_new

sort rank

order Measure Age Sex Cause Value Lower_UL Upper_UL  	

qui compress

save "Canada 2019 Base and Change 12 YLDs, Age-standardized, Females.dta", replace
 
 
 
 

******************************

* append parts of Table S2 - Base and Change 

use "Canada 2019 Base and Change 1 DALYs, All Ages, Males.dta", clear 

append using "Canada 2019 Base and Change 2 DALYs, All Ages, Females.dta"
append using "Canada 2019 Base and Change 3 DALYs, Age-standardized, Males.dta"
append using "Canada 2019 Base and Change 4 DALYs, Age-standardized, Females.dta"
append using "Canada 2019 Base and Change 5 YLLs, All Ages, Males.dta"
append using "Canada 2019 Base and Change 6 YLLs, All Ages, Females.dta"
append using "Canada 2019 Base and Change 7 YLLs, Age-standardized, Males.dta"
append using "Canada 2019 Base and Change 8 YLLs, Age-standardized, Females.dta"
append using "Canada 2019 Base and Change 9 YLDs, All Ages, Males.dta"
append using "Canada 2019 Base and Change 10 YLDs, All Ages, Females.dta"
append using "Canada 2019 Base and Change 11 YLDs, Age-standardized, Males.dta"
append using "Canada 2019 Base and Change 12 YLDs, Age-standardized, Females.dta"


label var Change_Value "Change Value"



replace Cause = "AR Hearing loss" if Cause == "Age-related and other hearing loss"
replace Cause = "Alzheimer's" if Cause == "Alzheimer's disease and other dementias"
replace Cause = "Anxiety" if Cause == "Anxiety disorders"
replace Cause = "Cirrhosis" if Cause == "Cirrhosis and other chronic liver diseases"
replace Cause = "COPD" if Cause == "Chronic obstructive pulmonary disease"
replace Cause = "Colorectal cancer" if Cause == "Colon and rectum cancer"
replace Cause = "Congenital BD" if Cause == "Congenital birth defects"
replace Cause = "Depression" if Cause == "Depressive disorders"
replace Cause = "Diabetes" if Cause == "Diabetes mellitus"
replace Cause = "Drug use" if Cause == "Drug use disorders"
replace Cause = "Falls" if Cause == "Falls"
replace Cause = "Gynecological" if Cause == "Gynecological diseases"
replace Cause = "Headaches" if Cause == "Headache disorders"
replace Cause = "IHD" if Cause == "Ischemic heart disease"
replace Cause = "LBP" if Cause == "Low back pain"
replace Cause = "LRI" if Cause == "Lower respiratory infections"
replace Cause = "Neck pain" if Cause == "Neck pain"
replace Cause = "Neonatal" if Cause == "Neonatal disorders"
replace Cause = "Osteoarthritis" if Cause == "Osteoarthritis"
replace Cause = "Other MSK" if Cause == "Other musculoskeletal disorders"
replace Cause = "Pancreas cancer" if Cause == "Pancreatic cancer"
replace Cause = "Road injuries" if Cause == "Road injuries"
replace Cause = "Self-harm" if Cause == "Self-harm"
replace Cause = "Stroke" if Cause == "Stroke"
replace Cause = "Lung cancer" if Cause == "Tracheal, bronchus, and lung cancer"




gen row = _n

gen dash = "-"
gen Lower_UL_str = strofreal(Lower_UL, "%2.1f")
gen Upper_UL_str = strofreal(Upper_UL, "%2.1f")

egen Value_UI = concat(Lower_UL_str dash Upper_UL_str)
label var Value_UI "Value UI"

order Value_UI, after(Value)
drop dash Lower_UL_str Upper_UL_str

gen Change_Lower_UL_str = strofreal(Change_Lower_UL, "%3.2f")
gen Change_Upper_UL_str = strofreal(Change_Upper_UL, "%3.2f")
gen to = " to "

egen Change_UI = concat(Change_Lower_UL to Change_Upper_UL)
label var Change_UI "Change UI"
	
order Change_UI, after(Change_Value)
drop Change_Lower_UL_str to Change_Upper_UL_str

order rank row, last


qui compress

save "Table S2.dta", replace

export excel using "Table S2.xlsx", replace firstrow(varlabels)







* omit files no longer needed

shell rm -r "Canada 2019 1 DALYs, All Ages, Males.dta"
shell rm -r "Canada 2019 2 DALYs, All Ages, Females.dta"
shell rm -r "Canada 2019 3 DALYs, Age-standardized, Males.dta"
shell rm -r "Canada 2019 4 DALYs, Age-standardized, Females.dta"
shell rm -r "Canada 2019 5 YLLs, All Ages, Males.dta"
shell rm -r "Canada 2019 6 YLLs, All Ages, Females.dta"
shell rm -r "Canada 2019 7 YLLs, Age-standardized, Males.dta"
shell rm -r "Canada 2019 8 YLLs, Age-standardized, Females.dta"
shell rm -r "Canada 2019 9 YLDs, All Ages, Males.dta"
shell rm -r "Canada 2019 10 YLDs, All Ages, Females.dta"
shell rm -r "Canada 2019 11 YLDs, Age-standardized, Males.dta"
shell rm -r "Canada 2019 12 YLDs, Age-standardized, Females.dta"


shell rm -r "Table S2 Part1.dta"



shell rm -r "Canada 2019 Base and Change 1 DALYs, All Ages, Males.dta"
shell rm -r "Canada 2019 Base and Change 2 DALYs, All Ages, Females.dta"
shell rm -r "Canada 2019 Base and Change 3 DALYs, Age-standardized, Males.dta"
shell rm -r "Canada 2019 Base and Change 4 DALYs, Age-standardized, Females.dta"
shell rm -r "Canada 2019 Base and Change 5 YLLs, All Ages, Males.dta"
shell rm -r "Canada 2019 Base and Change 6 YLLs, All Ages, Females.dta"
shell rm -r "Canada 2019 Base and Change 7 YLLs, Age-standardized, Males.dta"
shell rm -r "Canada 2019 Base and Change 8 YLLs, Age-standardized, Females.dta"
shell rm -r "Canada 2019 Base and Change 9 YLDs, All Ages, Males.dta"
shell rm -r "Canada 2019 Base and Change 10 YLDs, All Ages, Females.dta"
shell rm -r "Canada 2019 Base and Change 11 YLDs, Age-standardized, Males.dta"
shell rm -r "Canada 2019 Base and Change 12 YLDs, Age-standardized, Females.dta"







**********************

view "log Table S2.smcl"

log close

cd ..

cd code

exit, clear
