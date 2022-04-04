
clear all

cd "$pathCanadaBOD"

cd output

capture log close 

log using "log Table 5 a.smcl", replace

***************************************************************************
* This is "do Table 5 a.do"

* Project: Canada Burden of Disease                                                                        
* Person: Farshad Pourmalek pourmalek_farshad at yahoo dotcom
* Time (initial): 2022 March 28
***************************************************************************



** Prepares Table 5
* Table 5: Changes in age-standardized DALY rates in Canada and comparator locations 
* and Canada’s rank in 1990-2019

* level 1 causes, % change in Age-standardized DALYs rate in each of 5 group of countries:
* Canada, United States, Western Europe, Australasia, Asia-Pacific


* Metadata for input data described below,
* under each -import delimited using "IHME-GBD_2019_DATA-??.csv"-


** Table 5 Part 1: Level 1 Grouping of Conditions, % change in values 1990-2019
* Input data: "IHME-GBD_2019_DATA-51.csv"
* Output data: "Table 5 Part1.dta"






***********************************************************************
* Prepare Table 5 Part1

** Prepares Table 5, Level 1 Grouping of Conditions
* Table 5: Changes in age-standardized DALY rates in Canada and comparator locations 
* and Canada’s rank in 1990-2019

* level 1 causes, % change in Age-standardized DALYs rate in each of 5 group of countries:
* Canada, United States, Western Europe, Australasia, Asia-Pacific


* use input data from /data/ folder

cd .. // Canada-Burden-of-Disease-main

cd data

import delimited using "IHME-GBD_2019_DATA-51.csv", clear 


/* "IHME-GBD_2019_DATA-51.csv" Metadata:

Permalink:
https://ghdx.healthdata.org/gbd-results-tool?params=gbd-api-2019-permalink/109fd2746aa7f16495ea9cebf8ef76e7

Data settings:

Base: Change
Location: (1) Canada, (2) United States, (3) Western Europe, (4) Australasia, (5) Asia-Pacific (See below)
Year range: 1990-2019

Context: Cause
Age: Age-standardized
Metric: Rate

Measure: DALYs
Sex: Male, Female, Both
Cause: level 1


Download settings: 
Both IDs and Names 
(ID = variable_id, Name = variable_name)


* Countries in Table 5:
Canada, United States, Western Europe (26), Australasia (2), Asia-Pacific (4) (33 countries)


Western Europe:
1	Andorra
2	Austria
3	Belgium
4	Cyprus
5	Denmark
6	Finland
7	France
8	Germany
9	Greece
10	Iceland
11	Ireland
12	Israel
13	Italy
14	Japan
15	Luxembourg
16	Malta
17	Monaco
18	Netherlands
19	Norway
20	Portugal
21	San Marino
22	Spain
23	Sweden
25  Switzerland
26	United Kingdom

Australasia: Australia, New Zealand

High-income Asia-Pacific:
1  Brunei Darussalam
2  Japan
3  Republic of Korea
4  Singapore


* 33 countries:
1	Andorra
2	Australia
3	Austria
4	Belgium
5	Brunei Darussalam
6	Canada
7	Cyprus
8	Denmark
9	Finland
10	France
11	Germany
12	Greece
13	Iceland
14	Ireland
15	Israel
16	Italy
17	Japan
18	Japan
19	Luxembourg
20	Malta
21	Monaco
22	Netherlands
23	New Zealand
25	Norway
25	Portugal
26	Republic of Korea
27	San Marino
28	Singapore
29	Spain
30	Sweden
31	Switzerland
32	United Kingdom
33	United States of America




*/


* save output data in /output/ folder

cd .. // Canada-Burden-of-Disease-main

cd output 

drop measure_id location_id age_id metric_id metric_name

rename measure_name Measure

keep if location_name == "Canada" | ///
        location_name == "United States of America" | ///
        location_name == "Western Europe" | ///
        location_name == "Australasia" | ///
        location_name == "High-income Asia Pacific" 
		
		
gen location_id_new = . 
replace location_id_new = 1 if location_name == "Canada"
replace location_id_new = 2 if location_name == "United States of America"	
replace location_id_new = 3 if location_name == "Western Europe"
replace location_id_new = 4 if location_name == "Australasia"
replace location_id_new = 5 if location_name == "High-income Asia Pacific"



gen cause_id_new = . 
replace cause_id_new = 1 if cause_name == "Communicable, maternal, neonatal, and nutritional diseases"
replace cause_id_new = 2 if cause_name == "Non-communicable diseases"
replace cause_id_new = 3 if cause_name == "Injuries"

drop if cause_name == "All causes"

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

replace Value = round(Value,0.01)
replace Upper_UL = round(Upper_UL,0.1)
replace Lower_UL = round(Lower_UL,0.1)
format Value Upper_UL Lower_UL %5.2fc
	
order sex_id cause_id year_start year_end, last

order Sex, after(age_name)

rename location_name Location

order Measure age_name, last

sort Location Sex cause_name

rename cause_name Cause

sort location_id_new sex_id_new cause_id_new

replace Cause = "CMNN" if Cause == "Communicable, maternal, neonatal, and nutritional diseases"
replace Cause = "NCDs" if Cause == "Non-communicable diseases"


replace Location = "United_States" if Location == "United States of America"
replace Location = "Asia_Pacific" if Location == "High-income Asia Pacific"
replace Location = "Western_Europe" if Location == "Western Europe"




qui compress

keep Location Sex Cause Value cause_id_new

keep if Sex == "Both sexes"

drop Sex


reshape wide Value , i(Cause) j(Location) string

sort cause_id_new


rename ///
(ValueAsia_Pacific ValueAustralasia ValueUnited_States ValueWestern_Europe) ///
(Asia_Pacific Australasia United_States Western_Europe)

rename ValueCanada Canada
label var Canada Canada

order Cause Canada United_States Western_Europe Australasia Asia_Pacific

label var United_States "United States"
label var Western_Europe "Western Europe"
label var Asia_Pacific "Asia Pacific"



save "Table 5 Part1.dta", replace


/* "Table 5 Part1.dta" contents

% change values 1990-2019

DALYs comparator country groups

Both sexes	

*/








**********************

view "log Table 5 a.smcl"

log close

cd ..

cd code

exit, clear
