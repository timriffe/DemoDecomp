# Author: tim
###############################################################################
shhh <- function(expr){
	capture.output(x <- suppressPackageStartupMessages(
					suppressMessages(suppressWarnings(expr))))
	invisible(x)
}

library(devtools)
#install_github("hadley/devtools")
# do this whenever new functions are added to /R, or whenever roxygen is updated
devtools::document("/home/tim/git/DemoDecomp")

# run this to get access to already-written functions
shhh(load_all("/home/tim/git/DemoDecomp"))

# do this whenever major changes happen
check("/home/tim/git/DemoDecomp")
#build(pkg = "/home/tim/git/DemoDecomp", path = "/home/tim/Desktop")
#?devtools::build
#devtools::use_testthat("/home/tim/git/DemoDecomp")

install_github("timriffe/DemoDecomp")
# these created the necessary files to run automatic remote code testing
#use_appveyor("/home/tim/git/DemoDecomp")
#use_travis("/home/tim/git/DemoDecomp")
#use_coverage(pkg = "/home/tim/git/DemoDecomp", type = c("codecov", "coveralls"))
build_win(pkg = "DemoDecomp") 

length(dir("/home/tim/git/DemoTools/man"))

