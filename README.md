[![Build Status](https://travis-ci.org/timriffe/DemoDecomp.svg?branch=master)](https://travis-ci.org/timriffe/DemoDecomp)
[![AppVeyor Build Status](https://ci.appveyor.com/api/projects/status/github/timriffe/DemoDecomp?branch=master&svg=true)](https://ci.appveyor.com/project/timriffe/DemoDecomp)
# DemoDecomp
General demographic decomposition methods


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