# Author: tim
###############################################################################
shhh <- function(expr){
	capture.output(x <- suppressPackageStartupMessages(
					suppressMessages(suppressWarnings(expr))))
	invisible(x)
}
#setwd("/home/tim/git/DemoDecomp")
library(devtools)
#install_github("hadley/devtools")
# do this whenever new functions are added to /R, or whenever roxygen is updated
devtools::document()

# run this to get access to already-written functions
shhh(load_all())


# checks run Sept 17, 2024
devtools::check()      # OK
check_win_devel()      # 
check_win_release()    # 
check_win_oldrelease() # 
 
library(rhub)
rhub_check()

library(spelling)
spell_check()

devtools::release()

#build(pkg = "/home/tim/git/DemoDecomp", path = "/home/tim/Desktop")
#?devtools::build
#devtools::use_testthat("/home/tim/git/DemoDecomp")

install_github("timriffe/DemoDecomp")
# these created the necessary files to run automatic remote code testing
#use_appveyor("/home/tim/git/DemoDecomp")
#use_travis("/home/tim/git/DemoDecomp")
#use_coverage(pkg = "/home/tim/git/DemoDecomp", type = c("codecov", "coveralls"))




# length(dir("/home/tim/git/DemoTools/man"))
library(devtools)
build()

check()
  