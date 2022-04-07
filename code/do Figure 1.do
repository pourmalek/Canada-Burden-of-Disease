
clear all

cd "$pathCanadaBOD"

cd output

capture log close 

log using "log Figure 1.smcl", replace

***************************************************************************
* This is "do Figure 1.do"

* Project: Canada Burden of Disease                                                                        
* Person: Farshad Pourmalek pourmalek_farshad at yahoo dotcom
* Time (initial): 2022 March 28
***************************************************************************



** Prepares Figure 1
* Figure 1: Trends in DALY, YLL and YLD rates in Canada, 1990-2019 remove DALYs


* Metadata for input data described below,
* under each -import delimited using "IHME-GBD_2019_DATA-??.csv"-


* Input data: "IHME-GBD_2019_DATA-????????????????????????.csv"
* Output data: "Figure 1 Part1.dta" ?????????????????






***********************************************************************
* Prepare Figure 1 Part1

** Prepares Figure 1, Trends in DALY rates in Canada, 1990-2019 


* use input data from /data/ folder

cd .. // Canada-Burden-of-Disease-main

cd data

import delimited using "IHME-GBD_2019_DATA-??.csv", clear 


/* "IHME-GBD_2019_DATA-??.csv" Metadata:

Permalink:
here .......................

Data settings:

Base: Single
Location: Canada
Year: 1990 to 2019

Context: Cause
Age: All ages, Age-standardized
Metric: Rate

Measure: DALYs
Sex: Male, Female
Cause: All cause


Download settings: 
Both IDs and Names 
(ID = variable_id, Name = variable_name)

*/



* save output data in /output/ folder

cd .. // Canada-Burden-of-Disease-main

cd output 

drop measure_id location_id age_id metric_id metric_name

rename measure_name Measure

rename cause_name Cause



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

keep if Year == 1990 | Year == 2019
	
order sex_id cause_id Year, last

order Sex, after(age_name)

rename location_name Location

order Measure age_name, last

sort Location Sex cause_id_new

sort sex_id_new 

qui compress

keep Location Sex Cause Value Year cause_id_new



* 







qui compress

save "Figure 1 Part4.dta", replace


/* "Figure 1 Part1.dta" contents

Canada DALYs 1990-2019

Males, Females; All ages, Age-standardized 	

level 2 causes

*/






MeasureAgeSexCauseCountry



twoway ///
(line DALY_AllAges_Male_AllCause_CAN date, sort lcolor(blue) lwidth(vthick)) 
(line DALY_AllAges_Fema_AllCause_CAN date, sort lcolor(orange)) /// 
(line DALY_AgeStand_Male_AllCause_CAN date, sort lcolor(gray)) /// 
(line DALY_AgeStand_Fema_AllCause_CAN date, sort lcolor(gold) lpattern(dash)) /// 
, xtitle() xlabel(#15, format(%tdYY-NN-DD) labsize(small)) xlabel(, grid) ///
xlabel(, angle(forty_five)) ylabel(, format(%9.0fc) labsize(small)) ylabel(, labsize(small) angle(horizontal)) ///
ytitle("DALY rate per 100,000") title(, size(medium)) /// 
xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2)) legend(region(lcolor(none))) legend(bexpand) ///
legend(order(1 "All ages Males" 2 "All ages Females" ///
3 "Age-standardized Males" 4 "Age-standardized Females") size(small) row(2))

graph export "graph 1a DALY rates in Canada, 1990-2019.pdf", replace




twoway ///
(line YLL_AllAges_Male_AllCause_CAN date, sort lcolor(blue) lwidth(vthick)) 
(line YLL_AllAges_Fema_AllCause_CAN date, sort lcolor(orange)) /// 
(line YLL_AgeStand_Male_AllCause_CAN date, sort lcolor(gray)) /// 
(line YLL_AgeStand_Fema_AllCause_CAN date, sort lcolor(gold) lpattern(dash)) /// 
, xtitle() xlabel(#15, format(%tdYY-NN-DD) labsize(small)) xlabel(, grid) ///
xlabel(, angle(forty_five)) ylabel(, format(%9.0fc) labsize(small)) ylabel(, labsize(small) angle(horizontal)) ///
ytitle("YLL rate per 100,000") title(, size(medium)) /// 
xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2)) legend(region(lcolor(none))) legend(bexpand) ///
legend(order(1 "All ages Males" 2 "All ages Females" ///
3 "Age-standardized Males" 4 "Age-standardized Females") size(small) row(2))

graph export "graph 1b YLL rates in Canada, 1990-2019.pdf", replace






twoway ///
(line YLD_AllAges_Male_AllCause_CAN date, sort lcolor(blue) lwidth(vthick)) 
(line YLD_AllAges_Fema_AllCause_CAN date, sort lcolor(orange)) /// 
(line YLD_AgeStand_Male_AllCause_CAN date, sort lcolor(gray)) /// 
(line YLD_AgeStand_Fema_AllCause_CAN date, sort lcolor(gold) lpattern(dash)) /// 
, xtitle() xlabel(#15, format(%tdYY-NN-DD) labsize(small)) xlabel(, grid) ///
xlabel(, angle(forty_five)) ylabel(, format(%9.0fc) labsize(small)) ylabel(, labsize(small) angle(horizontal)) ///
ytitle("YLD rate per 100,000") title(, size(medium)) /// 
xscale(lwidth(vthin) lcolor(gray*.2)) yscale(lwidth(vthin) lcolor(gray*.2)) legend(region(lcolor(none))) legend(bexpand) ///
legend(order(1 "All ages Males" 2 "All ages Females" ///
3 "Age-standardized Males" 4 "Age-standardized Females") size(small) row(2))

graph export "graph 1c YLD rates in Canada, 1990-2019.pdf", replace























**********************

view "log Figure 1.smcl"

log close

cd ..

cd code

exit, clear
