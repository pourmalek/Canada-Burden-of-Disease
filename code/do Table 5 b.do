
clear all

cd "$pathCanadaBOD"

cd output

capture log close 

log using "log Table 5 b.smcl", replace

***************************************************************************
* This is "do Table 5 b.do"

* Project: Canada Burden of Disease                                                                        
* Person: Farshad Pourmalek pourmalek_farshad at yahoo dotcom
* Time (initial): 2022 March 28
***************************************************************************



** Prepares Table 5
* Table 5: Changes in age-standardized DALY rates in Canada and comparator locations 
* and Canada’s rank in 1990-2019

* level 1 causes, Canada's Rank in 1990 and Rank in 2019 for Age-standardized DALYs rate among 32 countries:
* Canada, United States, Western Europe, Australasia, Asia-Pacific (see below)


* Metadata for input data described below,
* under each -import delimited using "IHME-GBD_2019_DATA-??.csv"-


** Table 5 Part 2: Level 1 Grouping of Conditions, Canada's Rank in 1990 and Rank in 2019 
* Input data: "IHME-GBD_2019_DATA-52.csv"
* Output data: "Table 5 Part2.dta"






***********************************************************************
* Prepare Table 5 Part2

** Prepares Table 5, Level 1 Grouping of Conditions
* Table 5: Changes in age-standardized DALY rates in Canada and comparator locations 
* and Canada’s rank in 1990-2019

* level 1 causes, Canada's Rank in 1990 and Rank in 2019 for Age-standardized DALYs rate among 32 countries:
* Canada, United States, Western Europe, Australasia, Asia-Pacific (see below)


* use input data from /data/ folder

cd .. // Canada-Burden-of-Disease-main

cd data

import delimited using "IHME-GBD_2019_DATA-52.csv", clear 


/* "IHME-GBD_2019_DATA-52.csv" Metadata:

Permalink:
https://ghdx.healthdata.org/gbd-results-tool?params=gbd-api-2019-permalink/16a7338f4ceaed26069b9d7e038e6879

Data settings:

Base: Single
Location: Canada, United States, Western Europe, Australasia, Asia-Pacific (32 countries) See below
Year: 1990, 2000, 2010, 2019

Context: Cause
Age: Age-standardized
Metric: Rate

Measure: DALYs
Sex: Both
Cause: level 1


Download settings: 
Both IDs and Names 
(ID = variable_id, Name = variable_name)


* Countries in Table 5:
Canada, United States, Western Europe (24), Australasia (2), Asia-Pacific (4) (32 countries)


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
23	Switzerland
24	United Kingdom

Australasia: Australia, New Zealand

High-income Asia-Pacific:
1	Brunei Darussalam
2	Japan
3	Republic of Korea
4	Singapore


* 32 countries:

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
18	Luxembourg
19	Malta
20	Monaco
21	Netherlands
22	New Zealend
23	Norway
24	Portugal
25	Republic of Korea
26	San Marino
27	Singapore
28	Spain
29	Sweden
30	Switzerland
31	United Kingdom
32	United States of America

*/


* save output data in /output/ folder

cd .. // Canada-Burden-of-Disease-main

cd output 

drop measure_id location_id age_id metric_id metric_name

rename measure_name Measure

order Measure age_name, last

order sex_id sex_name cause_id, last

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

rename location_name Location 



sort Location cause_name

rename cause_name Cause


gen cause_id_new = . 

replace cause_id_new = 1 if Cause == "Communicable, maternal, neonatal, and nutritional diseases"
replace cause_id_new = 2 if Cause == "Non-communicable diseases"
replace cause_id_new = 3 if Cause == "Injuries"

drop if Cause == "All causes"

sort cause_id_new

replace Cause = "CMNN" if Cause == "Communicable, maternal, neonatal, and nutritional diseases"
replace Cause = "NCDs" if Cause == "Non-communicable diseases"


keep if Year == 1990 | Year == 2019



qui compress

keep Location Cause Year Value cause_id_new

order Cause Year Location Value cause_id_new

sort Cause Year Location


bysort Year Cause: egen rank = rank(Value)

label var rank "Canada's rank of mean DALYs within Country-Cause-Year"

sort Year rank

keep if Location == "Canada"

sort Year cause_id_new

drop Location Value

reshape wide rank, i(Cause) j(Year)

rename rank1990	Rank_in_1990
rename rank2019	Rank_in_2019

label var Rank_in_1990 "Rank in 1990"
label var Rank_in_2019 "Rank in 2019"

sort cause_id_new


drop cause_id_new

qui compress

save "Table 5 Part2.dta", replace 


/* "Table 5 Part2.dta" contents



DALYs comparator countries

Both sexes	

*/








**********************

view "log Table 5 b.smcl"

log close

cd ..

cd code

exit, clear
