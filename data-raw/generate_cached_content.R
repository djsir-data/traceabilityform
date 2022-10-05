

# Get 10y gov bond rate
# gov_bond <- readrba::read_rba_seriesid("FCMYGBAG10D")
# gov_bond <- gov_bond$value[gov_bond$date == max(gov_bond$date)]
# saveRDS(gov_bond, "app-cache/gov_bond.rds")

# Input metadata
inmeta <- data.table::fread("data-raw/input_metadata.csv")
saveRDS(inmeta, "app-cache/input_metadata.rds")
