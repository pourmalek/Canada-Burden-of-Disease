
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




***********************************************************************
* Prepare Table 1 Part 1

* SMPH base values 1990 and 2019


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
	
sort measure_id_new sex_id_new age_id_new Year

drop sex_id	measure_id_new sex_id_new age_id_new

order Sex, after(Age)

export excel using "Table 1.xlsx", replace sheet("Part1") firstrow(varlabels) 


/* "Table 1.xlsx", sheet("Part1") contents

Base values of 1990 and 2019

Value	Lower UL	Upper UL

DALYs YLLs YLDs

Both sexes	Males	Females

All ages	Age-standardized

*/










***********************************************************************
* Prepare Table 1 Part 2

* SMPH change % from 1990 to 2019


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



cd .. // Canada-Burden-of-Disease-main

cd output 

save "IHME-GBD_2019_DATA-2.dta", replace

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
  
keep if Year_start == 1990 & Year_end == 2019
	
sort measure_id_new sex_id_new age_id_new 

drop sex_id	measure_id_new sex_id_new age_id_new

order Sex, after(Age)

export excel using "Table 1.xlsx", sheet("Part2") firstrow(varlabels) 


/* "Table 1.xlsx", sheet("Part2") contents

Relative change (%) from 1990 to 2019

Value	(without Lower UL	Upper UL)

DALYs YLLs YLDs

Both sexes	Males	Females

All ages	Age-standardized

*/










***********************************************************************
* Prepare Table 1 Part 3

* Life expectancy (at birth) base values 1990 and 2019


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

cd .. // Canada-Burden-of-Disease-main

cd output 

save "IHME-GBD_2019_DATA-3.dta", replace



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


export excel using "Table 1.xlsx", sheet("Part3") firstrow(varlabels) 


/* "Table 1.xlsx", sheet("Part3") contents

Life expectancy at birth 1990 2010

Both sexes	Males	Females


*/












***********************************************************************
* Prepare Table 1 Part 4

* Life expectancy (at birth) % from 1990 to 2019

use "IHME-GBD_2019_DATA-3.dta", clear


drop measure_id	location_id	location_name sex_id age_id metric_id metric_name

rename measure_name Measure

rename age_name Age
replace Age = "At birth"

rename val Value
rename upper Upper_UL
rename lower Lower_UL

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

reshape wide Value Upper_UL Lower_UL, i(Sex) j(Year)

order Measure Age

gen sex_id_new = .
replace sex_id_new = 1 if Sex == "Both"
replace sex_id_new = 2 if Sex == "Male"
replace sex_id_new = 3 if Sex == "Female"
sort sex_id_new 
drop sex_id_new


* gen % Change = 100 * (New - Old) / Old

gen ChangeValue1990_2019 = 100 * (Value2019 - Value1990) / Value1990
gen ChangeUpper_UL1990_2019 = 100 * (Upper_UL2019 - Upper_UL1990) / Upper_UL1990
gen ChangeLower_UL1990_2019 = 100 * (Lower_UL2019 - Lower_UL1990) / Lower_UL1990


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



export excel using "Table 1.xlsx", sheet("Part4") firstrow(varlabels) 


/* "Table 1.xlsx", sheet("Part4") contents

Life expectancy at birth % change from 1990 to 2019

Both sexes	Males	Females


*/















***********************************************************************
* Prepare Table 1 Part 5

* Post-neonatal infant mortality rate 1990 2019


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

cd .. // Canada-Burden-of-Disease-main

cd output 

export excel using "Table 1.xlsx", sheet("Part5") firstrow(varlabels) 


/* "Table 1.xlsx", sheet("Part5") contents

Postneonatal Mortality Rate 1990 and 2019

Both sexes	Males	Females

*/










**********************

view "log Table 1.smcl"

log close

exit, clear
