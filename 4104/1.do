

//////////////////////////////////
// File Description
// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*
Question 1: 
	1. This file is run from the sub question files
*/
//////////////////////////////////

///////////////////////////////////
// Settings
// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
// Turn off more
set more off

// Set working directory
*cd ""

// Clear Variables and Data
clear

// Memory settings
set memory 40M

// Print message
display _newline(5) "===============================" ///
	"===========" _newline(1) "Running: 1.do"
///////////////////////////////////

///////////////////////////////////
// Functions
// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
program drop _all
program define read_text
	// Variables
	local in_file = "`1'"
	local tmpfile = "`2'"

	// Read data
	insheet using "`in_file'", nonames clear

	// Run this enough times that all multiple spaces are replaced with a single space
	forvalues i = 1(1)5 {
		replace v1 = subinstr(v1, "  ", " ", .)
	}

	// Outsheet and insheet it
	replace v1 = subinstr(v1, " ", ";", .)
	outsheet v1 using `tmpfile', nonames noquote
	insheet using `tmpfile', names delimiter(";") clear
	erase `tmpfile'
	save `tmpfile'
end
///////////////////////////////////

///////////////////////////////////
// Read data
// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
// Temporary files
tempfile TmpFile0
tempfile TmpFile1

// Read 5x5 data
read_text "data/25_Portfolios_5x5 (Value Weighted Returns - Monthly).txt" `TmpFile0'
// Read market data
read_text "data/F-F_Research_Data_Factors (Monthly Factors).txt" `TmpFile1'

// Merge
clear
// Place date first
gen d = 0
merge using `TmpFile0'
drop _merge
merge using `TmpFile1'
// Remove unmerged months
drop if _merge == 2
drop _merge

// Create portfolio names, ex. p15 = small-high
local j = 1
local k = 1
forvalues i = 2(1)26 {
	// Drop bad data
	drop if v`i' < -99

	// Create excess returns
	replace v`i' = v`i' - rf

	// Rename
	rename v`i' p`k'`j'
	local j = `j' + 1
	if `j' > 5 {
		local j = 1
		local k = `k' + 1
	}
}

// Format dates
replace d = ym(real(substr(string(date), 1, 4)), real(substr(string(date), 5, 2)))
format d %tm
drop date
rename d date
///////////////////////////////////


