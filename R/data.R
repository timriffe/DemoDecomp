# documentation for data objects.


#' Year 2002 death rates by cause for US males in abridged age classes
#'
#' A matrix containing death rates for six causes (one of which is other) for abrdged age classes 0-85. Ages are labelled in rows, and causes in column names.
#'
#' @format A matrix with 19 rows and 6 columns

#' @source \url{https://www.demogr.mpg.de/en/projects_publications/publications_1904/mpidr_technical_reports/an_excel_spreadsheet_for_the_decomposition_of_a_difference_between_two_values_of_an_aggregate_4591.htm}
"Mxc1"

#' Year 2002 death rates by cause for England and Wales males in abridged age classes
#'
#' A matrix containing death rates for six causes (one of which is other) for abrdged age classes 0-85. Ages are labelled in rows, and causes in column names.
#'
#' @format A matrix with 19 rows and 6 columns

#' @source \url{https://www.demogr.mpg.de/en/projects_publications/publications_1904/mpidr_technical_reports/an_excel_spreadsheet_for_the_decomposition_of_a_difference_between_two_values_of_an_aggregate_4591.htm}
"Mxc2"

#' Comparison decomposition results by age and cause
#'
#' A matrix containing the contributions to the difference in life expectancy at birth between 2002 US males and England and Wales males. Ages (in rows) are in abridged categories, 0-85, and there are six causes, including other, in columns. The sum of the matrix is the difference in life expectancy at birth between the two populations. Values are based on symmetrical stepwise replacement from young to old ages only. This is just to make sure implementation is close.
#'
#' @format A matrix with 19 rows and 6 columns

#' @source \url{https://www.demogr.mpg.de/en/projects_publications/publications_1904/mpidr_technical_reports/an_excel_spreadsheet_for_the_decomposition_of_a_difference_between_two_values_of_an_aggregate_4591.htm}
"Compare"



#' @title Fake data generated for horiuchi example.
#' @description
#' The first column \code{Lx} is a discrete survival function for time point 1. The second column \code{Fx} are age specific fertility rates.
#' 
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
#' 
#' @keywords datasets
#' 
#' @docType data
"rates1"


#' @title Fake data generated for example.
#' @description
#' The first column \code{Lx} is a discrete survival function for time point 2. The second column \code{Fx} are age specific fertility rates.
#' 
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
#' 
#' @keywords datasets
#' @docType data 
"rates2"