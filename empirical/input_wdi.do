set more off 

*Set directory to store data
global directory "./data/"

wbopendata, language(en - English) ///
	indicator(NY.GDP.MKTP.CD; NY.GDP.MKTP.KN; NY.GDP.PCAP.KN; NY.GDP.PCAP.KD; ///
	DT.DOD.DPPG.CD; FI.RES.XGLD.CD;  ///
	NE.GDI.TOTL.ZS; NE.GDI.TOTL.CD; NE.GDI.TOTL.KN; NE.GDI.FPRV.ZS; ///
	NE.CON.GOVT.ZS; NE.CON.GOVT.CD; NE.CON.GOVT.KN; ///
	NE.CON.TOTL.ZS; NE.CON.TOTL.CD; NE.CON.TOTL.KN) year(1970:2023) clear

replace indicatorcode="real_gdp" if indicatorcode=="NY.GDP.MKTP.KN"
replace indicatorcode="dollar_gdp" if indicatorcode=="NY.GDP.MKTP.CD"
replace indicatorcode="per_cap_gdp" if indicatorcode=="NY.GDP.PCAP.KN"
replace indicatorcode="per_cap_dollar" if indicatorcode=="NY.GDP.PCAP.KD"
replace indicatorcode="ppg_debt" if indicatorcode=="DT.DOD.DPPG.CD"
replace indicatorcode="reserves" if indicatorcode=="FI.RES.XGLD.CD"
replace indicatorcode="inv_y" if indicatorcode=="NE.GDI.TOTL.ZS"
replace indicatorcode="inv_private_y" if indicatorcode=="NE.GDI.FPRV.ZS"
replace indicatorcode="inv_dollar" if indicatorcode=="NE.GDI.TOTL.CD"
replace indicatorcode="inv_real" if indicatorcode=="NE.GDI.TOTL.KN"
replace indicatorcode="gov_y" if indicatorcode=="NE.CON.GOVT.ZS"
replace indicatorcode="gov_dollar" if indicatorcode=="NE.CON.GOVT.CD"
replace indicatorcode="gov_real" if indicatorcode=="NE.CON.GOVT.KN"
replace indicatorcode="con_y" if indicatorcode=="NE.CON.TOTL.ZS"
replace indicatorcode="con_dollar" if indicatorcode=="NE.CON.TOTL.CD"
replace indicatorcode="con_real" if indicatorcode=="NE.CON.TOTL.KN"

drop indicatorname

/* add in ifs_code*/
gen ifs_code=.

replace ifs_code=914 if countryname== "Albania" 
replace ifs_code=612 if countryname== "Algeria" 
replace ifs_code=614 if countryname== "Angola" 
replace ifs_code=213 if countryname== "Argentina" 
replace ifs_code=911 if countryname== "Armenia" 
replace ifs_code=193 if countryname== "Australia" 
replace ifs_code=122 if countryname== "Austria" 
replace ifs_code=912 if countryname== "Azerbaijan" 
replace ifs_code=419 if countryname== "Bahrain" 
replace ifs_code=513 if countryname== "Bangladesh" 
replace ifs_code=913 if countryname== "Belarus" 
replace ifs_code=124 if countryname== "Belgium" 
replace ifs_code=638 if countryname== "Benin" 
replace ifs_code=218 if countryname== "Bolivia" 
replace ifs_code=963 if countryname== "Bosnia and Herzegovina" 
replace ifs_code=616 if countryname== "Botswana" 
replace ifs_code=223 if countryname== "Brazil" 
replace ifs_code=516 if countryname== "Brunei Darussalam" 
replace ifs_code=918 if countryname== "Bulgaria" 
replace ifs_code=748 if countryname== "Burkina Faso" 
replace ifs_code=522 if countryname== "Cambodia" 
replace ifs_code=622 if countryname== "Cameroon" 
replace ifs_code=156 if countryname== "Canada" 
replace ifs_code=628 if countryname== "Chad" 
replace ifs_code=228 if countryname== "Chile" 
replace ifs_code=924 if countryname== "China" 
replace ifs_code=233 if countryname== "Colombia" 
replace ifs_code=636 if countryname== "Congo, Dem Rep" 
replace ifs_code=634 if countryname== "Congo, Rep" 
replace ifs_code=238 if countryname== "Costa Rica" 
replace ifs_code=960 if countryname== "Croatia" 
replace ifs_code=423 if countryname== "Cyprus" 
replace ifs_code=935 if countryname== "Czech Republic" 
replace ifs_code=662 if countryname== "Cote d'Ivoire" 
replace ifs_code=128 if countryname== "Denmark" 
replace ifs_code=243 if countryname== "Dominican Republic" 
replace ifs_code=248 if countryname== "Ecuador" 
replace ifs_code=469 if countryname== "Egypt, Arab Rep" 
replace ifs_code=253 if countryname== "El Salvador" 
replace ifs_code=642 if countryname== "Equatorial Guinea" 
replace ifs_code=939 if countryname== "Estonia" 
replace ifs_code=644 if countryname== "Ethiopia" 
replace ifs_code=163 if countryname== "Euro area" 
replace ifs_code=819 if countryname== "Fiji" 
replace ifs_code=172 if countryname== "Finland" 
replace ifs_code=132 if countryname== "France" 
replace ifs_code=646 if countryname== "Gabon" 
replace ifs_code=915 if countryname== "Georgia" 
replace ifs_code=134 if countryname== "Germany" 
replace ifs_code=652 if countryname== "Ghana" 
replace ifs_code=174 if countryname== "Greece" 
replace ifs_code=258 if countryname== "Guatemala" 
replace ifs_code=656 if countryname== "Guinea" 
replace ifs_code=263 if countryname== "Haiti" 
replace ifs_code=268 if countryname== "Honduras" 
replace ifs_code=532 if countryname== "Hong Kong SAR, China" 
replace ifs_code=944 if countryname== "Hungary" 
replace ifs_code=176 if countryname== "Iceland" 
replace ifs_code=534 if countryname== "India" 
replace ifs_code=536 if countryname== "Indonesia" 
replace ifs_code=429 if countryname== "Iran, Islamic Rep" 
replace ifs_code=178 if countryname== "Ireland" 
replace ifs_code=436 if countryname== "Israel" 
replace ifs_code=136 if countryname== "Italy" 
replace ifs_code=343 if countryname== "Jamaica" 
replace ifs_code=158 if countryname== "Japan" 
replace ifs_code=439 if countryname== "Jordan" 
replace ifs_code=916 if countryname== "Kazakhstan" 
replace ifs_code=664 if countryname== "Kenya" 
replace ifs_code=542 if countryname== "Korea, Rep" 
replace ifs_code=443 if countryname== "Kuwait" 
replace ifs_code=917 if countryname== "Kyrgyz Republic" 
replace ifs_code=544 if countryname== "Lao PDR" 
replace ifs_code=941 if countryname== "Latvia" 
replace ifs_code=446 if countryname== "Lebanon" 
replace ifs_code=672 if countryname== "Libya" 
replace ifs_code=946 if countryname== "Lithuania" 
replace ifs_code=137 if countryname== "Luxembourg" 
replace ifs_code=674 if countryname== "Madagascar" 
replace ifs_code=676 if countryname== "Malawi" 
replace ifs_code=548 if countryname== "Malaysia" 
replace ifs_code=678 if countryname== "Mali" 
replace ifs_code=181 if countryname== "Malta" 
replace ifs_code=684 if countryname== "Mauritius" 
replace ifs_code=273 if countryname== "Mexico" 
replace ifs_code=921 if countryname== "Moldova" 
replace ifs_code=686 if countryname== "Morocco" 
replace ifs_code=688 if countryname== "Mozambique" 
replace ifs_code=518 if countryname== "Myanmar" 
replace ifs_code=728 if countryname== "Namibia" 
replace ifs_code=558 if countryname== "Nepal" 
replace ifs_code=138 if countryname== "Netherlands" 
replace ifs_code=196 if countryname== "New Zealand" 
replace ifs_code=278 if countryname== "Nicaragua" 
replace ifs_code=692 if countryname== "Niger" 
replace ifs_code=694 if countryname== "Nigeria" 
replace ifs_code=142 if countryname== "Norway" 
replace ifs_code=449 if countryname== "Oman" 
replace ifs_code=564 if countryname== "Pakistan" 
replace ifs_code=283 if countryname== "Panama" 
replace ifs_code=853 if countryname== "Papua New Guinea" 
replace ifs_code=288 if countryname== "Paraguay" 
replace ifs_code=293 if countryname== "Peru" 
replace ifs_code=566 if countryname== "Philippines" 
replace ifs_code=964 if countryname== "Poland" 
replace ifs_code=182 if countryname== "Portugal" 
replace ifs_code=453 if countryname== "Qatar" 
replace ifs_code=968 if countryname== "Romania" 
replace ifs_code=922 if countryname== "Russian Federation" 
replace ifs_code=714 if countryname== "Rwanda" 
replace ifs_code=456 if countryname== "Saudi Arabia" 
replace ifs_code=722 if countryname== "Senegal" 
replace ifs_code=576 if countryname== "Singapore" 
replace ifs_code=936 if countryname== "Slovak Republic" 
replace ifs_code=961 if countryname== "Slovenia" 
replace ifs_code=199 if countryname== "South Africa" 
replace ifs_code=184 if countryname== "Spain" 
replace ifs_code=524 if countryname== "Sri Lanka" 
replace ifs_code=732 if countryname== "Sudan" 
replace ifs_code=144 if countryname== "Sweden" 
replace ifs_code=146 if countryname== "Switzerland" 
replace ifs_code=463 if countryname== "Syrian Arab Republic" 
replace ifs_code=923 if countryname== "Tajikistan" 
replace ifs_code=738 if countryname== "Tanzania" 
replace ifs_code=578 if countryname== "Thailand" 
replace ifs_code=742 if countryname== "Togo" 
replace ifs_code=369 if countryname== "Trinidad and Tobago" 
replace ifs_code=744 if countryname== "Tunisia" 
replace ifs_code=186 if countryname== "Turkey" 
replace ifs_code=925 if countryname== "Turkmenistan" 
replace ifs_code=746 if countryname== "Uganda" 
replace ifs_code=926 if countryname== "Ukraine" 
replace ifs_code=466 if countryname== "United Arab Emirates" 
replace ifs_code=112 if countryname== "United Kingdom" 
replace ifs_code=111 if countryname== "United States" 
replace ifs_code=298 if countryname== "Uruguay" 
replace ifs_code=927 if countryname== "Uzbekistan" 
replace ifs_code=299 if countryname== "Venezuela, RB" 
replace ifs_code=582 if countryname== "Vietnam" 
replace ifs_code=474 if countryname== "Yemen, Rep" 
replace ifs_code=754 if countryname== "Zambia" 
replace ifs_code=698 if countryname== "Zimbabwe" 

drop if ifs_code==.

reshape long yr, i(countrycode indicatorcode) j(year)
rename yr value 

reshape wide value, i(ifs_code year) j(indicatorcode) string

foreach v in real_gdp dollar_gdp per_cap_gdp per_cap_dollar ppg_debt reserves inv_y inv_private_y inv_dollar inv_real gov_y gov_dollar ///
gov_real con_y con_dollar con_real { 
	rename value`v' `v'
}
	

sort ifs_code year
	
save "${directory}wdi_data.dta", replace 
 

* EWN database
clear
import excel "${directory}EWN-dataset_12-2022.xlsx", cellrange(A1:AA11129) sheet(Dataset) first case(lower)

keep totalassets totalliab country ifs_code year
rename totalassets assets
rename totalliab liabilities

/*re-scale the lane data to match the wdi data*/

foreach var of varlist assets liab {
	replace `var'=`var'*1000000
}

gen net_assets=assets-liabilities

sort ifs_code year

save "${directory}EWN.dta", replace 


*Merge
use "${directory}wdi_data.dta", clear
merge ifs_code year using  "${directory}EWN.dta", update nokeep

tab _merge

drop _merge


save "${directory}debt_data", replace

*these files will not be used again
*rm "${directory}wdi_data.dta"
*rm "${directory}EWN.dta"

