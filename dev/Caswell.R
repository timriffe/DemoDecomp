
# Author: tim
###############################################################################

# an implementation of LTRE
#' Caswell's LTRE method of decomposition
#' @description Caswell's Lifetable Response Experiment (LTRE) decomposed a vector-parameterized 
#' function by taking derivatives of the objective function with respect to each parameter. The 
#' sum-product of the resulting derivative vector and the change in parameter values is a first order
#' approximation of the decomposition. This implementation repeats this operation \code{N} times as 
#' \code{pars1} warps into \code{pars2} over \code{N} steps. This allows for arbitrary precision as 
#' \code{N} increases, as in the case of the Horiuchi approach. 
#' 
#' @note The case of \code{N=1} differentiates with respect to the arithmetic mean of \code{pars1}
#'  and \code{pars2}. The \code{...} argument can be used to send extra parameters to \code{func()} 
#' that do not get decomposed, or to specify other optional arguments to \code{numDeriv::grad()} 
#' for finer control. 
#' @importFrom numDeriv grad
#' @seealso \code{\link[numDeriv]{grad}}
#' @inheritParams horiuchi
#' @param ... \dots optional parameters to pass on to \code{func()}. These are not decomposed. Also one can use this argument to pass optional arguments to \code{numDeriv::grad()}.
#' @export
#' @references 
#' \insertRef{caswell1989analysis}{DemoDecomp}
#' \insertRef{caswell2006matrix}{DemoDecomp}

ltre <- function(func, pars1, pars2, dfunc, N = 20, ...){
	if (missing(dfunc)){
		dfunc <- numDeriv::grad
	}
	
	# what if user gives vector or matrix of derivatives?
	# then presumably the derivatives were taken along the 
	# same path from pars1 to pars2!!! 
#	numd <- FALSE
#	if (!is.function(dfunc)){
#		if (is.vector(dfunc) | is.matrix(dfunc)){
#			stopifnot( length(dfunc) %% N == 0 )
#			der   <- matrix(dfunc, ncol = N)
#			numd  <- TRUE
#		}
#	}
	delta       <- pars2 - pars1
	n 			<- length(pars1)
	ddelta 		<- delta / N
	x           <- pars1 + d * matrix(rep(.5:(N - .5) / N, n), 
			                          byrow = TRUE, 
									  ncol = N)
	cc          <- matrix(0, nrow = n, ncol = N)
	for (i in 1:N){
		cc[,i] <- dfunc(func, x[,i], ...) * ddelta
	}
	rowSums(cc)
}