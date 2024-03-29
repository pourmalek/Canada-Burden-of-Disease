
***************************************************************************
* This is "do CanadaBOD master.do"
                                                                                                          
* Project: Canada Burden of Disease 1990-2019
* manuscript: Health trends in Canada 1990-2019: An analysis for the Global Burden of Disease Study                                                                      
* Person: Farshad Pourmalek
* Time (initial): 2022 March 28
***************************************************************************

clear all
                                                                                        
clear mata

set maxvar 32767 // Stata MP & SE



* setup Stata path by operating system 

set more off 

set mem 1000m // for older versions of Stata

clear all

dis "`c(username)'"

local usrnam = "`c(username)'"

di "`usrnam'"

****** set path based on local operating system ******

if regexm(c(os),"Mac") == 1 { 
	global pathCanadaBOD "/Users/`usrnam'/Downloads/Canada-Burden-of-Disease-main/" 
}
else if regexm(c(os),"Windows") {
	global pathCanadaBOD = "C:\Users\\`usrnam'\Downloads\Downloads\Canada-Burden-of-Disease-main\"
}
*      


di "$pathCanadaBOD"

cd "$pathCanadaBOD"
 



/*

* preserve native scheme (of the local machine; will be eventually restored at the end of "do CanadaBOD merge.do")

di c(scheme)

global nativescheme `c(scheme)'

di "$nativescheme"



* get grstyle for graphs and its dependencies

ssc install grstyle, replace
ssc install palettes, replace
ssc install colrspace, replace

grstyle init
set scheme _GRSTYLE_ 
grstyle color background white

*/

cd code

* objective, input files, and output files are mentioned at the beginning of each do file

do "do Table 1.do" 

do "do Table 2.do" 

do "do Table 3.do" 

do "do Table 4.do" 


* Tables in Supplementary Materials

do "do Table S4.do"

do "do Table S5.do"



