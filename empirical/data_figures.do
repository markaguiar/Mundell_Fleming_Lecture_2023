set more off 

*set location of data directory
global data_directory "./data/"
*set location of figure directory
global figure_directory "./figures/"


use "${data_directory}debt_data", clear

keep if year<=2021



tsset ifs_code year

/*outcomes*/
egen mean_inv=mean(inv_y) if year>=1970 & year<=2004, by(country)
egen mean_gov=mean(gov_y) if year>=1970 & year<=2004, by(country)
gen delta_y=ln(per_cap_gdp)-ln(l.per_cap_gdp)
egen sd_delta_y=sd(delta_y) if year>=1970 & year<=2004, by(country)
gen delta_cons=ln(con_real)-ln(l.con_real)
egen sd_delta_cons=sd(delta_cons) if year>=1970 & year<=2004, by(country)
gen rel_sd_cons=sd_delta_cons/sd_delta_y
gen delta_gov=ln(gov_real)-ln(l.gov_real)
egen sd_delta_gov=sd(delta_gov) if year>=1970 & year<=2004, by(country)
gen rel_sd_gov=sd_delta_gov/sd_delta_y


/*define poor*/
gen temp=per_cap_dollar<10000 if year==1970
replace temp=. if per_cap_dollar==. & year==1970
egen poor=max(temp), by(ifs_code)
drop temp


/*construct net asset positions*/
gen nfa_y= (assets-liabilities)/dollar_gdp
gen pub_nfa_y=(reserves-ppg_debt)/dollar_gdp
gen priv_nfa_y=nfa_y-pub_nfa_y

gen debt_y = ppg_debt/dollar_gdp
gen reserves_y= reserves/dollar_gdp


/*generate change over time for alternative samples*/

gen growth_04=(ln(per_cap_gdp)-ln(l34.per_cap_gdp))/34 if year==2004
gen temp=growth_04 if ifs_code==111
egen growth_us_04=mean(temp) if year==2004
gen rel_growth_04=growth_04-growth_us_04
drop temp

gen nfa_change_04=(nfa_y-l34.nfa_y)/34 if year==2004
gen pub_nfa_change_04=(pub_nfa_y-l34.pub_nfa_y)/34 if year==2004
gen priv_nfa_change_04=(priv_nfa_y-l34.priv_nfa_y)/34 if year==2004


gen growth_21=(ln(per_cap_gdp)-ln(l51.per_cap_gdp))/51 if year==2021
gen temp=growth_21 if ifs_code==111
egen growth_us_21=mean(temp) if year==2021
gen rel_growth_21=growth_21-growth_us_21
drop temp

gen growth_0421=(ln(per_cap_gdp)-ln(l17.per_cap_gdp))/17 if year==2021
gen temp=growth_0421 if ifs_code==111
egen growth_us_0421=mean(temp) if year==2021
gen rel_growth_0421=growth_0421-growth_us_0421
drop temp


gen nfa_change_21=(nfa_y-l51.nfa_y)/51 if year==2021
gen pub_nfa_change_21=(pub_nfa_y-l51.pub_nfa_y)/51 if year==2021
gen priv_nfa_change_21=(priv_nfa_y-l51.priv_nfa_y)/51 if year==2021

gen nfa_change_0421=(nfa_y-l17.nfa_y)/17 if year==2021
gen pub_nfa_change_0421=(pub_nfa_y-l17.pub_nfa_y)/17 if year==2021
gen priv_nfa_change_0421=(priv_nfa_y-l17.priv_nfa_y)/17 if year==2021

gen debt_change_04=(debt_y-l34.debt_y)/34 if year==2004
gen reserves_change_04=(reserves_y-l34.reserves_y)/34 if year==2004

gen debt_change_0421=(debt_y-l17.debt_y)/17 if year==2021
gen reserves_change_0421=(reserves_y-l17.reserves_y)/17 if year==2021

gen sample = poor==1 & (year==2004 | year==2021) & (nfa_change_04~=. | nfa_change_21~=.) & (pub_nfa_change_04~=. | pub_nfa_change_21~=.) ///
& (priv_nfa_change_04~=. | priv_nfa_change_21~=.) & (rel_growth_04~=. | rel_growth_21~=.)


gen b_sample = poor==1 & debt_y!=.
egen temp = min(b_sample), by(ifs_code)
gen balanced_sample=b_sample*temp


*Figure 1
egen mean_debt=mean(debt_y) if balanced_sample==1, by(year)
egen median_debt=median(debt_y) if balanced_sample==1, by(year)
egen idyear=tag(year) if balanced_sample==1

twoway (line mean_debt year if year<=2021 & idyear==1, lwidth(thick)) || (line median_debt year if year<=2021 & idyear==1, lwidth(thick)), ///
  xtitle(Year) ytitle(Avg Public Debt/Y) ///
graphr(fc(white)) graphr(c(white)) graphr(lcolor(white)) ylabel(,nogrid) ///
legend(label(1 "Mean") label(2 "Median"))
graph export "${figure_directory}Figure1.pdf", replace

*Figure 2
scatter  rel_growth_04  nfa_change_04 if sample==1 & year==2004, mlabel(country) mlabsize(1.75) msize(1.75) ///
xtitle(Change in Total NFA/Y) ytitle(GDP Growth 1970-2004) ///
 ||  lfit  rel_growth_04  nfa_change_04  if sample==1 & year==2004, m(i) c(l) legend(off) ///
ytick(-.05(.05).05) ylab(-.05(.05).05) yscale(titlegap(5)) xscale(titlegap(5)) ///
graphr(fc(white)) graphr(c(white)) graphr(lcolor(white)) ylabel(,nogrid)
graph export "${figure_directory}Figure2.pdf", replace


*Figure 3 
scatter  rel_growth_04  pub_nfa_change_04 if sample==1 & year==2004, mlabel(country) mlabsize(1.75) msize(1.75) ///
xtitle(Change in Public NFA/Y) ytitle(GDP Growth 1970-2004) ///
 ||  lfit  rel_growth_04  pub_nfa_change_04  if sample==1 & year==2004, m(i) c(l) legend(off) ///
ytick(-.05(.05).05) ylab(-.05(.05).05) yscale(titlegap(5)) xscale(titlegap(5)) ///
graphr(fc(white)) graphr(c(white)) graphr(lcolor(white)) ylabel(,nogrid)
graph export "${figure_directory}Figure3.pdf", replace

*Figure 4
scatter  rel_growth_04  priv_nfa_change_04 if sample==1 & year==2004, mlabel(country) mlabsize(1.75) msize(1.75) ///
xtitle(Change in Private NFA/Y) ytitle(GDP Growth 1970-2004) ///
 ||  lfit  rel_growth_04  priv_nfa_change_04  if sample==1 & year==2004, m(i) c(l) legend(off) ///
ytick(-.05(.05).05) ylab(-.05(.05).05) yscale(titlegap(5)) xscale(titlegap(5)) ///
graphr(fc(white)) graphr(c(white)) graphr(lcolor(white)) ylabel(,nogrid)
graph export "${figure_directory}Figure4.pdf", replace

*Figure 5 
scatter  mean_inv  debt_change_04 if sample==1 & year==2004, mlabel(country) mlabsize(1.75) msize(1.75) ///
 xtitle(Change in Public Debt/Y) ytitle(Mean Investment/Y 1970-2004) ///
 ||  lfit  mean_inv debt_change_04  if sample==1 & year==2004, m(i) c(l) legend(off) ///
 yscale(titlegap(5)) xscale(titlegap(5)) ///
graphr(fc(white)) graphr(c(white)) graphr(lcolor(white)) ylabel(,nogrid)
graph export "${figure_directory}/Figure5.pdf", replace

*Figure 6
scatter  rel_growth_21  pub_nfa_change_21 if sample==1 & year==2021, mlabel(country) mlabsize(1.75) msize(1.75) ///
xtitle(Change in Public NFA/Y) ytitle(GDP Growth 1970-2021) ///
 ||  lfit  rel_growth_21  pub_nfa_change_21  if sample==1 & year==2021, m(i) c(l) legend(off) ///
ytick(-.05(.05).05) ylab(-.05(.05).05) yscale(titlegap(5)) xscale(titlegap(5)) ///
graphr(fc(white)) graphr(c(white)) graphr(lcolor(white)) ylabel(,nogrid)
graph export "${figure_directory}Figure6.pdf", replace

*Figure 7
scatter  rel_growth_0421  pub_nfa_change_0421 if sample==1 & year==2021, mlabel(country) mlabsize(1.75) msize(1.75) ///
 xtitle(Change in Public NFA/Y) ytitle(GDP Growth 2004-2021) ///
 ||  lfit  rel_growth_0421  pub_nfa_change_0421  if sample==1 & year==2021, m(i) c(l) legend(off) ///
ytick(-.05(.05).05) ylab(-.05(.05).05) yscale(titlegap(5)) xscale(titlegap(5)) ///
graphr(fc(white)) graphr(c(white)) graphr(lcolor(white)) ylabel(,nogrid)
graph export "${figure_directory}Figure7.pdf", replace


*Figure 8
scatter  rel_growth_04  pub_nfa_change_04 if sample==1 & year==2004, mlabel(country) mlabsize(1.75) msize(1.75) ///
 xtitle(Change in Public NFA/Y) ytitle(GDP Growth) ///
 ||  scatter  rel_growth_21  pub_nfa_change_21 if sample==1 & year==2021,  mlabel(country) mlabsize(1.75) msize(1.75) msymbol(D) ///
 graphr(fc(white)) graphr(c(white)) graphr(lcolor(white)) ylabel(,nogrid) ///
 legend(label(1 "1970-2004") label(2 "1970-2021"))
graph export "${figure_directory}Figure8.pdf", replace

*Figure 9
scatter  sd_delta_y  debt_change_04 if sample==1 & year==2004, mlabel(country) mlabsize(1.75) msize(1.75) ///
 xtitle(Change in Public Debt/Y) ytitle(StDev Growth 1970-2004) ///
 ||  lfit  sd_delta_y debt_change_04  if sample==1 & year==2004, m(i) c(l) legend(off) ///
 yscale(titlegap(5)) xscale(titlegap(5)) ///
graphr(fc(white)) graphr(c(white)) graphr(lcolor(white)) ylabel(,nogrid)
graph export "${figure_directory}Figure9.pdf", replace


*Figure 10
scatter  sd_delta_gov  debt_change_04 if sample==1 & year==2004, mlabel(country) mlabsize(1.75) msize(1.75) ///
 xtitle(Change in Public Debt/Y) ytitle(StDev G Growth 1970-2004) ///
 ||  lfit  sd_delta_gov debt_change_04  if sample==1 & year==2004, m(i) c(l) legend(off) ///
yscale(titlegap(5)) xscale(titlegap(5)) ///
graphr(fc(white)) graphr(c(white)) graphr(lcolor(white)) ylabel(,nogrid)
graph export "${figure_directory}Figure10.pdf", replace


*Figure 11
scatter  rel_sd_gov  debt_change_04 if sample==1 & year==2004, mlabel(country) mlabsize(1.75) msize(1.75) ///
 xtitle(Change in Public Debt/Y) ytitle(StDev G Growth/StDev Y Growth 1970-2004) ///
 ||  lfit  rel_sd_gov debt_change_04  if sample==1 & year==2004, m(i) c(l) legend(off) ///
yscale(titlegap(5)) xscale(titlegap(5)) ///
graphr(fc(white)) graphr(c(white)) graphr(lcolor(white)) ylabel(,nogrid)
graph export "${figure_directory}Figure11.pdf", replace


*Figure 12
scatter  rel_sd_cons  debt_change_04 if sample==1 & year==2004, mlabel(country) mlabsize(1.75) msize(1.75) ///
 xtitle(Change in Public Debt/Y) ytitle(StDev Cons Growth/StDev Y Growth 1970-2004) ///
 ||  lfit  rel_sd_cons debt_change_04  if sample==1 & year==2004, m(i) c(l) legend(off) ///
 yscale(titlegap(5)) xscale(titlegap(5)) ///
graphr(fc(white)) graphr(c(white)) graphr(lcolor(white)) ylabel(,nogrid)
graph export "${figure_directory}Figure12.pdf", replace

