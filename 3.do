


//////////////////////////////////////////////////////////////////////////////////
// File Description
// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*
Question 1: 
	1. This file is run from the sub question files
*/
//////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////
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
display _newline(5) "==========================================================================" ///
	"===========" _newline(1) "Running: Question 3.do"
///////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////
// Functions
// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
program drop _all
program define read_text
	syntax [anything] [ , transpose(string) ]

	// Variables
	local in_file = "`1'"
	local tmpfile = "`2'"

	// Read data
	insheet using "`in_file'", nonames clear

	// Run this enough times that all multiple spaces are replaced with a single space
	forvalues i = 1(1)10 {
		replace v1 = subinstr(v1, "  ", " ", .)
	}

	// Outsheet and insheet it
	replace v1 = subinstr(v1, " ", ";", .)
	outsheet v1 using "`tmpfile'", nonames noquote
	insheet using "`tmpfile'", names delimiter(";") clear
	erase `tmpfile'

	// Transpose
	if "`transpose'" != "" {
		xpose, clear varname
		renpfix v "`transpose'"
	}

	save "`tmpfile'"
end
//////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////
// Read data
// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

// Temporary files
tempfile TmpFile0
tempfile TmpFile1
tempfile TmpFile2

// Read industry returns
read_text "../Data/10_Industry_Portfolios (Average Value Weighted Returns – Monthly).txt" "`TmpFile0'", transpose("r")
// Read industry size
read_text "../Data/10_Industry_Portfolios (Average Firm Size).txt" "`TmpFile1'", transpose(s)
// Read market data
*read_text "../Data/F-F_Research_Data_Factors (Monthly Factors).txt" "`TmpFile2'"

// Merge
use `TmpFile0', clear
merge using `TmpFile1'
drop _merge

halt

*merge using `TmpFile2'
// Remove unmerged months
*drop if _merge == 2
*drop _merge

// Format dates
replace d = ym(real(substr(string(date), 1, 4)), real(substr(string(date), 5, 2)))
format d %tm
drop date
rename d date
//////////////////////////////////////////////////////////////////////////////////


