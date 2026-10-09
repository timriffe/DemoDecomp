#' @title Numeric Approximation of Continuous Decomposition
#' 
#' @description This is an exact R implementation of the decomposition code in Matlab offered by the authors in the supplementary material given here: <http://www.demog.berkeley.edu/~jrw/Papers/decomp.suppl.pdf>. The input of `horiuchi()` are vectors `pars1` and `pars2`, and the user-supplied function `func()` should handle the bookkeeping of these as well as return a scalar. See examples for how to define `func()`, tips for handling the bookkeeping using the `...` arg, and how to use the (new) `components` argument to reduce computational burden.  
#' 
#' @param func A function specified by the user. This must be able to take the vectors `rates1` or 
#' \code{rates2} as its argument, and to return the value of the function, \code{y}, when evaluated for 
#' these rates. It may also have additional arguments, not to be decomposed.
#' @param pars1 vector of covariates to be passed on as arguments to \code{func()}. Covariates
#' can be in any order, as long as \code{func()} knows what to do with them. \code{pars1} is for time 1  (or population 1).
#' @param pars2 is the same as \code{pars2} but for time/population 2.
#' @param N The number of intervals to integrate over. 
#' @param \dots optional parameters to pass on to \code{func()}. These are not decomposed.
#' @param components A vector of non-missing group labels, with one element per parameter in \code{pars1} and \code{pars2}. Parameters sharing a label are perturbed jointly, producing one contribution per group. Labels may be numeric, character, or factor. By default each parameter is its own component. Supply this argument by name.
#' 
#' @details The decomposition works by assuming a linear change in all parameters between `pars1` and `pars2`. At each small step approaching time 2 (the size of which is `1/N` times the parameter difference) each parameter is moved forward along its linear trajectory. One at a time, each parameter is perturbed twice, once upward (proportional to `1/(2*N)`) and once downward. The difference between `func()` evaluated with these two rate vectors is the change in the scalar output attributable to that particular parameter and that particular interpolation step. Summing contributions over all N interpolation steps, we get the contribution to the difference of each parameter, `cc`. The sum of `cc` should come very close to `func(rates2)-func(rates1)`. The error decreases with larger `N`, but there is not much point in having an `N` higher than 100, and 20 (default) is usually sufficient. This ought to be able to handle a very wide variety of functions. 
#' 
#' If `pars1` are observations from 2005 and `pars2` are observations from 2006 an `N` of 20 would imply a delta of 1/20 of a year for each integration step. Higher `N` gives a lower total residual, but takes longer to compute. In general, there are decreasing returns to higher `N`. `sum(cc)` ought to approximate `func(rates2)-func(rates1)`.
#' 
#' (new) if `components` is supplied, all parameters in a component are perturbed together, while the full parameter vector is still passed to `func()`. This computes grouped contributions directly and reduces the number of function evaluations from  `2*N*length(pars1)` to `2*N*length(unique(components))`. This makes sense for large decomposition problems where results are destined to be aggregate for display purposes: in this case, just declare the groupings in advance and get back results pre-aggregated far faster.
#' 
#' Increase \code{N} to assess numerical convergence.
#' 
#' @return returns `cc`, a vector of the variable effects that is organized in the same way as `pars1` and `pars2`. 
#' @importFrom Rdpack reprompt
#' @references 
#' \insertRef{horiuchi2008decomposition}{DemoDecomp}
#' 
#' @examples 
#' 
#' data(rates1)
#' data(rates2)
#' 
#' # we need rates1 and rates2 as vectors
#' rates1 <- c(rates1)
#' rates2 <- c(rates2)
#' # look at the function:
#' R0vec
#' # 2 things to point out:
#' # 1) it has an argument pfem, proportion female of births (1/(1+SRB)), 
#' #    that must be specified, but that we don't care about decomposing
#' # 2) x is a single vector. The the inside of the function needs to 
#' #    either refer to parts of it by indexing, as done here, or else 
#' #    re-assign x to various objects. In this case x[1:l] is Lx and 
#' #    x[(l+1):(2*l)] is Fx...
#' A <- horiuchi(func = R0vec,
#'               pars1 = rates1,
#'               pars2 = rates2,
#'               N = 10,
#'               pfem = .4886)
#' # the output, A, is also a single vector. Each element corresponds 
#' # to the effect of changes in that particular covariate toward the 
#' # overall change in the function value. sum(A) should be close to
#' # original difference
#' (check1 <- R0vec(rates2) - R0vec(rates1)) 
#' (check2 <- sum(A))
#' 
#' \dontshow{
#' # de facto unit test. In this case the residual is very tiny,
#' # but if differences are very large and there are very many components,
#' # then the residual can be larger albeit trivial. In that case
#' # increase N and go make a coffee.
#' stopifnot(abs(check1 - check2) < 1e-6)
#' }
#' 
#' # This package does not supply default plotting functions, but one 
#' # strategy might be the following:
#' 
#' # reorder A into a matrix (sideways):
#' A <- t(matrix(A,ncol=2))
#' # call barplot() twice, once for positive values and again for
#' # negative values
#' Apos <- A * .5 * (sign(A) + 1)      
#' Aneg <- A * .5 * abs(sign(A) - 1)   
#' \dontrun{
#' barplot(Apos, 
#'         width = rep(1, length(A) / 2),
#'         space = 0, 
#'         ylim = range(A), 
#'         main = "A fake decomposition of R0",
#'         col=c("yellow","green"),
#'         axisnames = FALSE,
#'         xlim=c(0, 90), 
#'         ylab = "contrib to change in R0",
#'         cex.axis = .7)
#' barplot(Aneg, 
#'         width = rep(1, length(A) / 2),
#'         add = TRUE, 
#'         space = 0,
#'         col = c("yellow", "green"),
#'         axes = FALSE, axisnames = FALSE)
#' segments(seq(from=0,to=90,by=10),0,seq(from=0,to=90,by=10),-.027,lty=2,col="grey")
#' text(seq(from=0,to=90,by=10),-.027,seq(from=0,to=90,by=10),pos=1,xpd=T)
#' legend("bottomright",fill=c("yellow","green"),legend=c("contrib from change in Lx",
#' "contrib from change in Fx"),title="age specific contrib of changes in Fx and Lx",bg="white") 
#' }
#' # Direct grouped decomposition, retaining single-age inputs.
#' # LEdecomp is optional and is used only for its example dataset.
#' if (requireNamespace("LEdecomp", quietly = TRUE)) {
#'   example_env <- new.env()
#'   utils::data("US_data_CoD", package = "LEdecomp", envir = example_env)
#'   cod <- example_env$US_data_CoD
#'   cod <- cod[cod$year == 2010, ]
#'   keys <- c("age", "cause_id")
#'   male <- cod[cod$sex == "Male", c(keys, "mxc")]
#'   female <- cod[cod$sex == "Female", c(keys, "mxc")]
#'   names(male)[3] <- "Male"
#'   names(female)[3] <- "Female"
#'   rates <- merge(male, female, by = keys, sort = FALSE)
#'   rates <- rates[order(rates$age, rates$cause_id), ]
#'   rates$age10 <- rates$age - rates$age %% 10
#'
#'   # Illustrative truncated expectancy, assuming unit age intervals.
#'   # Bookkeeping data are passed through ... and are not decomposed.
#'   expectancy <- function(mxc, data) {
#'     mx <- rowsum(mxc, group = data$age, reorder = TRUE)[, 1]
#'     sum(c(1, exp(-cumsum(mx)))) - 0.5
#'   }
#'
#'   # Integer IDs preserve the mapping to the original group columns.
#'   labels <- interaction(rates$age10, rates$cause_id, drop = TRUE)
#'   component <- match(labels, unique(labels))
#'   grouped <- horiuchi(expectancy, rates$Male, rates$Female, N = 20,
#'                      data = rates, components = component)
#'   result <- rates[!duplicated(component), c("age10", "cause_id")]
#'   result$cc <- unname(grouped)
#'   head(result)
#'
#'   # Contributions should approximate the overall expectancy difference.
#'   difference <- expectancy(rates$Female, rates) -
#'                 expectancy(rates$Male, rates)
#'   c(difference = difference, contributions = sum(result$cc),
#'     residual = difference - sum(result$cc))
#' }
#' @export 
horiuchi <- function(func, pars1, pars2, N = 20, ...,
                     components = seq_along(pars1)) {
  default_components <- missing(components)
  if (length(pars1) == 0L || length(pars1) != length(pars2)) {
    stop("pars1 and pars2 must have the same positive length.")
  }
  if (length(components) != length(pars1) || anyNA(components)) {
    stop("components must have one non-missing label per parameter.")
  }
  if (length(N) != 1L || !is.numeric(N) || !is.finite(N) ||
      N < 1 || N != floor(N)) {
    stop("N must be a positive integer.")
  }
  
  d          <- pars2 - pars1
  ii         <- unique(components)
  n          <- length(ii)
  nn         <- length(pars1)
  half_delta <- d / (2 * N)
  grad       <- matrix(rep(0.5:(N - 0.5) / N, nn),
                       byrow = TRUE, ncol = N)
  x          <- pars1 + d * grad
  cc         <- matrix(0, nrow = n, ncol = N)
  zeros      <- rep(0, nn)
  
  # Preserve parameter names for functions that use them for bookkeeping.
  rownames(x) <- names(pars1)
  for (j in seq_len(N)) {
    for (i in seq_along(ii)) {
      ind         <- components == ii[i]
      deltai      <- zeros
      deltai[ind] <- half_delta[ind]
      cc[i, j]    <- func(x[, j] + deltai, ...) -
        func(x[, j] - deltai, ...)
    }
  }
  
  out <- rowSums(cc)
  names(out) <- if (default_components) names(pars1) else as.character(ii)
  out
}

# horiuchi <-
# 		function(func, pars1, pars2, N, ...){
# 
# 	d 			    <- pars2 - pars1
# 	n 			    <- length(pars1)
# 	delta 		  <- d / N
# 	grad        <- matrix(rep(.5:(N - .5) / N, n),
# 			              byrow = TRUE, ncol = N)
# 	x           <- pars1 + d * grad
# 	cc          <- matrix(0, nrow = n, ncol = N)
# 	# TR: added 16-9-2024 so that names can be used to reconstruct
# 	# data inside func()
# 	rownames(x) <- names(pars1)
# 	for (j in 1:N){
# 		DD <- diag(delta / 2)
# 		for (i in 1:n){
# 			cc[i,j] <- func((x[, j] + DD[, i]), ...) - func((x[, j] - DD[, i]), ...)
# 		}
# 	}	
# 
# 	out <- rowSums(cc)
# 	names(out) <- names(pars1)
# 	out
# }

#' @title R0vec Calculates net reproduction, R0, according to a given set of rates Lx,fx and a fixed
#'  proportion female of births, \code{pfem}.
#' 
#' @description This function is only provided for the examples of \code{horiuchi()}. 
#' It calculates the sum of the row products of \code{rates} multiplied by \code{pfem}.
#' 
#' @param x a single vector containing Lx followed by Fx or vice versa.  Here, \code{Lx} is the survival 
#' function integrated within each age interval and with a lifetable radix of 1. \code{Fx} is the 
#' fertility function, calculated as births/ person years of exposure. \code{Fx} should simply contain 
#' zeros in ages with no fertility, OR, all vectors should be limited to reproductive ages. Both 
#' \code{Lx} and \code{Fx} should for this function be of the same length.
#' @param pfem the proportion female of births. Something like .49, .48, or (1/(2.05)). This can either be specified as a single number, or it may be allowed to vary by age. For the later case, be sure to specify a value for each age (\code{length(x)/2} values). Default .4886.
#' 
#' @details The main feature that functions need to have when specified for \code{horiuchi()} or \code{stepwise\_replacement()} is that the rates must all go into a (potentially long) vector, probably consisting in your rate vectors one after the other. Really the decomposition function does not care how things are arranged in the vector- the components of change vector that is returned from \code{horiuchi()} will be  arranged in exactly the same way as its input rate vectors, so as long as you know how to sort it out, and your function can extract what it needs from the vectors, then it can be specified in any way. For this particular example function, \code{R0vec()}, \code{x} must be specified with either Lx followed by Fx or vice versa. It would also be possible to redefine the function to place \code{pfem} in with the rates vector, \code{x}, which would allow this item to be decomposed too. Here it is specified separately in order to demonstrate passing on parameters to the function within \code{horiuchi()}.
#' 
#' @return the value of R0 for the given set of rates and proportion female of births.
#' 
#' @export 
#' @examples 
#' data(rates1)
#' # take vec:
#' x <- c(rates1)
#' R0vec(x)

R0vec <-
		function(x, pfem = .4886){

	dim(x) <- c(length(x) / 2, 2)
	sum(x[, 1] * x[, 2] * pfem)
}
