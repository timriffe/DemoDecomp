[![Build Status](https://travis-ci.org/timriffe/DemoDecomp.svg?branch=master)](https://travis-ci.org/timriffe/DemoDecomp)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/timriffe/DemoDecomp?branch=master&svg=true)](https://ci.appveyor.com/project/timriffe/DemoDecomp)
[![](https://img.shields.io/badge/devel%20version-1.0.1.9000-yellow.svg)](https://github.com/timriffe/DemoDecomp)
[![CRAN status](https://www.r-pkg.org/badges/version/DemoDecomp)](https://cran.r-project.org/package=DemoDecomp)
[![issues](https://img.shields.io/github/issues-raw/timriffe/DemoDecomp.svg)](https://github.com/timriffe/DemoDecomp/issues)
[![license](https://img.shields.io/badge/License-GPL%20v3-blue.svg)](https://github.com/timriffe/DemoDecomp/blob/master/LICENSE)
# `DemoDecomp`
General demographic decomposition methods

Install from CRAN in the standard way:
```r
install.packages("DemoDecomp")
```

Or install the github development version (maybe it has new toys!):
```r
# install.packages("devtools")

library(devtools)
install_github("timriffe/DemoDecomp")
```

Then you can run the examples like so:

```r
library(DemoDecomp)
data(rates1)
data(rates2)
# we need rates1 and rates2 as vectors
rates1 <- c(rates1)
rates2 <- c(rates2)

?horiuchi
A <- horiuchi(func = R0vec,
               pars1 = rates1,
               pars2 = rates2,
               N = 10,
               pfem = .4886) 
               
?stepwise_replacement      
B <- stepwise_replacement(func = R0vec,
               pars1 = rates1,
               pars2 = rates2,
               pfem = .4886,
               symmetrical = TRUE,
               direction = "up")                
```

This package supersedes [`DecompHoriuchi`](https://github.com/timriffe/DecompHoriuchi)
