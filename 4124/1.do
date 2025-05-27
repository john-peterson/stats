


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
// Version
version 10
// Turn off more
set more off
// Clear variables and data
clear all
// Memory settings
set memory 50M
// Set working directory
*cd ""

// Clear screen
display _newline(100)
///////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////
// Read data
// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

// Select return period
local Period = "Day"
*local Period = "Month"

// --------------------------------------------------------------------
// Read data
// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
if "`Period'" == "Month" {
	insheet using data/CompMonthly.txt
}
else {
	insheet using data/CompDaily.txt
}

// Run this enough times that all multiple spaces are replaced with a single space
forvalues i = 1(1)5 {
	replace v1 = subinstr(v1, "  ", " ", .)
}

// Outsheet and insheet it
replace v1 = subinstr(v1, " ", ";", .)
tempfile TmpFile
outsheet v1 using `TmpFile', nonames noquote
insheet using `TmpFile', names delimiter(";") clear
erase `TmpFile'
// Convert the string returns to numerical returns
drop if _n <= 2
destring ret retx, replace
// Rename AIGR to AIG
*list if ticker == "AIGR"
replace ticker = "AIG" if ticker == "AIGR"
*list, clean
// --------------------------------------------------------------------

// --------------------------------------------------------------------
// Read additional data
// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*
*/
if "`Period'" == "Month" {
	append using ../Data/CAPMKTmonthly.dta
}
else {
	append using ../Data/CAPMKTdaily.dta
}

// Move dates to the same column
gen TmpDate = string(date(caldt, "MDY"), "%tdCCYYNNDD")
destring TmpDate, replace
replace date = TmpDate if date == .
drop TmpDate

// Remove non-matching dates
drop if date < 19860401

// Copy data to the same columns, use the 'vwretx' values without dividends since retx is without dividends
replace retx = vwretx if ticker == ""
replace ticker = "vwretx" if ticker == ""
// Expand data table
quietly summ retx if ticker == "AIG"
local N = _N + r(N)
set obs `N'
// Add the next set
replace retx = ewretx[_n - r(N)] if ticker == ""
replace date = date[_n - r(N)] if ticker == ""
replace ticker = "ewretx" if ticker == ""

// Remove uneeded columns
drop cap*ret vw* ew* totval
capture drop cap*ind

*list date caldt if _n < 10
*list date caldt
*halt
// --------------------------------------------------------------------

// Remove unwanted dates
drop if date < 19880101 | date >= 20080101

// Convert the returns to log returns
replace retx = log(1 + retx)
//////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////
// Make dates that Stata understand
// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯

// --------------------------------------------------------------------
// Make actual days
// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*
*/
gen long TmpDate = date
tostring TmpDate, replace usedisplayformat
if "`Period'" == "Month" {
	gen fmtdate = mofd(date(TmpDate, "YMD"))
	format fmtdate %tm
}
else {
	gen fmtdate = date(TmpDate, "YMD")
	format fmtdate %td
}

drop TmpDate
*drop date
*rename datenew date
*tsset date

*list date fmtdate if _n < 10
*halt
// --------------------------------------------------------------------

// --------------------------------------------------------------------
// Make a continuous list of days
// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/*
// Sort data
sort ticker date
drop date
by ticker: gen date = _n
*tsset date
*/
// --------------------------------------------------------------------
//////////////////////////////////////////////////////////////////////////////////

