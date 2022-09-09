prefill_values <- function(input, output, session){

  # Update values
  updateNumericInput(session = session, "cur_rev", value = 1000)
  updateNumericInput(session = session, "cur_costs", value = 400)
  updateNumericInput(session = session, "add_rev_tot", value = 3)
  updateNumericInput(session = session, "red_costs_total", value = 3)
  updateNumericInput(session = session, "claims_dollar_old", value = 100)
  updateNumericInput(session = session, "claims_time_old", value = 3)
  updateNumericInput(session = session, "claims_dollar_new", value = 100)
  updateNumericInput(session = session, "claims_time_new", value = 1)
  updateNumericInput(session = session, "recalls_dollar_old", value = 100)
  updateNumericInput(session = session, "recalls_time_old", value = 1)
  updateNumericInput(session = session, "recalls_dollar_new", value = 100)
  updateNumericInput(session = session, "recalls_time_new", value = 1)
  updateNumericInput(session = session, "bio_dollar_old", value = 100)
  updateNumericInput(session = session, "bio_time_old", value = 1)
  updateNumericInput(session = session, "bio_dollar_new", value = 100)
  updateNumericInput(session = session, "bio_time_new", value = 1)
  updateNumericInput(session = session, "weather_dollar_old", value = 100)
  updateNumericInput(session = session, "weather_time_old", value = 1)
  updateNumericInput(session = session, "weather_dollar_new", value = 100)
  updateNumericInput(session = session, "weather_time_new", value = 0)
  updateNumericInput(session = session, "sol_upfront_tot", value = 100)
  updateNumericInput(session = session, "sol_ongoing_tot", value = 1)
  updateNumericInput(session = session, "bus_upfront_tot", value = 1)
  updateNumericInput(session = session, "bus_ongoing_tot", value = 1)
  updateNumericInput(session = session, "sup_upfront_tot", value = 1)
  updateNumericInput(session = session, "sup_ongoing_tot", value = 1)

  # Run through tabs to generate input_set
  lapply(
    c(
      "financials",
      "add_revenue",
      "red_costs",
      "red_crisis",
      "sol_provider",
      "bus_costs",
      "sup_chain",
      "results"
    ),
    function(x) updateNavbarPage(session = session, "tabset", x)
  )


}
