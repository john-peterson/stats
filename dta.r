library(readstata13)
data("Cigar", package = "plm")
dat <- Cigar[ Cigar$year %in% c( 63, 73) , ]
# dat <- read.dta13("path to file.dta")
save.dta13(dat, file="cigar.dta")

library(haven)
copypath <- system.file("examples", "iris.dta", package = "haven")
read_dta(path)

tmp <- tempfile(fileext = ".dta")
write_dta(mtcars, tmp)
read_dta(tmp)
read_stata(tmp)

