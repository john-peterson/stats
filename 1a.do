
// Read data
include "1.do"

//////////////////////////////
// Calculate standard deviations
// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
// Create new row
local N = _N + 2
local N_1 = _N + 1
set obs `N'

// Calculate standard deviations
forvalues i = 1(1)5 {
	forvalues j = 1(1)5 {
		quietly summ p`i'`j'
		replace p`i'`j' = r(mean) in `N_1'
		replace p`i'`j' = r(sd) in `N'
	}
}

// Remove everything but the mean and sd
drop if _n < _N - 1
// Transpose
xpose, clear varname
drop if missing(v1)
// Rename
replace _varname = substr(_varname, 2, 2)
rename v1 mean
rename v2 sd
list
//////////////////////////////////

///////////////////////////////
// Plot portfolios
// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
scatter mean sd, mlabel(_varname) ///
		ytitle("E[excess return]") ylabel(0(0.5)1.6) ///
		xtitle("Standard deviation of excess return") xlabel(0(1)13)
/////////////////////////////////