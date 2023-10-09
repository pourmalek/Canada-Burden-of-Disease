
clear all

cd "$pathCanadaBOD"

cd output

capture log close 

log using "log Table 3.smcl", replace

***************************************************************************
* This is "do Table 3.do"

* Project: Canada Burden of Disease 1990-2019                                                                        
* Person: Farshad Pourmalek
* Time (initial): 2022 March 28
***************************************************************************



** Prepares Table 3
* Table 3: Relative (%) changes in age-standardized DALY rates 
* in Canada and comparator high-income locations for major groups of conditions, 1990-2019
* , with a 95% uncertainty interval

* level 2 causes, % change in Age-standardized DALYs rate in each of 5 group of countries:
* Canada, United States, Western Europe, Australasia, Asia-Pacific


* Metadata for input data described below,
* under each -import delimited using "IHME-GBD_2019_DATA-??.csv"-


** Table 3 : Level 2 Grouping of Conditions, % change in values 1990-2019
* Input data: "IHME-GBD_2019_DATA-51.csv"
* Output data: "Table 4 Part1.dta"






***********************************************************************
* Prepare Table 3

** Prepares Table 3, Level 2 Grouping of Conditions
* Table 4: Relative (%) changes in age-standardized DALY rates in Canada and comparator locations 
* and Canada’s rank in 1990-2019 among all high-income countries. 

* level 2 causes, % change in Age-standardized DALYs rate in each of 5 group of countries:
* Canada, United States, Western Europe, Australasia, Asia-Pacific


* use input data from /data/ folder

cd .. // Canada-Burden-of-Disease-main

cd data

import delimited using "IHME-GBD_2019_DATA-53.csv", clear 


/* "IHME-GBD_2019_DATA-53.csv" Metadata:

Permalink:
https://ghdx.healthdata.org/gbd-results-tool?params=gbd-api-2019-permalink/6db6961bfbc56bc8b68e9c14755d6313

Data settings:

Base: Change
Location: 6 groups of countries (See "do Table 4 a.do")
Year range: 1990-2010

Context: Cause
Age: Age-standardized
Metric: Rate

Measure: DALYs
Sex: Male, Female, Both
Cause: level 2


Download settings: 
Both IDs and Names 
(ID = variable_id, Name = variable_name)


* Countries in Table 4:

see "do Table 4 a.do"


*/


* save output data in /output/ folder

cd .. // Canada-Burden-of-Disease-main

cd output 

drop measure_id location_id age_id metric_id metric_name

rename measure_name Measure

rename cause_name Cause


replace Cause = "Maternal & neonatal" if Cause == "Maternal and neonatal disorders"
replace Cause = "Respiratory infections" if Cause == "Respiratory infections and tuberculosis"
replace Cause = "Neoplasms" if Cause == "Neoplasms"
replace Cause = "Cardiovascular" if Cause == "Cardiovascular diseases"
replace Cause = "Chronic respiratory" if Cause == "Chronic respiratory diseases"
replace Cause = "Digestive" if Cause == "Digestive diseases"
replace Cause = "Neurological" if Cause == "Neurological disorders"
replace Cause = "Mental" if Cause == "Mental disorders"
replace Cause = "Substance use" if Cause == "Substance use disorders"
replace Cause = "Diabetes & kidney" if Cause == "Diabetes and kidney diseases"
replace Cause = "Skin" if Cause == "Skin and subcutaneous diseases"
replace Cause = "Sense organ" if Cause == "Sense organ diseases"
replace Cause = "Musculoskeletal" if Cause == "Musculoskeletal disorders"
replace Cause = "Other NCD" if Cause == "Other non-communicable diseases"
replace Cause = "Transport injuries" if Cause == "Transport injuries"
replace Cause = "Unintentional injuries" if Cause == "Unintentional injuries"
replace Cause = "Self-harm and violence" if Cause == "Self-harm and interpersonal violence"

gen cause_id_new = .
replace cause_id_new = 1 if Cause == "Maternal & neonatal"
replace cause_id_new = 2 if Cause == "Respiratory infections"
replace cause_id_new = 3 if Cause == "Neoplasms"
replace cause_id_new = 4 if Cause == "Cardiovascular"
replace cause_id_new = 5 if Cause == "Chronic respiratory"
replace cause_id_new = 6 if Cause == "Digestive"
replace cause_id_new = 7 if Cause == "Neurological"
replace cause_id_new = 8 if Cause == "Mental"
replace cause_id_new = 9 if Cause == "Substance use"
replace cause_id_new = 10 if Cause == "Diabetes & kidney"
replace cause_id_new = 11 if Cause == "Skin"
replace cause_id_new = 12 if Cause == "Sense organ"
replace cause_id_new = 13 if Cause == "Musculoskeletal"
replace cause_id_new = 14 if Cause == "Other NCD"
replace cause_id_new = 15 if Cause == "Transport injuries"
replace cause_id_new = 16 if Cause == "Unintentional injuries"
replace cause_id_new = 17 if Cause == "Self-harm and violence"



drop if Cause == "Enteric infections"
drop if Cause == "HIV/AIDS and sexually transmitted infections"
drop if Cause == "Neglected tropical diseases and malaria"
drop if Cause == "Nutritional deficiencies"
drop if Cause == "Other infectious diseases"




gen Sex = ""
replace Sex = "Both sexes" if sex_name == "Both"
replace Sex = "Males" if sex_name == "Male"
replace Sex = "Females" if sex_name == "Female"
drop sex_name


gen sex_id_new = .
replace sex_id_new = 1 if Sex == "Both sexes"
replace sex_id_new = 2 if Sex == "Males"
replace sex_id_new = 3 if Sex == "Females"


* gen percent = proportion * 100
replace val = val * 100
replace upper = upper * 100
replace lower = lower * 100

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
	
order sex_id cause_id year_start year_end, last

order Sex, after(age_name)

rename location_name Location

order Measure age_name, last

sort Location Sex cause_id_new

sort sex_id_new 

qui compress

keep if year_start == 1990 & year_end == 2019

keep Location Sex Cause Value Lower_UL Upper_UL cause_id_new 

keep if Sex == "Both sexes"

drop Sex

replace Location = "United_States" if Location == "United States of America"
replace Location = "Asia_Pacific" if Location == "High-income Asia Pacific"
replace Location = "Western_Europe" if Location == "Western Europe"
replace Location = "Western_Europe" if Location == "Western Europe"
replace Location = "Southern_Latin" if Location == "Southern Latin America" // Southern_Latin_America


gen location_id_new = .
replace location_id_new = 1 if Location == "Canada"
replace location_id_new = 2 if Location == "United_States"
replace location_id_new = 3 if Location == "Western_Europe"
replace location_id_new = 4 if Location == "Australasia"
replace location_id_new = 5 if Location == "Asia_Pacific"
replace location_id_new = 6 if Location == "Southern_Latin" // Southern_Latin_America

sort location_id_new cause_id_new

reshape wide Value Lower_UL Upper_UL location_id_new, i(Cause) j(Location) string

sort cause_id_new

    
rename ///
(ValueCanada ValueUnited_States ValueWestern_Europe ValueAustralasia ValueAsia_Pacific ValueSouthern_Latin) ///
(Canada_Value United_States_Value Western_Europe_Value Australasia_Value Asia_Pacific_Value Southern_Latin_Value)

order Cause Canada_Value United_States_Value Western_Europe_Value Australasia_Value Asia_Pacific_Value Southern_Latin_Value

drop location_*

rename (Lower_ULCanada Upper_ULCanada) (Canada_Lower_UL Canada_Upper_UL)
rename (Lower_ULUnited_States Upper_ULUnited_States) (United_States_Lower_UL United_States_Upper_UL)
rename (Lower_ULWestern_Europe Upper_ULWestern_Europe) (Western_Europe_Lower_UL Western_Europe_Upper_UL)
rename (Lower_ULAustralasia Upper_ULAustralasia) (Australasia_Lower_UL Australasia_Upper_UL)
rename (Lower_ULAsia_Pacific Upper_ULAsia_Pacific) (Asia_Pacific_Lower_UL Asia_Pacific_Upper_UL) 
rename (Lower_ULSouthern_Latin Upper_ULSouthern_Latin) (Southern_Latin_Lower_UL Southern_Latin_Upper_UL)


order Cause Canada_Value Canada_Lower_UL Canada_Upper_UL ///
United_States_Value United_States_Lower_UL United_States_Upper_UL ///
Western_Europe_Value Western_Europe_Lower_UL Western_Europe_Upper_UL ///
Australasia_Value Australasia_Lower_UL Australasia_Upper_UL ///
Asia_Pacific_Value Asia_Pacific_Lower_UL Asia_Pacific_Upper_UL ///
Southern_Latin_Value Southern_Latin_Lower_UL Southern_Latin_Upper_UL 

drop cause_id_new

gsort -Canada_Value

qui compress

save "Table 3.dta", replace

export excel using "Table 3.xlsx", replace firstrow(varlabels) keepcellfmt


/* "Table 3.dta" contents

% change values 1990-2019

DALYs comparator country groups

Both sexes	

level 2 causes

*/








**********************

view "log Table 3.smcl"

log close

cd ..

cd code

exit, clear
