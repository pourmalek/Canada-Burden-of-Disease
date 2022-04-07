
clear all

cd "$pathCanadaBOD"

cd output

capture log close 

log using "log Table 4 a.smcl", replace

***************************************************************************
* This is "do Table 4 a.do"

* Project: Canada Burden of Disease                                                                        
* Person: Farshad Pourmalek pourmalek_farshad at yahoo dotcom
* Time (initial): 2022 March 28
***************************************************************************



** Prepares Table 4
* Table 4: Relative (%) changes in age-standardized DALY rates in Canada and comparator locations 
* and Canada’s rank in 1990-2019 among all high-income countries. 

* level 1 causes, % change in Age-standardized DALYs rate in each of 6 group of countries:
* Canada, United States, Western Europe, Australasia, Asia-Pacific, Southern Latin America


* Metadata for input data described below,
* under each -import delimited using "IHME-GBD_2019_DATA-??.csv"-


** Table 4 Part 1: Level 1 Grouping of Conditions, % change in values 1990-2019
* Input data: "IHME-GBD_2019_DATA-51.csv"
* Output data: "Table 4 Part1.dta"






***********************************************************************
* Prepare Table 4 Part1

** Prepares Table 4, Level 1 Grouping of Conditions
* Table 4: Relative (%) changes in age-standardized DALY rates in Canada and comparator locations 
* and Canada’s rank in 1990-2019 among all high-income countries. 

* level 1 causes, % change in Age-standardized DALYs rate in each of 6 group of countries:
* Canada, United States, Western Europe, Australasia, Asia-Pacific, Southern Latin America


* use input data from /data/ folder

cd .. // Canada-Burden-of-Disease-main

cd data

import delimited using "IHME-GBD_2019_DATA-51.csv", clear 


/* "IHME-GBD_2019_DATA-51.csv" Metadata:

Permalink:
https://ghdx.healthdata.org/gbd-results-tool?params=gbd-api-2019-permalink/7282ad72b457cf6b9b3cb9a7efc5a752

Data settings:

Base: Change
Location: 6 groups of countries
(1) Canada, (2) United States, (3) Western Europe, 
(4) Australasia, (5) High-income Asia Pacific, (6) Southern Latin America (See below)
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


* Countries in Table 4:
Canada, United States, Western Europe (26), Australasia (2), Asia-Pacific (4),
Southern Latin America (4)
(36 countries)

High-income North America:	
1 Canada
2 Greenland
3 United States
(Greenland as a country amongst the 36 countries. 
North America is not used as a group of countries. 
Canada and the United States each comprise one group within 6 groups of countries.)

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
14	Luxembourg
15	Malta
16	Monaco
17	Netherlands
18	Norway
19	Portugal
20	San Marino
21	Spain
22	Sweden
23  Switzerland
24	United Kingdom

Australasia: Australia, New Zealand

High-income Asia-Pacific:
1  Brunei Darussalam
2  Japan
3  Republic of Korea
4  Singapore

Southern Latin America:
1	Argentina
2	Chile 
3	Uruguay


* 36 countries:
1	Andorra
2	Argentina
3	Australia
4	Austria
5	Belgium
6	Brunei Darussalam
7	Canada
8	Chile 
9	Cyprus
10	Denmark
11	Finland
12	France
13	Germany
14	Greece
15	Greenland
16	Iceland
17	Ireland
18	Israel
19	Italy
20	Japan
21	Luxembourg
22	Malta
23	Monaco
24	Netherlands
25	New Zealand
26	Norway
27	Portugal
28	Republic of Korea
29	San Marino
30	Singapore
31	Spain
32	Sweden
33	Switzerland
34	United Kingdom
35	United States of America
36	Uruguay


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
        location_name == "High-income Asia Pacific" | ///
        location_name == "Southern Latin America" 
		
		
gen location_id_new = . 
replace location_id_new = 1 if location_name == "Canada"
replace location_id_new = 2 if location_name == "United States of America"	
replace location_id_new = 3 if location_name == "Western Europe"
replace location_id_new = 4 if location_name == "Australasia"
replace location_id_new = 5 if location_name == "High-income Asia Pacific"
replace location_id_new = 5 if location_name == "Southern Latin America"



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

replace Cause = "MNC" if Cause == "Communicable, maternal, neonatal, and nutritional diseases"
replace Cause = "Non-communicable" if Cause == "Non-communicable diseases"


replace Location = "United_States" if Location == "United States of America"
replace Location = "Asia_Pacific" if Location == "High-income Asia Pacific"
replace Location = "Western_Europe" if Location == "Western Europe"
replace Location = "Southern_Latin_America" if Location == "Southern Latin America"




qui compress

keep Location Sex Cause Value cause_id_new

keep if Sex == "Both sexes"

drop Sex


reshape wide Value , i(Cause) j(Location) string

sort cause_id_new


rename ///
(ValueAsia_Pacific ValueAustralasia ValueUnited_States ValueWestern_Europe ValueSouthern_Latin_America) ///
(Asia_Pacific Australasia United_States Western_Europe Southern_Latin_America)

rename ValueCanada Canada
label var Canada Canada

order Cause Canada United_States Western_Europe Australasia Asia_Pacific Southern_Latin_America

label var United_States "United States"
label var Western_Europe "Western Europe"
label var Asia_Pacific "Asia Pacific"
label var Southern_Latin_America "Southern Latin America"



save "Table 4 Part1.dta", replace


/* "Table 4 Part1.dta" contents

% change values 1990-2019

DALYs comparator country groups

Both sexes	

*/








**********************

view "log Table 4 a.smcl"

log close

cd ..

cd code

exit, clear
