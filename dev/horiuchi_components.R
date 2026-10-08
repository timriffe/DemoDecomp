
library(LEdecomp)
library(tidyverse)

data = 
US_data_CoD |> 
  filter(year == 2010) |> 
  select(-cause) |> 
  pivot_wider(names_from = sex, values_from = mxc) |> 
  mutate(age10 = age - age %% 10,
         component = paste(cause_id, age10))

func <- function(mxc, data){
  mx <-
    data |> 
    mutate(newmxc = mxc) |> 
    summarize(mx = sum(newmxc), .by = c(age)) |> 
    pull(mx)
  
  sum(c(1,exp(-cumsum(mx)))) - .5
}

pars1 <- data$Male
pars2 <- data$Female
func(pars2, data)
cc1 <- horiuchi2(func,pars1,pars2,data=data)

cc_standard <- data |> 
  bind_cols(tibble(cc = cc1))
cc10 <- horiuchi2(func,
                  pars1,
                  pars2,
                  components = data$component, 
                  data=data)
age10_test <-
  data |> 
  select(age10, cause_id) |> 
  distinct() |> 
  bind_cols(tibble(cc = cc10)) |> 
  mutate(variant = "components")
age10_aggregated <-
  cc_standard |> 
  summarize(cc = sum(cc), .by = c(age10, cause_id)) |> 
  mutate(variant = "aggregated")

bind_rows(age10_test,age10_aggregated) |> 
  filter(cause_id == "A00-B99") |> 
  ggplot(aes(x = age10,y=cc,color=variant, linetype=variant))+
  geom_step() +
  labs(title = "Hell yes, we have a match!")

# now test on full age
cc_full <- horiuchi2(func,
                    pars1,
                    pars2,
                    components = data$cause_id, 
                    data=data)
cause_components <- 
tibble(cc = cc_full,
       cause_id = names(cc_full)) |> 
  mutate(variant = "components")

cc_standard |> 
  summarize(cc = sum(cc),
            .by = cause_id) |> 
  mutate(variant = "aggregated") |> 
  bind_rows(cause_components) |> 
  ggplot(aes(x = cause_id, y = cc, fill = variant))+
  geom_col(position = "dodge")+
  labs(title = "Hell yes again, we have a match!")

horiuchi2 <- function (func, pars1, pars2, components = 1:length(pars1), N=20, ...) {
  d       <- pars2 - pars1
  ii      <- unique(components)
  n       <- length(ii)
  nn      <- length(components)
  delta   <- d/N
  grad    <- matrix(rep(0.5:(N - 0.5)/N, nn), byrow = TRUE, ncol = N)
  x       <- pars1 + d * grad
  cc      <- matrix(0, nrow = n, ncol = N)
  rownames(cc) <- ii
  zeros   <- rep(0,nn)

  for (j in 1:N) {
    for (i in ii) {
      ind      <- components == i
      deltai <- zeros 
      deltai[ind] <- delta[ind]
      cc[i, j] <- func((x[, j] + deltai), ...) - 
                  func((x[, j] - deltai), ...)
    }
  }
  out <- rowSums(cc)
  names(out) <- ii
  out
}









