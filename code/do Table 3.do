
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


** Table 3 Part 1: DALYs, All ages
* Input data: "IHME-GBD_2019_DATA-31.csv"
* Output data: "Table 3.xlsx", sheet("Part1")

** Table 3 Part 2: DALYs, Age-standardized
* Input data: "IHME-GBD_2019_DATA-31.csv"
* Output data: "Table 3.xlsx", sheet("Part2")

** Table 3 Part 3: YLLs, All ages
* Input data: "IHME-GBD_2019_DATA-31.csv"
* Output data: "Table 3.xlsx", sheet("Part3")

** Table 3 Part 4: YLLs, Age-standardized
* Input data: "IHME-GBD_2019_DATA-31.csv"
* Output data: "Table 3.xlsx", sheet("Part4")

** Table 3 Part 5: YLDs, All ages
* Input data: "IHME-GBD_2019_DATA-31.csv"
* Output data: "Table 3.xlsx", sheet("Part5")

** Table 3 Part 6: YLDs, Age-standardized
* Input data: "IHME-GBD_2019_DATA-31.csv"
* Output data: "Table 3.xlsx", sheet("Part6")


***********************************************************************
* Prepare Table 3 Part1

* Top 10 level 3 causes of DALYs in 1990 and 2019 by sex, All ages 


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

drop sex_id	measure_id_new sex_id_new age_id_new

order Sex, after(Age)



* gen Sex-Year combinations

egen Sex_Year = group(Sex Year), lname(name)

label var Sex_Year "Sex-Year group"

order cause_id, last

save "IHME-GBD_2019_DATA-31.dta", replace


* for DALYs 1990 and 2019 All Ages

keep if Year == 1990 | Year == 2019
	
keep if Measure == "DALYs"

keep if Age == "All Ages"

keep if Year == 1990 | Year == 2019

bysort Sex_Year: egen rank = rank(-Value)

label var rank "rank of mean DALYs within Sex-Year group"

sort Sex_Year rank

keep if rank <= 10

export excel using "Table 3.xlsx", replace sheet("Part1") firstrow(varlabels) 


/* "Table 3.xlsx", sheet("Part1") contents

Base values of 1990 and 2019

Value	Lower UL	Upper UL

DALYs 

Both sexes	Males	Females

All ages	

top 10 level 3 causes

*/










***********************************************************************
* Prepare Table 3 Part2

* Top 10 level 3 causes of DALYs in 1990 and 2019 by sex, Age-standardized


use "IHME-GBD_2019_DATA-31.dta", clear
* See Metadata above

* for DALYs 1990 and 2019 Age-standardized

keep if Year == 1990 | Year == 2019
	
keep if Measure == "DALYs"

keep if Age == "Age-standardized"

keep if Year == 1990 | Year == 2019

bysort Sex_Year: egen rank = rank(-Value)

label var rank "rank of mean DALYs within Sex-Year group"

sort Sex_Year rank

keep if rank <= 10

export excel using "Table 3.xlsx", sheet("Part2") firstrow(varlabels) 


/* "Table 3.xlsx", sheet("Part2") contents

Base values of 1990 and 2019

Value	Lower UL	Upper UL

DALYs 

Both sexes	Males	Females

Age-standardized	

top 10 level 3 causes

*/










***********************************************************************
* Prepare Table 3 Part3

* Top 10 level 3 causes of YLLs in 1990 and 2019 by sex, All ages


use "IHME-GBD_2019_DATA-31.dta", clear
* See Metadata above

* for DALYs 1990 and 2019 All ages

keep if Year == 1990 | Year == 2019
	
keep if Measure == "YLLs"

keep if Age == "All Ages"

keep if Year == 1990 | Year == 2019

bysort Sex_Year: egen rank = rank(-Value)

label var rank "rank of mean DALYs within Sex-Year group"

sort Sex_Year rank

keep if rank <= 10

export excel using "Table 3.xlsx", sheet("Part3") firstrow(varlabels) 


/* "Table 3.xlsx", sheet("Part3") contents

Base values of 1990 and 2019

Value	Lower UL	Upper UL

YLLs 

Both sexes	Males	Females

All Ages	

top 10 level 3 causes

*/






***********************************************************************
* Prepare Table 3 Part4

* Top 10 level 3 causes of YLLs in 1990 and 2019 by sex, Age-standardized


use "IHME-GBD_2019_DATA-31.dta", clear
* See Metadata above

* for YLLs 1990 and 2019 Age-standardized

keep if Year == 1990 | Year == 2019
	
keep if Measure == "YLLs"

keep if Age == "All Ages"

keep if Year == 1990 | Year == 2019

bysort Sex_Year: egen rank = rank(-Value)

label var rank "rank of mean YLLs within Sex-Year group"

sort Sex_Year rank

keep if rank <= 10

export excel using "Table 3.xlsx", sheet("Part4") firstrow(varlabels) 


/* "Table 3.xlsx", sheet("Part4") contents

Base values of 1990 and 2019

Value	Lower UL	Upper UL

YLLs 

Both sexes	Males	Females

Age-standardized	

top 10 level 3 causes

*/












***********************************************************************
* Prepare Table 3 Part5

* Top 10 level 3 causes of YLDs in 1990 and 2019 by sex, All ages


use "IHME-GBD_2019_DATA-31.dta", clear
* See Metadata above

* for DALYs 1990 and 2019 All ages

keep if Year == 1990 | Year == 2019
	
keep if Measure == "YLDs"

keep if Age == "All Ages"

keep if Year == 1990 | Year == 2019

bysort Sex_Year: egen rank = rank(-Value)

label var rank "rank of mean DALYs within Sex-Year group"

sort Sex_Year rank

keep if rank <= 10

export excel using "Table 3.xlsx", sheet("Part5") firstrow(varlabels) 


/* "Table 3.xlsx", sheet("Part5") contents

Base values of 1990 and 2019

Value	Lower UL	Upper UL

YLDs 

Both sexes	Males	Females

All Ages	

top 10 level 3 causes

*/






***********************************************************************
* Prepare Table 3 Part6

* Top 10 level 3 causes of YLDs in 1990 and 2019 by sex, Age-standardized


use "IHME-GBD_2019_DATA-31.dta", clear
* See Metadata above

* for YLDs 1990 and 2019 Age-standardized

keep if Year == 1990 | Year == 2019
	
keep if Measure == "YLDs"

keep if Age == "All Ages"

keep if Year == 1990 | Year == 2019

bysort Sex_Year: egen rank = rank(-Value)

label var rank "rank of mean YLDs within Sex-Year group"

sort Sex_Year rank

keep if rank <= 10

export excel using "Table 3.xlsx", sheet("Part6") firstrow(varlabels) 


/* "Table 3.xlsx", sheet("Part6") contents

Base values of 1990 and 2019

Value	Lower UL	Upper UL

YLDs 

Both sexes	Males	Females

Age-standardized	

top 10 level 3 causes

*/


















**********************

view "log Table 3.smcl"

log close

cd ..

cd code

exit, clear
