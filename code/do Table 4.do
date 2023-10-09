
clear all

cd "$pathCanadaBOD"

cd output

capture log close 

log using "log Table 4.smcl", replace

***************************************************************************
* This is "do Table 4.do"

* Project: Canada Burden of Disease                                                                        
* Person: Farshad Pourmalek
* Time (initial): 2022 March 28
***************************************************************************


** Prepares Table 4
* Table 4: Canada's global rank position for five health indicators, 1990 to 2019 



* Metadata for input data described below,
* under each -import delimited using "IHME-GBD_2019_DATA-??.csv"-


** Table 4 Part 1: DALYs, Age-standardized
* Input data: "IHME-GBD_2019_DATA-41.csv"
* Output data: "Table 4 Part1.dta"




***********************************************************************
* Prepare Table 4 Part1, DALYS

* Table 4: Canada's global rank position for five health indicators, 1990 to 2019 

* DALYS	1990	2000	2010	2019

* (age-standardized rates)
*    Both	
*    Male	
*    Female	



* use input data from /data/ folder

cd .. // Canada-Burden-of-Disease-main

cd data

import delimited using "IHME-GBD_2019_DATA-41.csv", clear 


/* "IHME-GBD_2019_DATA-41.csv" Metadata:

Permalink:
https://ghdx.healthdata.org/gbd-results-tool?params=gbd-api-2019-permalink/e5609fd1e940e488c706d26f04c53112

Data settings:

Base: Single
Location: Countries and territories (204)
Year: 1990, 2000, 2010, 2019

Context: Cause
Age: Age-standardized
Metric: Rate

Measure: DALYs
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
replace Measure = "DALYs" if Measure == "DALYs (Disability-Adjusted Life Years)"
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


* gen Sex-Year combinations  

egen Sex_Year = group(Sex Year), lname(name)

label var Sex_Year "Sex-Year group"

save "IHME-GBD_2019_DATA-41.dta", replace


* for DALYs 1990 2000 2010 2019 Age-standardized
	
keep if Measure == "DALYs"

bysort Sex_Year: egen rank = rank(Value)

label var rank "rank of mean DALYs within Sex-Year group"

sort Sex_Year rank

label var location_name "Country"

keep if location_name == "Canada"

*

drop Value Lower_UL Upper_UL Sex_Year

drop location_name Cause

order Measure Sex Age rank 

reshape wide rank, i(Measure Sex Age) j(Year)

sort sex_id_new

drop sex_id_new

qui compress

save "Table 4 Part1.dta", replace


/* "Table 4 Part1.dta" contents

Base values of 1990 2000 2010 2019

Value	Lower UL	Upper UL

DALYs 

Both sexes	Males	Females

Age-standardized	

All causes

*/





***********************************************************************
* Prepare Table 4 Part2, YLLs

* Table 4: Canada's global rank position for five health indicators, 1990 to 2019 



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

drop sex_id cause_id

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

sort sex_id_new

drop sex_id_new

qui compress

save "Table 4 Part2.dta", replace


/* "Table 4 Part2.dta" contents

Base values of 1990 2000 2010 2019

Value	Lower UL	Upper UL

YLLs 

Both sexes	Males	Females

Age-standardized	

All causes

*/




 
 
 
 
 
 
 
 
 ***********************************************************************
* Prepare Table 4 Part3, YLDs

* Table 4: Canada's global rank position for five health indicators, 1990 to 2019 



* use input data from /data/ folder

cd .. // Canada-Burden-of-Disease-main

cd data

import delimited using "IHME-GBD_2019_DATA-45.csv", clear 


/* "IHME-GBD_2019_DATA-45.csv" Metadata:

Permalink:
https://ghdx.healthdata.org/gbd-results-tool?params=gbd-api-2019-permalink/9768d126557df1e38cde353950498730

Data settings:

Base: Single
Location: Countries and territories (204)
Year: 1990, 2000, 2010, 2019

Context: Cause
Age: Age-standardized
Metric: Rate

Measure: YLDs
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
replace Measure = "YLDs" if Measure == "YLDs (Years Lived with Disability)"
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


* gen Sex-Year combinations  

egen Sex_Year = group(Sex Year), lname(name)

label var Sex_Year "Sex-Year group"

save "IHME-GBD_2019_DATA-45.dta", replace


* for YLDs 1990 2000 2010 2019 All Ages
	
keep if Measure == "YLDs"


bysort Sex_Year: egen rank = rank(Value)

label var rank "rank of mean YLDs within Sex-Year group"

sort Sex_Year rank

label var location_name "Country"

keep if location_name == "Canada"

*

drop Value Lower_UL Upper_UL Sex_Year

drop location_name Cause

order Measure Sex Age rank 

reshape wide rank, i(Measure Sex Age) j(Year)

sort sex_id_new

drop sex_id_new

qui compress

save "Table 4 Part3.dta", replace


/* "Table 4 Part3.dta" contents

Base values of 1990 2000 2010 2019

Value	Lower UL	Upper UL

YLDs 

Both sexes	Males	Females

Age-standardized	

All causes

*/


 
 
 
 
 
 
 
 
 
 


***********************************************************************
* Prepare Table 4 Part4

* Table 4: Canada's global rank position for five health indicators, 1990 to 2019 

* Life expectancy



* use input data from /data/ folder

cd .. // Canada-Burden-of-Disease-main

cd data

import delimited using "IHME-GBD_2019_DATA-47.csv", clear 


/* "IHME-GBD_2019_DATA-47.csv" Metadata:

Permalink:
https://ghdx.healthdata.org/gbd-results-tool?params=gbd-api-2019-permalink/4c375987a7c0058913173149e7847518

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


	
rename year Year 

sort sex_id_new Year 

drop sex_id


* gen Sex-Year combinations  

egen Sex_Year = group(Sex Year), lname(name)

label var Sex_Year "Sex-Year group"

save "IHME-GBD_2019_DATA-47.dta", replace
	


bysort Sex_Year: egen rank = rank(-Value)

label var rank "rank of mean YLDs within Sex-Year group"

sort Sex_Year rank

label var location_name "Country"

keep if location_name == "Canada"

*


replace Value = round(Value,0.1)
replace Upper_UL = round(Upper_UL,0.1)
replace Lower_UL = round(Lower_UL,0.1)
format Value Upper_UL Lower_UL %5.1f
drop Value Lower_UL Upper_UL Sex_Year

*

drop location_name 

rename age_name Age

order Measure Sex Age rank 

reshape wide rank, i(Sex Age) j(Year)

sort sex_id_new

order Measure 

drop sex_id_new

qui compress

save "Table 4 Part4.dta", replace


/* "Table 4 Part4.dta" contents

Base values of 1990 2000 2010 2019

Value	Lower UL	Upper UL

Life expectancy 

Both sexes	Males	Females

*/



 
 
 
 
 
 
 

***********************************************************************
* Prepare Table 4 Part5

* Table 4: Canada's global rank position for five health indicators, 1990 to 2019 

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

drop sex_id  


* gen Sex-Year combinations  

egen Sex_Year = group(Sex Year), lname(name)

label var Sex_Year "Sex-Year group"

save "IHME-GBD_2019_DATA-48.dta", replace
	


bysort Sex_Year: egen rank = rank(Value)

label var rank "rank of mean YLDs within Sex-Year group"

sort Sex_Year rank

label var location_name "Country"

keep if location_name == "Canada"

*

drop Value Lower_UL Upper_UL Sex_Year

drop location_name 

rename age_name Age

order Measure Sex Age rank 

reshape wide rank, i(Sex Age) j(Year)

sort sex_id_new

order Measure 

drop sex_id_new

qui compress

save "Table 4 Part5.dta", replace


/* "Table 4 Part5.dta" contents

Base values of 1990 2000 2010 2019

Value	Lower UL	Upper UL

Life expectancy 

Both sexes	Males	Females

*/


















*****************************************************
* Append parts of Table 4

use "Table 4 Part1.dta", clear // Part1, DALYs, Age-standardized

append using "Table 4 Part2.dta" // Part2, YLLs, Age-standardized

append using "Table 4 Part3.dta" // Part3, YLDs, Age-standardized

append using "Table 4 Part4.dta" // Part4, Life expectancy, <1 year

append using "Table 4 Part5.dta" // Part5, Postneonatal mortality, Postneonatal

replace Measure = "Postneonatal mortality" if Measure == "Deaths"

drop cause_id cause_name

qui compress

save "Table 4.dta", replace

export excel using "Table 4.xlsx", replace firstrow(varlabels) keepcellfmt

			

			
			
********

* remove files no longer needed

shell rm -r "Table 4 Part4.dta"
shell rm -r "Table 4 Part1.dta"
shell rm -r "Table 4 Part2.dta"
shell rm -r "Table 4 Part3.dta"
shell rm -r "Table 4 Part5.dta"

		
		







 
 



**********************

view "log Table 4.smcl"

log close

cd ..

cd code

exit, clear
