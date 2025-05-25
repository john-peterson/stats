



//////////////////////////////////////////////////////////////////////////////////
// Settings
// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
// Turn off more
/* set more off */
// Set working directory
*cd ""
// Clear variables
clear
// Memory settings
*set memory 20M
// Clear output
display _newline(200)
//////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////
// Read data
// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
// Read data
use crime.dta

// Xtreg settings
iis state
tis year

// Logarithmic data
gen lVio = ln(vio)
gen lRob = ln(rob)
gen lMur = ln(mur)

// Year dummies
tab year, gen(dy)
// State dummies
tab stateid, gen(ds)
//////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////
// Descriptive statistics
// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
summ vio if state == 1
line vio year if state == 1
//////////////////////////////////////////////////////////////////////////////////



//////////////////////////////////////////////////////////////////////////////////
// 1a: Pooled-OLS estimate
// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/* 
regress lVio shall, robust
regress lVio shall incarc_rate density avginc pop pb1064 pw1064 pm1029, robust
*/
//////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////
// 1b: State-specific effects estimate
// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/* 
xtreg lVio shall incarc_rate density avginc pop pb1064 pw1064 pm1029, fe robust
*/
//////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////
// 1c: Test for existence of state-specific effects estimate
// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/* 
// F Test
reg lVio shall incarc_rate density avginc pop pb1064 pw1064 pm1029 ds2-ds51, robust
testparm ds2-ds51
*/
//////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////
// 1d: Two-way state-fixed time-specific effects estimate
// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/* 
xtreg lVio shall incarc_rate density avginc pop pb1064 pw1064 pm1029 dy2-dy23, fe robust
testparm dy2-dy23
*/
//////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////
// 1e: Robbery rate and murder rate
// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/* 
regress lRob shall, robust
regress lRob shall incarc_rate density avginc pop pb1064 pw1064 pm1029, robust
xtreg lRob shall incarc_rate density avginc pop pb1064 pw1064 pm1029, fe robust
reg lRob shall incarc_rate density avginc pop pb1064 pw1064 pm1029 ds2-ds51, robust
testparm ds2-ds51
xtreg lRob shall incarc_rate density avginc pop pb1064 pw1064 pm1029 dy2-dy23, fe robust
testparm dy2-dy23
*/

/* 
regress lMur shall, robust
regress lMur shall incarc_rate density avginc pop pb1064 pw1064 pm1029, robust
xtreg lMur shall incarc_rate density avginc pop pb1064 pw1064 pm1029, fe robust
reg lMur shall incarc_rate density avginc pop pb1064 pw1064 pm1029 ds2-ds51, robust
testparm ds2-ds51
xtreg lMur shall incarc_rate density avginc pop pb1064 pw1064 pm1029 dy2-dy23, fe robust
testparm dy2-dy23
*/
//////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////
// 1f: Random-effects model
// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/* */
xtreg lVio shall incarc_rate density avginc pop pb1064 pw1064 pm1029, re robust
// Display lambda variable
display e(theta)
//////////////////////////////////////////////////////////////////////////////////


//////////////////////////////////////////////////////////////////////////////////
// 1g: Hausman test
// ¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯¯
/* 
quietly xtreg lVio shall incarc_rate density avginc pop pb1064 pw1064 pm1029, fe
estimates store FE
quietly xtreg lVio shall incarc_rate density avginc pop pb1064 pw1064 pm1029, re
estimates store RE
hausman FE RE
*/
//////////////////////////////////////////////////////////////////////////////////



