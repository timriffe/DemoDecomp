
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
#' @details The case of \code{N=1} differentiates with respect to the arithmetic mean of \code{pars1} and \code{pars2}. The \code{...} argument can be used to send extra parameters to \code{func()} that do not get decomposed, or to specify other optional arguments to \code{numDeriv::grad()} for finer control. 
#' 
#' The argument \code{dfunc} is optional. If given, it should be a function written to have a first argument  \code{x}, which consists in the vector of decomposed parameters (same layout at \code{pars1} and \code{pars2}), and an option \code{...} argument for undecomposed parameters. Presumably if a derivative function is given then it is analytic or somehow a more parsimonious calculation than numeric derivatives. If left unspecified \code{numDeriv::grad()} is used.
#' 
#' As with \code{horiuchi()}, the path from \code{pars1} to \code{pars2} is linear, but other paths can be induced by parameterizing \code{func()} differently. For example, if you want proportional change from \code{pars1} to \code{pars2} then log them, and write \code{func()} to first antilog before continuing. This is not zero-friendly, but in practice power transforms give close results, so you could \code{sqrt()} and then square inside \code{func()}. If you do this, then \code{dfunc()} must be written to account for it too, or you could stick with the default numeric gradient function.
#' 
#' @importFrom numDeriv grad
#' @importFrom stats approx
#' @seealso \code{\link[numDeriv]{grad}}
#' @inheritParams horiuchi
#' @param ... \dots optional parameters to pass on to \code{func()}. These are not decomposed. Also one can use this argument to pass optional arguments to \code{numDeriv::grad()}.
#' @param dfunc a derivative function, see details
#' @export
#' @references 
#' \insertRef{caswell1989analysis}{DemoDecomp}
#' \insertRef{caswell2006matrix}{DemoDecomp}


ltre <-  function (func, pars1, pars2, dfunc, N = 20, ...) {
  dflag <- 0
  if (missing(dfunc)) {
    dfunc <- numDeriv::grad
    dflag <- 1
  }
  stopifnot(is.function(dfunc))
  stopifnot(length(pars1) == length(pars2))
  delta  <- pars2 - pars1
  n      <- length(pars1)
  ddelta <- delta/N
  P      <- cbind(pars1, pars2)
  if (N == 1) {
    x <- matrix(rowMeans(P))
  }
  
  if (N >= 2) {
    # let's go for N midpoints?
    x <- t(apply(P, 1, function(y, N) {
      xout <- seq(1/(2*N),1 - (1/(2*N)),length=N)
      c(approx(x = c(0, 1), y = y, xout = xout)$y)
    }, N = N))
    # check same
    # 	x           <- pars1 + ddelta * matrix(rep(.5:(N - .5) / N, n), 
    # 			                          byrow = TRUE, 
    # 									  ncol = N)
  }
  # TR: added 16-9-2024 so that names can be used to reconstruct
  # data inside func()
  rownames(x) <- names(pars1)
  
  cc <- matrix(0, nrow = n, ncol = N)
  for (i in 1:N) {
    if (dflag == 1){
      cc[, i] <- dfunc(func, x[, i],...) * ddelta
    } else {
      cc[, i] <- dfunc(x[, i],...) * ddelta
    }
  }
  out        <- rowSums(cc)
  names(out) <- names(pars1)
  out
}

# ltre <- function(func, pars1, pars2, dfunc, N = 20, ...){
# 	if (missing(dfunc)){ 
# 		dfunc <- numDeriv::grad
# 	}
# 	stopifnot(is.function(dfunc))
#     stopifnot(length(pars1) == length(pars2))
# 	
# 	
# 	delta       <- pars2 - pars1
# 	n 			<- length(pars1)
# 	ddelta 		<- delta / N
# 	
# 	x           <- pars1 + ddelta * matrix(rep(.5:(N - .5) / N, n), 
# 			                          byrow = TRUE, 
# 									  ncol = N)
# 	cc          <- matrix(0, nrow = n, ncol = N)
# 	for (i in 1:N){
# 		cc[,i] <- dfunc(func, x[,i], ...) * ddelta
# 	}
# 	rowSums(cc)
# }