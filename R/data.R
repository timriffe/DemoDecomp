# documentation for data objects.


#' Year 2002 death rates by cause for US males in abridged age classes
#'
#' A matrix containing death rates for six causes (one of which is other) for abridged age classes 0-85. Ages are labelled in rows, and causes in column names.
#'
#' @format 
#' A matrix with 19 rows and 6 columns
#' @source 
#' \url{https://www.demogr.mpg.de/papers/technicalreports/tr-2010-002-files.zip}
"Mxc1"

#' Year 2002 death rates by cause for England and Wales males in abridged age classes
#'
#' A matrix containing death rates for six causes (one of which is other) for abrdged age classes 0-85. Ages are labelled in rows, and causes in column names.
#'
#' @format 
#' A matrix with 19 rows and 6 columns
#' @source 
#' \url{https://www.demogr.mpg.de/papers/technicalreports/tr-2010-002-files.zip}
"Mxc2"

#' Fake data generated for horiuchi example.
#' 
#' These are used to calculate the net reproductive ratio (NRR)
#' @format 
#' numeric vector of hypothetical fertility and mortality rates
#' \describe{
#' \item{Fx}{age specific fertility rates at time point 1}
#' }
#' @source 
#' Simulated values
#' @examples 
#' \dontrun{
#' data(rates1)
#' data(rates2)
#' # nothing fancy
#' # compare Lx
#' plot(rates1[,1],type='l',col="blue")
#' lines(rates2[,1],col="green")
#' # compare Fx
#' plot(rates1[,2],type='l',col="blue")
#' lines(rates2[,2],col="green") 
#' }
"rates1"


#' Fake data generated for horiuchi example.
#' 
#' These are used to calculate the net reproductive ratio (NRR)
#' @format 
#' numeric vector of hypothetical fertility and mortality rates
#' \describe{
#' \item{Lx}{a discrete survival function at time point 2}
#' \item{Fx}{age specific fertility rates at time point 2}
#' }
#' @source 
#' Simulated values
#' @examples 
#' \dontrun{
#' data(rates1)
#' data(rates2)
#' # nothing fancy
#' # compare Lx
#' plot(rates1[,1],type='l',col="blue")
#' lines(rates2[,1],col="green")
#' # compare Fx
#' plot(rates1[,2],type='l',col="blue")
#' lines(rates2[,2],col="green") 
#' }
"rates2"