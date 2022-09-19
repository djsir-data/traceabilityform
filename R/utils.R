
# Discounting with vector returning variant
discount <- function(x, discount_rate, n_years){
  x * (1 - ( 1 + discount_rate) ^ (-n_years)) / discount_rate
}
discount_v <- function(x, discount_rate, n_years){
  x * (1 - ( 1 + discount_rate) ^ (-1:(-n_years))) / discount_rate
}

# rbeta with min max
rbeta_min_max <- function(n, shape1, shape2, min, max){
  (max - min) * rbeta(n, shape1, shape2) + min
}
