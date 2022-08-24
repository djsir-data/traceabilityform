cache_content <- function(...){
  # Get 10y gov bond rate
  gov_bond <- readrba::read_rba_seriesid("FCMYGBAG10D")
  gov_bond <- gov_bond$value[gov_bond$date == max(gov_bond$date)]
  saveRDS(gov_bond, "app-cache/gov_bond.rds")
}

