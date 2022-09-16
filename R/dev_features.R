prefill_values <- function(advanced = TRUE, input, output, session){

  # Activate switches
  updateMaterialSwitch(session, "switch_advanced", advanced)
  updateMaterialSwitch(session, "switch_uncertainty", advanced)

  # Update values based on dummy dataset
  dummy <- fread("data-raw/dummy_inputs.csv")

  mapply(
    updateNumericInput,
    session = list(session),
    inputId = dummy$variable,
    value = dummy$value
  )

  mapply(
    updateNumericRangeInput,
    session = list(session),
    inputId = paste0(dummy$variable, "-range"),
    value = t(dummy[, .(min, max)]) %>% as.data.frame() %>% as.list()
  )

  mapply(
    updateRadioGroupButtons,
    session = list(session),
    inputId = paste0(dummy$variable, "-uncertainty"),
    selected = dummy$uncertainty
  )

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
