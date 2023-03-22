
# Author: tim
###############################################################################

#' @title implementation of the decomposition algorithm of stepwise replacement  
#' @description This implements the algorithm described in Andreev et al (2002), with defaults set
#' to approximate their recommendations for replacement ordering and result averaging.
#' @details The \code{symmetrical} argument toggles whether or not we replace pars1 with pars2 (\code{FALSE}), 
#' or take the arithmetic average or replacement in both directions. \code{direction} refers to whether we go 
#' from the bottom up or top down, or take the arithmetic average of these when replacing vector elements. 
#' Although the total difference will always sum correctly, the calculated contribution from individual components 
#' can vary greatly depending on the order in general. Defaults are set to symmetrically replace from the bottom 
#' up, per the authors' suggestion.
#' 
#' @param func A function specified by the user. This must be able to take the vectors \code{pars1} or 
#' \code{pars2} as its argument, and to return the value of the function, \code{y}, when evaluated for 
#' these rates. It may also have additional arguments, not to be decomposed.
#' @param pars1 vector of covariates to be passed on as arguments to \code{func()}. Covariates
#' can be in any order, as long as \code{func()} knows what to do with them. \code{pars1} is for time 1 
#' (or population 1).
#' @param pars2 is the same as \code{pars1} but for time/population 2.
#' @param symmetrical logical. default \code{TRUE} as recommended by authors. Shall we average the results of replacing 1 with 2 and 2 with 1?
#' @param direction character. One of \code{"up"}, \code{"down"}, or \code{"both"}. Default \code{"up"}, as recommended by authors.
#' @param \dots optional parameters to pass on to \code{func()}.
#' 
#' @references
#' \insertRef{horiuchi2008decomposition}{DemoDecomp}
#' \insertRef{andreev2012excel}{DemoDecomp}
#' @export
#' @return a matrix of the variable effects that is organized in the same way as 
#' \code{pars1} and \code{pars2}.

#' @examples 
#' data(Mxc1)
#' data(Mxc2)
#' # we'll want to pass in these dimensions
#' dims  <- dim(Mxc1)
#' # we need parameters in vec form
#' Mxc1v <- c(Mxc1)
#' Mxc2v <- c(Mxc2)
#' B     <- stepwise_replacement(func = Mxc2e0abrvec, 
#' 		pars1 = Mxc1v, pars2 = Mxc2v, dims = dims, 
#' 		# authors' recommendations:
#' 		symmetrical = TRUE, direction = "up")
#' dim(B) <- dims
#' # the output, B, is also a single vector. Each element corresponds 
#' # to the effect of changes in that particular covariate toward the 
#' # overall change in the function value. sum(B) should equal the
#' # original difference
#' (check1 <- Mxc2e0abr(Mxc2) - Mxc2e0abr(Mxc1))
#' (check2 <- sum(B))
#' \dontshow{
#' # de facto unit test. In this case the residual is very tiny,
#' # but if differences are very large and there are very many components,
#' # then the residual can be larger albeit trivial. In that case
#' # increase N and go make a coffee.
#' stopifnot(abs(check1 - check2) < .Machine$double.eps)
#' check3 <- Mxc2e0abrvec(Mxc2v, dims = dims)- Mxc2e0abrvec(Mxc1v, dims = dims)
#' stopifnot(abs(check3 - check2) < .Machine$double.eps)
#' }
#' 
#' # This package does not supply default plotting functions, but one 
#' # strategy might be the following:
#' \dontrun{
#' Age <- c(0, 1, seq(5, 85, by = 5))
#' matplot(Age, B, type = 'l', 
#' xlab = "Age", ylab = "Contrib to diff in e(0)", col = 1:6)
#' legend("bottomleft",lty=1:5,col=1:6, 
#'          legend = c("Neoplasms","Circulatory","Respiratory",
#'				     "Digestive","Acc/viol","Other"))
#' }

stepwise_replacement <- function(func, pars1, pars2, symmetrical = TRUE, direction = "up",...){
	direction <- tolower(direction)
	stopifnot(direction %in% c("up","down","both"))
	
	up                   <- direction %in% c("up","both")
	down                 <- direction %in% c("down","both")
	N                    <- length(pars1)
	
	pars1Mat            <- matrix(pars1, ncol = N + 1, nrow = N)
	pars2Mat            <- matrix(pars2, ncol = N + 1, nrow = N)
	
	RM_1_2_up            <- matrix(ncol = N + 1, nrow = N)
	RM_1_2_down          <- RM_1_2_up
	RM_2_1_up            <- RM_1_2_up
	RM_2_1_down          <- RM_1_2_up
	
	# based on 1-> 2 upward
	r1ind                     <- lower.tri(pars1Mat, TRUE)
	r2ind                     <- upper.tri(pars1Mat)
	
	RM_1_2_up[r1ind]          <- pars1Mat[r1ind]
	RM_1_2_up[r2ind]          <- pars2Mat[r2ind]
	
	RM_1_2_down[r1ind[N:1, ]] <- pars1Mat[r1ind[N:1, ]]
	RM_1_2_down[r2ind[N:1, ]] <- pars2Mat[r2ind[N:1, ]]
	
	RM_2_1_up[r1ind]          <- pars2Mat[r1ind]
	RM_2_1_up[r2ind]          <- pars1Mat[r2ind]
	
	RM_2_1_down[r1ind[N:1, ]] <- pars2Mat[r1ind[N:1, ]]
	RM_2_1_down[r2ind[N:1, ]] <- pars1Mat[r2ind[N:1, ]]
	
	dec                       <- matrix(NA, nrow = N, ncol = 4)
	if (up){
		dec[, 1]              <- diff(apply(RM_1_2_up, 2, func, ...))
	}
	if (down){
		dec[, 2]              <- rev(diff(apply(RM_1_2_down, 2, func, ...)))
	}
	
	if (symmetrical){
		if (up){
			dec[, 3]          <- -diff(apply(RM_2_1_up, 2, func, ...))
		}
		if (down){
			dec[, 4]          <- rev(-diff(apply(RM_2_1_down, 2, func, ...)))
		}
	}
	
	
	dec_avg               <- rowMeans(dec, na.rm = TRUE)
	names(dec_avg)        <- names(pars1)
	dec_avg
}

#' @title an abridged lifetable based on M(x)
#' @description Implements the abridged lifetable formulas given in the supplementary material to Andreev et. al. (2012). An entire lifetable is calculated, but only life expectancy at birth is returned.
#' @details Chiang's a(x) is assumed in the following way: \eqn{a(0) = 0.07 + 1.7 * M(0)}, \eqn{a(1) = 1.6}, \eqn{a(\omega) = \frac{1}{M(\omega)}}, and all others are assumed at mid interval. The last age is assumed open. Everything else is pretty standard.
#' @param Mx numeric vector of abridged mortality rates.
#' @param Age integer, abridged age lower bounds. 
#' @param radix numeric. Can be anything positive.
#' @references
#' \insertRef{andreev2002algorithm}{DemoDecomp}
#' \insertRef{andreev2012excel}{DemoDecomp}
#' @export
#' @return numeric life expectancy at birth
LTabr <- function(Mx, Age = c(0, 1, cumsum(rep(5, length(Mx) - 2))), radix = 1e5){
	# based on lifetable formulas in Spreadsheet:
	# Andreev & Shkolnikov (2012) An Excel spreadsheet for the 
	# decomposition of a difference between two values of an 
	# aggregate demographic measure by stepwise replacement 
	# running from young to old ages 
	# MPIDR technical report 2012-002
	# attached file tr-2012-002-files.zip
	# containing spreadsheet
	# "Decomposition_replacement_from_young_to_old_ages(1).xls
	
	# TR: this is not HMD exactly, since it's an abridged lifetable. a(x) values
	# will all be different from HMD. Other potential differences are of lesser consequence
	# i.e. closeout at age 85, etc.
	N     <- length(Mx)
	w     <- c(diff(Age),5)
	
	ax    <- c(0.07 + 1.7 * Mx[1],.4,rep(.5,N - 3), 1/Mx[N])
	Nax   <- w * ax
	qx    <- (w * Mx) / (1 + w * (1 - ax) * Mx)
	qx[N] <- 1
	px    <- 1 - qx
	lx    <- c(radix, radix * (cumprod(px[-N])))
	dx    <- -diff(c(lx, 0))
	Lx    <- lx[-1] * w[-N] + dx[-N] * Nax[-N]
	Lx[N] <- ax[N] * lx[N]
	Tx    <- rev(cumsum(rev(Lx)))
	ex    <- Tx / lx
	ex[1]
}

#' @title get life expectancy at birth from an (abridged)age-cause matrix
#' @description Given a matrix with abridged ages in rows and causes of death in columns, then calculate life expectancy at birth using \code{LTabr()}.
#' @details This assumes that the marginal row sums give all-cause mortality rates. Give an other category if you need to top-up to all-cause mortality. Do not include all-cause mortality itself!
#' @param Mxc numeric matrix
#' @return numeric life expectancy at birth
#' @export
Mxc2e0abr <- function(Mxc){
	Mx <- rowSums(Mxc)
	LTabr(Mx)
}
#' @title get life expectancy at birth from the vec of an age-cause matrix
#' @description Given a vector with abridged ages stacked within causes of death, assign its dimensions, take the age marginal sums using \code{Mxc2e0abr}, then calculate life expectancy at birth using \code{LTabr()}.
#' @details This assumes that the marginal row sums give all-cause mortality rates. Give an other category if you need to top-up to all-cause mortality. Do not include all-cause mortality itself! \code{length(Mxcvec)} must equal \code{prod(dim(Mxc))}. This function is meant to be fed to a generic decomposition function, such as \code{stepwise_replacement()}, or \code{DecompContinuousOrig()}.
#' @param Mxcvec numeric vector, \code{c(Mxc)}.
#' @param dims integer vector of length two, \code{c(nrow(Mxc),ncol(Mxc))}.
#' @param trans do we need to transpose in order to arrive back to an age-cause matrix?
#' @return numeric life expectancy at birth
#' @export
Mxc2e0abrvec <- function(Mxcvec, dims, trans = FALSE){
	dim(Mxcvec) <- dims
	if (trans){
		Mxcvec <- t(Mxcvec)
	}
	Mxc2e0abr(Mxcvec)
}
