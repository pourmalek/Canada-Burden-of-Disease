
clear all

cd "$pathCanadaBOD"

cd output

capture log close 

log using "log Table 3.smcl", replace

***************************************************************************
* This is "do Table 3.do"

* Project: Canada Burden of Disease                                                                        
* Person: Farshad Pourmalek pourmalek_farshad at yahoo dotcom
* Time (initial): 2022 March 28
***************************************************************************


** Prepares Table 3
* Table 3: Top 10 level 3 causes of DALYs, YLDs and YLLs in 1990 and 2019 by sex, 
* all ages and age-standardized.


* Metadata for input data described below,
* under each -import delimited using "IHME-GBD_2019_DATA-??.csv"-


** Table 3 Part 1: DALYs, 1990
* Input data: "IHME-GBD_2019_DATA-31.csv"
* Output data: "Table 3 Part1.dta"

** Table 3 Part 2: DALYs, 2019
* Input data: "IHME-GBD_2019_DATA-31.csv"
* Output data: "Table 3 Part2.dta"

** Table 3 Part 3: YLLs, 1990
* Input data: "IHME-GBD_2019_DATA-31.csv"
* Output data: "Table 3 Part3.dta"

** Table 3 Part 4: YLLs, 2019
* Input data: "IHME-GBD_2019_DATA-31.csv"
* Output data: "Table 3 Part4.dta"

** Table 3 Part 5: YLDs, 1990
* Input data: "IHME-GBD_2019_DATA-31.csv"
* Output data: "Table 3 Part5.dta"

** Table 3 Part 6: YLDs, 2019
* Input data: "IHME-GBD_2019_DATA-31.csv"
* Output data: "Table 3 Part6.dta"





***********************************************************************
* Prepare Table 3 Part1

* Top 10 level 3 causes of DALYs in 1990 and 2019 by sex, All ages and Age-Standardized 



* use input data from /data/ folder

cd .. // Canada-Burden-of-Disease-main

cd data

import delimited using "IHME-GBD_2019_DATA-31.csv", clear 


/* "IHME-GBD_2019_DATA-31.csv" Metadata:

Permalink:
https://ghdx.healthdata.org/gbd-results-tool?params=gbd-api-2019-permalink/58b240731c27fc1c0d876614e96818d9

Data settings:

Base: Single
Location: Canada
Year: 1990, 2000, 2010, 2019

Context: Cause
Age: All Ages, Age-standardized
Metric: Rate

Measure: DALY, YLL, YLD
Sex: Male, Female, Both
Cause: level 3 causes (169 causes)


Download settings: 
Both IDs and Names 
(ID = variable_id, Name = variable_name)

*/


* save output data in /output/ folder

cd .. // Canada-Burden-of-Disease-main

cd output 


drop measure_id location_id location_name age_id metric_id metric_name


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


sort measure_id sex_id_new age_id_new Year cause_id


order Sex, after(Age)

keep if Year == 1990 | Year == 2019

* gen Sex-Year-Age combinations

egen Sex_Year_Age = group(Sex Year Age), lname(name)

label var Sex_Year_Age "Sex-Year-Age group"

order cause_id, last

save "IHME-GBD_2019_DATA-31.dta", replace


	
keep if Measure == "DALYs"

bysort Sex_Year_Age: egen rank = rank(-Value)

label var rank "rank of mean DALYs within Sex-Year-Age group"

sort Sex_Year_Age rank

drop if Sex == "Both sexes"

drop Value Lower_UL Upper_UL measure_id_new cause_id

order Measure Age Sex Year rank Cause

sort age_id_new sex_id_new Year rank

keep if rank <= 10

drop Sex_Year_Age 

reshape wide rank, i(Cause Age Sex) j(Year)

save "IHME-GBD_2019_DATA-31 DALYs.dta", replace 




* DALYs 1990

use "IHME-GBD_2019_DATA-31 DALYs.dta", clear 

keep Age Sex Cause rank1990 age_id_new sex_id_new Measure

order Measure, last

sort age_id_new sex_id_new rank1990

drop if rank1990 == . 

drop age_id_new	sex_id_new	

rename Cause Cause1990

gen row = _n

save "Table 3 Part1.dta", replace



* DALYs 2019

use "IHME-GBD_2019_DATA-31 DALYs.dta", clear 

keep Age Sex Cause rank2019 age_id_new sex_id_new Measure

order Measure, last

sort age_id_new sex_id_new rank2019

drop if rank2019 == . 

drop age_id_new	sex_id_new	

rename Cause Cause2019

gen row = _n

save "Table 3 Part2.dta", replace






***********************************************************************
* Prepare Table 3 Part2

* Top 10 level 3 causes of YLLs in 1990 and 2019 by sex, All ages and Age-Standardized 



* use input data from /data/ folder

cd .. // Canada-Burden-of-Disease-main

cd data

import delimited using "IHME-GBD_2019_DATA-31.csv", clear 


/* "IHME-GBD_2019_DATA-31.csv" Metadata:

See Metadata above
*/


* save output data in /output/ folder

cd .. // Canada-Burden-of-Disease-main

cd output 


drop measure_id location_id location_name age_id metric_id metric_name


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


sort measure_id sex_id_new age_id_new Year cause_id


order Sex, after(Age)

keep if Year == 1990 | Year == 2019

* gen Sex-Year-Age combinations

egen Sex_Year_Age = group(Sex Year Age), lname(name)

label var Sex_Year_Age "Sex-Year-Age group"

order cause_id, last

save "IHME-GBD_2019_DATA-31.dta", replace



keep if Measure == "YLLs"

bysort Sex_Year_Age: egen rank = rank(-Value)

label var rank "rank of mean YLLs within Sex-Year-Age group"

sort Sex_Year_Age rank

drop if Sex == "Both sexes"

drop Value Lower_UL Upper_UL measure_id_new cause_id

order Measure Age Sex Year rank Cause

sort age_id_new sex_id_new Year rank

keep if rank <= 10

drop Sex_Year_Age 

reshape wide rank, i(Cause Age Sex) j(Year)

save "IHME-GBD_2019_DATA-31 YLLs.dta", replace 




* YLLs 1990

use "IHME-GBD_2019_DATA-31 YLLs.dta", clear 

keep Age Sex Cause rank1990 age_id_new sex_id_new Measure

order Measure, last

sort age_id_new sex_id_new rank1990 Measure

order Measure, last

drop if rank1990 == . 

drop age_id_new	sex_id_new	

gen row = _n

rename Cause Cause1990

save "Table 3 Part3.dta", replace



* YLLs 2019

use "IHME-GBD_2019_DATA-31 YLLs.dta", clear 

keep Age Sex Cause rank2019 age_id_new sex_id_new Measure

order Measure, last

sort age_id_new sex_id_new rank2019 Measure

order Measure, last

drop if rank2019 == . 

drop age_id_new	sex_id_new	

gen row = _n

rename Cause Cause2019

save "Table 3 Part4.dta", replace











***********************************************************************
* Prepare Table 3 Part2

* Top 10 level 3 causes of YLDs in 1990 and 2019 by sex, All ages and Age-Standardized 


* use input data from /data/ folder

cd .. // Canada-Burden-of-Disease-main

cd data

import delimited using "IHME-GBD_2019_DATA-31.csv", clear 


/* "IHME-GBD_2019_DATA-31.csv" Metadata:

See Metadata above
*/


* save output data in /output/ folder

cd .. // Canada-Burden-of-Disease-main

cd output 


drop measure_id location_id location_name age_id metric_id metric_name


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


sort measure_id sex_id_new age_id_new Year cause_id


order Sex, after(Age)

keep if Year == 1990 | Year == 2019

* gen Sex-Year-Age combinations

egen Sex_Year_Age = group(Sex Year Age), lname(name)

label var Sex_Year_Age "Sex-Year-Age group"

order cause_id, last

save "IHME-GBD_2019_DATA-31.dta", replace



keep if Measure == "YLDs"

bysort Sex_Year_Age: egen rank = rank(-Value)

label var rank "rank of mean YLDs within Sex-Year-Age group"

sort Sex_Year_Age rank

drop if Sex == "Both sexes"

drop Value Lower_UL Upper_UL measure_id_new cause_id

order Measure Age Sex Year rank Cause

sort age_id_new sex_id_new Year rank

keep if rank <= 10

drop Sex_Year_Age 

reshape wide rank, i(Cause Age Sex) j(Year)

save "IHME-GBD_2019_DATA-31 YLDs.dta", replace 




* YLDs 1990

use "IHME-GBD_2019_DATA-31 YLDs.dta", clear 

keep Age Sex Cause rank1990 age_id_new sex_id_new Measure

order Measure, last

sort age_id_new sex_id_new rank1990 Measure 

order Measure, last

drop if rank1990 == . 

drop age_id_new	sex_id_new	

gen row = _n

rename Cause Cause1990

save "Table 3 Part5.dta", replace



* YLDs 2019

use "IHME-GBD_2019_DATA-31 YLDs.dta", clear 

keep Age Sex Cause rank2019 age_id_new sex_id_new Measure

order Measure, last

sort age_id_new sex_id_new rank2019 Measure

order Measure, last

drop if rank2019 == . 

drop age_id_new	sex_id_new	

gen row = _n

rename Cause Cause2019

save "Table 3 Part6.dta", replace








*************************************************************************

* merge DALYs 1990 and DALYs 2019 

use "Table 3 Part1.dta", clear

merge m:m row using "Table 3 Part2.dta"

drop _merge

order Measure

order row, last

order rank1990, before(Cause1990)
order rank2019, before(Cause2019)

rename Cause1990 DALYsCause1990
rename Cause2019 DALYsCause2019

save "Table 3 Part1and2.dta", replace







*************************************************************************

* merge YLLs 1990 and DALYs 2019 

use "Table 3 Part3.dta", clear

merge m:m row using "Table 3 Part4.dta"

drop _merge

order Measure

order row, last

order rank1990, before(Cause1990)
order rank2019, before(Cause2019)

rename Cause1990 YLLsCause1990
rename Cause2019 YLLsCause2019

save "Table 3 Part3and4.dta", replace








*************************************************************************

* merge YLDs 1990 and DALYs 2019 

use "Table 3 Part5.dta", clear

merge m:m row using "Table 3 Part6.dta"

drop _merge

order Measure

order row, last

order rank1990, before(Cause1990)
order rank2019, before(Cause2019)

rename Cause1990 YLDsCause1990
rename Cause2019 YLDsCause2019

save "Table 3 Part5and6.dta", replace









*************************************************************************

* append DALYs, YLLS, and YLDs 

use "Table 3 Part1and2.dta", clear

merge m:m row using "Table 3 Part3and4.dta"

drop _merge

rename rank1990 Rank

drop rank2019

drop Measure

merge m:m row using "Table 3 Part5and6.dta"

drop _merge

drop rank1990 rank2019 row Measure




foreach var in DALYsCause1990 DALYsCause2019 YLLsCause1990 YLLsCause2019 YLDsCause1990 YLDsCause2019 {
	qui {
replace `var' = "Alzheimer’s" if `var' == "Alzheimer's disease and other dementias"
replace `var' = "Anxiety" if `var' == "Anxiety disorders"
replace `var' = "Breast cancer" if `var' == "Breast cancer"
replace `var' = "COPD" if `var' == "Chronic obstructive pulmonary disease"
replace `var' = "Cirrhosis" if `var' == "Cirrhosis and other chronic liver diseases"
replace `var' = "Colrectal Ca" if `var' == "Colon and rectum cancer"
replace `var' = "Congenital" if `var' == "Congenital birth defects"
replace `var' = "Depression" if `var' == "Depressive disorders"
replace `var' = "Diabetes" if `var' == "Diabetes mellitus"
replace `var' = "Drug use" if `var' == "Drug use disorders"
replace `var' = "Falls" if `var' == "Falls"
replace `var' = "Gynecological" if `var' == "Gynecological diseases"
replace `var' = "Headaches" if `var' == "Headache disorders"
replace `var' = "Hearing loss" if `var' == "Age-related and other hearing loss"
replace `var' = "IHD" if `var' == "Ischemic heart disease"
replace `var' = "LBP" if `var' == "Low back pain"
replace `var' = "LRI" if `var' == "Lower respiratory infections"
replace `var' = "Lung cancer" if `var' == "Tracheal, bronchus, and lung cancer"
replace `var' = "Neck pain" if `var' == "Neck pain"
replace `var' = "Neonatal" if `var' == "Neonatal disorders"
replace `var' = "Neonatal dis" if `var' == "Neonatal disorders"
replace `var' = "Oral disorders" if `var' == "Oral disorders"
replace `var' = "Osteoarthritis" if `var' == "Osteoarthritis"
replace `var' = "Other MSK" if `var' == "Other musculoskeletal disorders"
replace `var' = "Pancreatic Ca" if `var' == "Pancreatic cancer"
replace `var' = "Prostate Ca" if `var' == "Prostate cancer"
replace `var' = "Road injuries" if `var' == "Road injuries"
replace `var' = "Self-harm" if `var' == "Self-harm"
replace `var' = "Stroke" if `var' == "Stroke"
	}
}
*

qui compress


save "Table 3.dta", replace

export excel using "Table 3.xlsx", replace firstrow(varlabels)




********

* remove files no longer needed

shell rm -r "IHME-GBD_2019_DATA-31 DALYs 1990.dta"
shell rm -r "IHME-GBD_2019_DATA-31 DALYs 2019.dta"
shell rm -r "IHME-GBD_2019_DATA-31 DALYs.dta"
shell rm -r "IHME-GBD_2019_DATA-31 YLDs.dta"
shell rm -r "IHME-GBD_2019_DATA-31 YLLs.dta"
shell rm -r "Table 3 Part1.dta"
shell rm -r "Table 3 Part1and2.dta"
shell rm -r "Table 3 Part2.dta"
shell rm -r "Table 3 Part3.dta"
shell rm -r "Table 3 Part3and4.dta"
shell rm -r "Table 3 Part4.dta"
shell rm -r "Table 3 Part5.dta"
shell rm -r "Table 3 Part5and6.dta"
shell rm -r "Table 3 Part6.dta"

























**********************

view "log Table 3.smcl"

log close

cd ..

cd code

exit, clear
