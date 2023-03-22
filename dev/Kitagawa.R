
# Author: tim
###############################################################################

# I never really thought of the Kitagawa method as generalizable until now. Here goes:

#kitagawa <- function(func, pars1, pars2){
#	
#}
## hmm oh ya this one assumes we have equal-length vectors of arguments, 
# in the first instance two vectors of args, but Das Gupta generalized up to 5 or 6 vectors.
# Would be nice to generalize to N vectors. Still the method would only be useful for functions
# only consisting in equal-length vectors of arguments, no other solitary parameters. 

# so in a sense, func() would want to take a single matrix as its argument rather than a vector.
# that way the number of parameters is at least established in a general way.
# 
#  dasgupta <- function(func, pars1_mat, pars2_mat){
#    # here
#    P <- ncol(pars1_mat)
#    S <- ceiling(P / 2)
#    r <- P - 1
#    
#    denoms <- P * choose(P-1, 1:r)
#  }
# 
# kitagawa_cfr <- function(c1, r1, c2, r2){
#   
#   # Calculate age-distribution of cases
#   c1  <- c1 / sum(c1)
#   c2  <- c2 / sum(c2)
#   
#   # Total difference
#   Tot <- cfr(c1, r1) - cfr(c2, r2)
#   
#   # Age component
#   Aa  <- sum((c1 - c2) * (r1 + r2) / 2)
#   
#   # Case fatality component
#   Bb  <- sum((r1 - r2) * (c1 + c2) / 2)
#   
#   # Output
#   list(Diff = Tot, 
#        AgeComp = Aa,
#        RateComp = Bb, 
#        CFR1 = weighted.mean(r1,c1), 
#        CFR2 = weighted.mean(r2,c2))
# }
# 
# 
# #
# 
# 
# age_diff <- 0.5*(
#           # ---------------------------------------
#           # same IT ascfr, switch case structure
#   
#                    cfr(cases=cases_IT_a,           
#                      cfr_age=cfr_age_IT_a) -
#                    
#                    cfr(cases=cases_DE_a,
#                        cfr_age=cfr_age_IT_a) +
#           # ---------------------------------------
#           # same DE ascfr, switch case structure
#                    cfr(cases=cases_IT_a,
#                        cfr_age=cfr_age_DE_a) -
#                    
#                    cfr(cases=cases_DE_a,
#                        cfr_age=cfr_age_DE_a))
# 
# # Mortalityy difference
# mort_diff <- 0.5*(
#   # ---------------------------------------
#   # same IT case structure, switch ascfr
#                     cfr(cases=cases_IT_a,
#                       cfr_age=cfr_age_IT_a) -
#                     
#                     cfr(cases=cases_IT_a,
#                         cfr_age=cfr_age_DE_a) +
#   # ---------------------------------------
#   # same DE case structure, switch ascfr
#                     cfr(cases=cases_DE_a,
#                         cfr_age=cfr_age_IT_a) -
#                     
#                     cfr(cases=cases_DE_a,
#                         cfr_age=cfr_age_DE_a))
# set.seed(1)
# px    <- runif(10)
# cx    <- runif(10)
# dx    <- runif(10)
# 
# p_structure_x <- px / sum(px)
# ix <- cx / px
# I <- sum(ix)
# ix_structure <- ix / sum(ix)
# ascfr <- dx / cx
# fatality_structure <- ascfr / sum(ascfr)
# FF    <- sum(ascfr)
# 
# pars <- c(I = I, FF = FF, p_structure_x, ix_structure, fatality_structure)
# my_mortality_model <- function(vec){
#   # pick out the two non-age variables (scalars)
#   I        <- vec["I"]
#   FF       <- vec["FF"]
#   mat      <- vec[-c(1:2)]
#   dim(mat) <- c(length(mat) / 3, 3)
#   
#   mat[,2] <- mat[,2] * I   # scale up incidence
#   mat[,3] <- mat[,3] * FF  # scale up mortality
#   
#   # synthetic result
#   sum(mat[,1] * mat[,2] * mat[,3])
# }







