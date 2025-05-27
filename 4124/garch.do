


//////////////////////////////////////////////////////////////////////////////////
// File Description
// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*
Question 1hi:
	1. Fit a GARCH model
	2. Fit a GARCH-M model
*/
//////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////
// Settings
// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
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
// Show single GARCH or GARCH-M model
// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

arch retx if ticker == "ewretx", arch(1) garch(1)
*arch retx if ticker == "ewretx", arch(1) garch(1) archmlags(1)
*halt

//////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////
// Show GARCH-M
// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

// Create data variables
gen Label = ""
gen arch = ""
gen garch = ""
gen archp = ""
gen garchp = ""
gen p = .

// Show correlation
levelsof ticker
local Loop = r(levels)
local i = 0
foreach l in `Loop' {
	local i = `i' + 1
	quietly replace Label = "`l'" in `i'
	
	quietly arch retx if ticker == "`l'", arch(1) garch(1)
	*quietly arch retx if ticker == "`l'", arch(1) garch(1) archmlags(1)
	*estat ic

	// Save the p-values
	local archp = (1 - normal([ARCH]_b[L.arch] / [ARCH]_se[L.arch])) * 2
	local garchp = (1 - normal([ARCH]_b[L.garch] / [ARCH]_se[L.garch])) * 2
	quietly replace archp = string(`archp', "%9.3f") in `i'
	quietly replace garchp = string(`garchp', "%9.3f") in `i'

	// Save the coefficients
	quietly replace arch = cond(`archp' <= 0.05, "*", " ") + string([ARCH]_b[L.arch], "%9.2f") in `i'
	quietly replace garch = cond(`garchp' <= 0.05, "*", " ") + string([ARCH]_b[L.garch], "%9.2f") in `i'

	// Save the the GARCH-M p-value
	*replace p = cond(e(p) <= 0.05, "*", " ") + string(e(p), "%9.2f") in `i'
}

// Show results
*format p %9.2f
format Label %-10s
list Label arch archp garch garchp if _n < 8
//////////////////////////////////////////////////////////////////////////////////
