/*
File Name:		concealed_weapons_effects.do
File Purpose:	analysis on effects of concealed weapons laws on violent crimes
File Author:	Yichuan(Jacky) Zhang
Date Created:	4/14/2022
Last Updated:	4/15/2022
*/

// clear the screen before
cls

// change working directory
cd "/Users/skywalker/Desktop/Spring 2022/ECON 308/Memo/4"

*	create a log file
log using zhang-econ308-m8.log, text replace

*	Open dataset gun
use "/Users/skywalker/Desktop/Spring 2022/ECON 308/Memo/4/Guns.dta", clear

*	logarithmic transformation for the model variables
gen lv = log(vio)

*	simple OLS regression model
eststo m1: reg lv shall

*	pooled OLS regression model
eststo m2: reg lv shall incarc_rate density avginc pop pb1064 pw1064 pm1029

// display and export the table
esttab m1 m2 using table1.rtf, se replace

*	Model with state specific fixed effects alone
reg lv shall incarc_rate density avginc pop pb1064 pw1064 pm1029 i.stateid

*	Model with time specific fixed effects alone
reg lv shall incarc_rate density avginc pop pb1064 pw1064 pm1029 i.year

*	Two-way fixed effects model, contains both state and time effects
reg lv shall incarc_rate density avginc pop pb1064 pw1064 pm1029 i.stateid i.year

*	test for exclusion of state effects
testparm i.stateid

*	test for exclusion of time effects
testparm i.year

*	test for exclusion of both state and time effects
testparm i.stateid i.year

*	declares data as a panel
xtset stateid year

*	one-way fixed effects model
eststo fe: xtreg lv shall incarc_rate density avginc pop pb1064 pw1064 pm1029, fe

*	random effects model (error components model)
eststo re: xtreg lv shall incarc_rate density avginc pop pb1064 pw1064 pm1029, re

*	compare fixed effects and random effects model, low p-value leads to rejection of the null; requires fixed effects model
hausman fe re

// display and export the table
esttab fe re, se stats(r2 N df_r) legend
esttab fe re using table2.rtf, se stats(r2 N df_r) legend replace

*	close the log file
log close
