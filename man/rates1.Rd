% Generated by roxygen2: do not edit by hand
% Please edit documentation in R/data.R
\docType{data}
\name{rates1}
\alias{rates1}
\title{Fake data generated for horiuchi example.}
\format{
numeric vector of hypothetical fertility and mortality rates
\describe{
\item{Fx}{age specific fertility rates at time point 1}
}
}
\source{
Simulated values
}
\usage{
rates1
}
\description{
These are used to calculate the net reproductive ratio (NRR)
}
\examples{
\dontrun{
data(rates1)
data(rates2)
# nothing fancy
# compare Lx
plot(rates1[,1],type='l',col="blue")
lines(rates2[,1],col="green")
# compare Fx
plot(rates1[,2],type='l',col="blue")
lines(rates2[,2],col="green") 
}
}
\keyword{datasets}
