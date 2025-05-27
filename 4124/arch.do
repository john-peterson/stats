


//////////////////////////////////////////////////////////////////////////////////
// File Description
// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*
Question 1e:
	1. Test the 5-day and 10-day ARCH effects
*/
//////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////
// Settings
// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
// Set working directory
cd "C:\Files\Backup\Kurser\Old courses\4124 - Advanced Empirical Methods in Finance\Assignment 2\Stata"
include "Question 1.do"
//////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////
// Prepare data
// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
// Make a continuous list of days
gen tlist = _n
tsset tlist
//////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////
// Show single model
// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
// Square returns
gen retx2 = retx ^ 2

// Create data variables
gen Label = ""
gen p5 = ""
gen p10 = ""
gen PACF = .

// Show correlation
levelsof ticker
local Loop = r(levels)
local i = 0
foreach l in `Loop' {
	local i = `i' + 1
	quietly replace Label = "`l'" in `i'

	wntestq retx2 if ticker == "`l'", lags(5)
	quietly replace p5 = cond(r(p) <= 0.05, "*", " ") + string(r(p), "%9.2f") in `i'

	wntestq retx2 if ticker == "`l'", lags(10)
	quietly replace p10 = cond(r(p) <= 0.05, "*", " ") + string(r(p), "%9.2f") in `i'
}

// Show results
format Label %-10s
list Label p5 p10 if _n < 8
//////////////////////////////////////////////////////////////////////////////////
