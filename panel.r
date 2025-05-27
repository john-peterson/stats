library("plm" )
data("Cigar", package = "plm")
z <- Cigar[ Cigar$year %in% c( 63, 73) , ]

# R random
r = coef(plm(sales ~ pop, 
            data=z, 
            model="random", 
            index=c("state", "year")))
print(r)
#>   (Intercept)           pop 
#>  1.311398e+02 -6.837769e-04

# R fixed 
z2 <- pdata.frame( z , index=c("state", "year")  )    
r = coef( plm( sales ~ pop , data= z2  , model="within" ) )
print(r)
#>          pop 
#> -0.003210817

library(readstata13)
save.dta13(dat, file="cigar.dta")

library(RStata)
options("RStata.StataPath" = "/home/a/stata/stata")
options("RStata.StataVersion" = 14)

# Stata fe 
stata_do1 <- '
  xtset state year
  xtreg sales pop, fe
'
stata(stata_do1, data.out = TRUE, data.in = z)
#> . 
#> .   xtset state year
#>        panel variable:  state (strongly balanced)
#>         time variable:  year, 63 to 73, but with gaps
#>                 delta:  1 unit
#> .   xtreg sales pop, fe
#> 
#> Fixed-effects (within) regression               Number of obs     =         92
#> Group variable: state                           Number of groups  =         46
#> 
#> R-sq:                                           Obs per group:
#>      within  = 0.0118                                         min =          2
#>      between = 0.0049                                         avg =        2.0
#>      overall = 0.0048                                         max =          2
#> 
#>                                                 F(1,45)           =       0.54
#> corr(u_i, Xb)  = -0.3405                        Prob > F          =     0.4676
#> 
#> ------------------------------------------------------------------------------
#>        sales |      Coef.   Std. Err.      t    P>|t|     [95% Conf. Interval]
#> -------------+----------------------------------------------------------------
#>          pop |  -.0032108   .0043826    -0.73   0.468    -.0120378    .0056162
#>        _cons |   141.5186   18.06909     7.83   0.000     105.1256    177.9116
#> -------------+----------------------------------------------------------------


# Stata re
stata_do2 <- '
  xtset state year
  xtreg sales pop, re
'
stata(stata_do2, data.out = TRUE, data.in = z)
#> Random-effects GLS regression                   Number of obs     =         92
#> Group variable: state                           Number of groups  =         46
#> 
#> R-sq:                                           Obs per group:
#>      within  = 0.0118                                         min =          2
#>      between = 0.0049                                         avg =        2.0
#>      overall = 0.0048                                         max =          2
#> 
#>                                                 Wald chi2(1)      =       0.40
#> corr(u_i, X)   = 0 (assumed)                    Prob > chi2       =     0.5257
#> 
#> ------------------------------------------------------------------------------
#>        sales |      Coef.   Std. Err.      z    P>|z|     [95% Conf. Interval]
#> -------------+----------------------------------------------------------------
#>          pop |  -.0006838   .0010774    -0.63   0.526    -.0027955     .001428
#>        _cons |   131.1398   6.499511    20.18   0.000      118.401    143.8787
#> -------------+----------------------------------------------------------------
#>      sigma_u |  30.573218
#>      sigma_e |  15.183908
#>          rho |  .80214841   (fraction of variance due to u_i)
#> ------------------------------------------------------------------------------


