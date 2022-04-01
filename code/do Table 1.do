
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



** Prepares Table 1
* Table 1: Crude (all-age) and age-standardized summary measures of population health indicators 
* in Canada for males and females in 1990 and 2019


* Metadata for input data described below,
* under each -import delimited using "IHME-GBD_2019_DATA-??.csv"-


** Table 1 Part 1: DALYs YLLs YLDs, base values 1990 and 2019
* Input data: "IHME-GBD_2019_DATA-1.csv"
* Output data: "Table 1 Part1.dta"

** Table 1 Part 2: DALYs YLLs YLDs, change % from 1990 to 2019
* Input data: "IHME-GBD_2019_DATA-2.csv"
* Output data: "Table 1 Part2.dta"

** Table 1 Part 3: DALYs YLLs YLDs, change % from 1990 to 2019
* Input data: "IHME-GBD_2019_DATA-3.csv"
* Output data: "Table 1 Part3.dta"

** Table 1 Part 4: Life expectancy (at birth) % from 1990 to 2019
* Input data: "IHME-GBD_2019_DATA-3.dta"
* Output data: "Table 1 Part4.dta"

** Table 1 Part 5: Post-neonatal infant mortality rate 1990 2019
* Input data: "IHME-GBD_2019_DATA-4.csv"
* Output data: "Table 1 Part5.dta"

** Table 1 Part 6: Post-neonatal infant mortality rate % change 1990 to 2019
* Input data: "IHME-GBD_2019_DATA-4.csv"
* Output data: "Table 1 Part6.dta"



***********************************************************************
* Prepare Table 1 Part 1

* DALYs YLLs YLDs base values 1990 and 2019


* use input data from /data/ folder

cd .. // Canada-Burden-of-Disease-main

cd data

import delimited using "IHME-GBD_2019_DATA-1.csv", clear 

/* "IHME-GBD_2019_DATA-1.csv" Metadata:

Permalink:
https://ghdx.healthdata.org/gbd-results-tool?params=gbd-api-2019-permalink/47b4b82e1c612fb0cbc5e0f286cb2a1d


Data settings:

Base: Single
Location: Canada
Year: 1990, 2000, 2010, 2019

Context: Cause
Age: All-ages, Age-standardized
Metric: Rate

Measure: DALY, YLL, YLD
Sex: Male, Female, Both
Cause: Total All Causes


Download settings: 
Both IDs and Names 
(ID = variable_id, Name = variable_name)

*/


* save output data in /output/ folder

cd .. // Canada-Burden-of-Disease-main

cd output 



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

order Measure Age Sex Year Value Lower_UL Upper_UL

sort age_id_new sex_id_new Year

reshape wide Value Lower_UL Upper_UL, i(Measure Age	Sex) j(Year)

drop sex_id measure_id_new age_id_new sex_id_new

label var Value1990	"1990 Value"
label var Lower_UL1990 "1990 Lower_UL"
label var Upper_UL1990 "1990 Upper_UL"
label var Value2019 "2019 Value"
label var Lower_UL2019 "2019 Lower_UL"
label var Upper_UL2019 "2019 Upper_UL"


save "Table 1 Part1.dta", replace


/* "Table 1 Part1.dta" contents

Base values of 1990 and 2019

Value	Lower UL	Upper UL

DALYs YLLs YLDs

Both sexes	Males	Females

All ages	Age-standardized

*/
				






***********************************************************************
* Prepare Table 1 Part 2

* DALYs YLLs YLDs change % from 1990 to 2019


* use input data from /data/ folder

cd .. // Canada-Burden-of-Disease-main

cd data

import delimited using "IHME-GBD_2019_DATA-2.csv", clear 



/* "IHME-GBD_2019_DATA-2.csv" Metadata:

Permalink:
https://ghdx.healthdata.org/gbd-results-tool?params=gbd-api-2019-permalink/abba564428b723f55bc1f4893394ac39

Data settings:

Base: Change
Location: Canada
Year range: 1990-2010, 1990-2019, 2010-2019

Context: Cause
Age: All-ages, Age-standardized
Metric: Rate

Measure: DALY, YLL, YLD
Sex: Male, Female, Both
Cause: Total All Causes


Download settings: 
Both IDs and Names 
(ID = variable_id, Name = variable_name)

*/


* save output data in /output/ folder

cd .. // Canada-Burden-of-Disease-main

cd output 



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
label var Upper_UL "Upper UL"
label var Lower_UL "Lower UL"

order Upper_UL, after(Lower_UL)

replace Value = round(Value,0.01)
replace Upper_UL = round(Upper_UL,0.1)
replace Lower_UL = round(Lower_UL,0.1)
format Value Upper_UL Lower_UL %5.2f

rename age_name Age
	
rename year_start Year_start	
rename year_end Year_end
  
  
sort measure_id_new sex_id_new age_id_new 

drop sex_id	measure_id_new sex_id_new age_id_new

order Sex, after(Age)

drop Lower_UL Upper_UL

order Measure Age Sex Value 

rename Value Relative_change_pct

label var Relative_change_pct "Relative change (%)"

keep if Year_start == 1990 & Year_end == 2019 

  
save "Table 1 Part2.dta", replace
  
  
/* "Table 1 Part2.dta" contents

Relative change (%) from 1990 to 2019

Value	(without Lower UL	Upper UL)

DALYs YLLs YLDs

Both sexes	Males	Females

All ages	Age-standardized

*/











***********************************************************************
* Prepare Table 1 Part 3

* Life expectancy (at birth) base values 1990 and 2019


* use input data from /data/ folder

cd .. // Canada-Burden-of-Disease-main

cd data

import delimited using "IHME-GBD_2019_DATA-3.csv", clear 



/* "IHME-GBD_2019_DATA-3.csv" Metadata:

Permalink:
https://ghdx.healthdata.org/gbd-results-tool?params=gbd-api-2019-permalink/788221935a962b8350f191fa1f265340

Data settings:

Base: Single
Location: Canada
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


drop measure_id	location_id	location_name	sex_id	age_id	metric_id	metric_name

rename measure_name Measure

rename age_name Age
replace Age = "At birth"

rename val Value
rename upper Upper_UL
rename lower Lower_UL
label var Upper_UL "Upper UL"
label var Lower_UL "Lower UL"

order Upper_UL, after(Lower_UL)

replace Value = round(Value,0.01)
replace Upper_UL = round(Upper_UL,0.1)
replace Lower_UL = round(Lower_UL,0.1)
format Value Upper_UL Lower_UL %5.2f

gen sex_id_new = .
replace sex_id_new = 1 if sex_name == "Both"
replace sex_id_new = 2 if sex_name == "Male"
replace sex_id_new = 3 if sex_name == "Female"

rename sex_name Sex
replace Sex = "Both sexes" if Sex == "Both"
replace Sex = "Males" if Sex == "Male"
replace Sex = "Females" if Sex == "Female"

sort sex_id_new  

drop sex_id_new sex_id_new 

order Sex, after(Age)

rename year Year

keep if Year == 1990 | Year == 2019


order Measure Age Sex Year Value Lower_UL Upper_UL


gen sex_id_new = .
replace sex_id_new = 1 if Sex == "Both sexes"
replace sex_id_new = 2 if Sex == "Males"
replace sex_id_new = 3 if Sex == "Females"

sort sex_id_new Year


reshape wide Value Lower_UL Upper_UL, i(Measure Age	Sex) j(Year)

drop sex_id_new

label var Value1990	"1990 Value"
label var Lower_UL1990 "1990 Lower_UL"
label var Upper_UL1990 "1990 Upper_UL"
label var Value2019 "2019 Value"
label var Lower_UL2019 "2019 Lower_UL"
label var Upper_UL2019 "2019 Upper_UL"


rename (Value1990 Lower_UL1990 Upper_UL1990 Value2019 Lower_UL2019 Upper_UL2019) ///
(Y_1990_Value Y_1990_Lower_UL Y_1990_Upper_UL Y_2019_Value Y_2019_Lower_UL Y_2019_Upper_UL)


save "Table 1 Part3.dta", replace


/* "Table 1 Part3.dta" contents

Life expectancy at birth 1990 2010

Both sexes	Males	Females


*/











***********************************************************************
* Prepare Table 1 Part 4

* Life expectancy (at birth) % from 1990 to 2019


* use input data from /output/ folder // Note: % change from year to year not working for Life expectancy


use "Table 1 Part3.dta", clear

// use "Table 1 Part3 long.dta", clear

// use "IHME-GBD_2019_DATA-3.dta", clear



// reshape wide Value Upper_UL Lower_UL, i(Sex) j(Year)

// order Measure Age




gen sex_id_new = .
replace sex_id_new = 1 if Sex == "Both"
replace sex_id_new = 2 if Sex == "Male"
replace sex_id_new = 3 if Sex == "Female"
sort sex_id_new 
drop sex_id_new



* gen % Change = 100 * (New - Old) / Old

gen ChangeValue1990_2019 = 100 * (Y_2019_Value - Y_1990_Value) / Y_1990_Value
gen ChangeLower_UL1990_2019 = 100 * (Y_2019_Lower_UL - Y_1990_Lower_UL) / Y_1990_Lower_UL
gen ChangeUpper_UL1990_2019 = 100 * (Y_2019_Upper_UL - Y_1990_Upper_UL) / Y_1990_Upper_UL


keep Measure Age Sex ChangeValue1990_2019 ChangeUpper_UL1990_2019 ChangeLower_UL1990_2019


replace Measure = "Life expectancy % Change 1990 to 2019"

rename ChangeValue1990_2019 Value
rename ChangeUpper_UL1990_2019 Upper_UL
rename ChangeLower_UL1990_2019 Lower_UL

label var Upper_UL "Upper UL"
label var Lower_UL "Lower UL"

replace Value = round(Value,0.01)
replace Upper_UL = round(Upper_UL,0.1)
replace Lower_UL = round(Lower_UL,0.1)
format Value Upper_UL Lower_UL %5.2f



order Measure Age Sex Value 

rename Value Relative_change_pct

label var Relative_change_pct "Relative change (%)"

drop Lower_UL Upper_UL


* save output data in /output/ folder

save "Table 1 Part4.dta", replace 



/* "Table 1 Part4.dta" contents

Life expectancy at birth % change from 1990 to 2019

Both sexes	Males	Females

*/














***********************************************************************
* Prepare Table 1 Part 5

* Post-neonatal infant mortality rate 1990 2019


* use input data from /data/ folder

cd .. // Canada-Burden-of-Disease-main

cd data

import delimited using "IHME-GBD_2019_DATA-4.csv", clear 


drop measure_id	location_id	location_name sex_id age_id metric_id metric_name cause_id


rename measure_name Measure

replace Measure = "Mortality rate" 


rename age_name Age
replace Age = "Post Neonatal"

rename val Value
rename upper Upper_UL
rename lower Lower_UL
label var Upper_UL "Upper UL"
label var Lower_UL "Lower UL"

order Upper_UL, after(Lower_UL)

replace Value = round(Value,0.01)
replace Upper_UL = round(Upper_UL,0.1)
replace Lower_UL = round(Lower_UL,0.1)
format Value Upper_UL Lower_UL %5.2f

gen sex_id_new = .
replace sex_id_new = 1 if sex_name == "Both"
replace sex_id_new = 2 if sex_name == "Male"
replace sex_id_new = 3 if sex_name == "Female"

rename sex_name Sex
replace Sex = "Both sexes" if Sex == "Both"
replace Sex = "Males" if Sex == "Male"
replace Sex = "Females" if Sex == "Female"

sort sex_id_new  

drop sex_id_new sex_id_new 

order Sex, after(Age)

rename year Year

gen sex_id_new = .
replace sex_id_new = 1 if Sex == "Both"
replace sex_id_new = 2 if Sex == "Male"
replace sex_id_new = 3 if Sex == "Female"
sort sex_id_new 
drop sex_id_new

replace Value = round(Value,0.01)
replace Upper_UL = round(Upper_UL,0.1)
replace Lower_UL = round(Lower_UL,0.1)
format Value Upper_UL Lower_UL %5.2f


keep if Year == 1990 | Year == 2019


order Measure Age Sex Year Value Lower_UL Upper_UL


gen sex_id_new = .
replace sex_id_new = 1 if Sex == "Both sexes"
replace sex_id_new = 2 if Sex == "Males"
replace sex_id_new = 3 if Sex == "Females"

sort sex_id_new Year


reshape wide Value Lower_UL Upper_UL, i(Measure Age	Sex) j(Year)

drop sex_id_new

label var Value1990	"1990 Value"
label var Lower_UL1990 "1990 Lower_UL"
label var Upper_UL1990 "1990 Upper_UL"
label var Value2019 "2019 Value"
label var Lower_UL2019 "2019 Lower_UL"
label var Upper_UL2019 "2019 Upper_UL"


rename (Value1990 Lower_UL1990 Upper_UL1990 Value2019 Lower_UL2019 Upper_UL2019) ///
(Y_1990_Value Y_1990_Lower_UL Y_1990_Upper_UL Y_2019_Value Y_2019_Lower_UL Y_2019_Upper_UL)

replace Measure = "Post-neonatal infant mortality"

drop cause_name


* save output data in /output/ folder

cd .. // Canada-Burden-of-Disease-main

cd output 



save "Table 1 Part5.dta", replace 


/* "Table 1 Part5.dta" contents

Postneonatal Mortality Rate 1990 and 2019

Both sexes	Males	Females

*/







***********************************************************************
* Prepare Table 1 Part 6

* Post-neonatal infant mortality rate, % change 1990 to 2019



* use input data from /data/ folder

cd .. // Canada-Burden-of-Disease-main

cd data

import delimited using "IHME-GBD_2019_DATA-5.csv", clear 


/* "IHME-GBD_2019_DATA-5.csv" Metadata:

Permalink:
https://ghdx.healthdata.org/gbd-results-tool?params=gbd-api-2019-permalink/5399b053ee07e05980e588f9dabf449e


Data settings:

Base: Change
Location: Canada
Year range: 1990-2019

Context: Cause
Age: Post Neonatal
Metric: Rate

Measure: Deaths
Sex: Male, Female, Both
Cause: Total All Causes


Download settings: 
Both IDs and Names 
(ID = variable_id, Name = variable_name)

*/




drop measure_id	location_id	location_name sex_id age_id metric_id metric_name cause_id


rename measure_name Measure

replace Measure = "Mortality rate" 


rename age_name Age
replace Age = "Post Neonatal"

rename val Value
rename upper Upper_UL
rename lower Lower_UL
label var Upper_UL "Upper UL"
label var Lower_UL "Lower UL"

order Upper_UL, after(Lower_UL)

replace Value = round(Value,0.01)
replace Upper_UL = round(Upper_UL,0.1)
replace Lower_UL = round(Lower_UL,0.1)
format Value Upper_UL Lower_UL %5.2f

gen sex_id_new = .
replace sex_id_new = 1 if sex_name == "Both"
replace sex_id_new = 2 if sex_name == "Male"
replace sex_id_new = 3 if sex_name == "Female"

rename sex_name Sex
replace Sex = "Both sexes" if Sex == "Both"
replace Sex = "Males" if Sex == "Male"
replace Sex = "Females" if Sex == "Female"

sort sex_id_new  

drop sex_id_new sex_id_new 

order Sex, after(Age)



gen sex_id_new = .
replace sex_id_new = 1 if Sex == "Both"
replace sex_id_new = 2 if Sex == "Male"
replace sex_id_new = 3 if Sex == "Female"
sort sex_id_new 
drop sex_id_new

replace Value = round(Value,0.01)
replace Upper_UL = round(Upper_UL,0.1)
replace Lower_UL = round(Lower_UL,0.1)
format Value Upper_UL Lower_UL %5.2f


order Measure Age Sex Value Lower_UL Upper_UL

replace Measure = "Post-neonatal infant mortality"

drop Lower_UL Upper_UL cause_name year_start year_end


* save output data in /output/ folder

cd .. // Canada-Burden-of-Disease-main

cd output 


save "Table 1 Part6.dta", replace 


/* "Table 1 Part6.dta" contents

Postneonatal Mortality Rate % change 1990 to 2019

Both sexes	Males	Females

*/


















************************************************************************
* merge DALYs, YLLs, YLDs, Base values and relative changes

use "Table 1 Part1.dta", clear 

merge 1:1 Measure Age Sex using "Table 1 Part2.dta"

drop Year_start Year_end _merge

rename (Value1990 Lower_UL1990 Upper_UL1990 Value2019 Lower_UL2019 Upper_UL2019) ///
(Y_1990_Value Y_1990_Lower_UL Y_1990_Upper_UL Y_2019_Value Y_2019_Lower_UL Y_2019_Upper_UL)

save "Table 1 Part1and2.dta", replace 










************************************************************************
* merge Life expectancy, Base values and relative changes

use "Table 1 Part3.dta", clear 

merge 1:1 Age Sex using "Table 1 Part4.dta"

drop _merge

qui compress

save "Table 1 Part3and4.dta", replace 












************************************************************************
* merge Post-neonatal mortality rate, Base values and relative changes

use "Table 1 Part5.dta", clear 

merge 1:1 Sex using "Table 1 Part6.dta"

drop _merge

rename Value Relative_change_pct

qui compress

save "Table 1 Part5and6.dta", replace 






************************************************************************
* append (DALYs, YLLs, YLDs), (Life expectancy), (Post-neonatal mortality rate)

use "Table 1 Part1and2.dta", clear

append using  "Table 1 Part3and4.dta"

append using  "Table 1 Part5and6.dta"

save "Table 1.dta", replace

export excel using "Table 1.xlsx", replace firstrow(varlabels)






********

* remove files no longer needed

shell rm -r "Table 1 Part1.dta"
shell rm -r "Table 1 Part1and2.dta"
shell rm -r "Table 1 Part2.dta"
shell rm -r "Table 1 Part3.dta"
shell rm -r "Table 1 Part3and4.dta"
shell rm -r "Table 1 Part4.dta"
shell rm -r "Table 1 Part5.dta"
shell rm -r "Table 1 Part5and6.dta"
shell rm -r "Table 1 Part3.dta"
shell rm -r "Table 1 Part6.dta"












**********************

view "log Table 1.smcl"

log close

cd ..

cd code

exit, clear
