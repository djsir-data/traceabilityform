# inputs have four variants:
# Always - always required; always visible
# Basic - visible when additional detail is off
# Advanced  - visible when additional detail is on
# uncertainty - visible when uncertainty is on
# Input validation will only apply to the visIble content


input_list <- list(
  start = list(
    always = c("discount_rate", "eval_period"),
    basic = c(),
    advanced = c(),
    uncertainty = c()
    ),
  financials = list(
    always = c("cur_rev", "cur_costs"),
    basic = c(),
    advanced = c(),
    uncertainty = c("cur_rev_uncertainty", "cur_costs_uncertainty")
  ),
  add_revenue = list(
    always = c(),
    basic = c(),
    advanced = c(),
    uncertainty = c()
  ),
  red_costs = list(
    always = c(),
    basic = c(),
    advanced = c(),
    uncertainty = c()
  ),
  red_crisis = list(
    always = c(),
    basic = c(),
    advanced = c(),
    uncertainty = c()
  ),
  sol_provider = list(
    always = c(),
    basic = c(),
    advanced = c(),
    uncertainty = c()
  ),
  bus_costs = list(
    always = c(),
    basic = c(),
    advanced = c(),
    uncertainty = c()
  ),
  sup_chain = list(
    always = c(),
    basic = c(),
    advanced = c(),
    uncertainty = c()
  ),
  results = list(
    always = c(),
    basic = c(),
    advanced = c(),
    uncertainty = c()
  )
)

# Checks if relevant inputs are valid, if not marks them and halts
# current reactive
validate_inputs <- function(input, tab = NULL){

  # Convert input to list
  input <- reactiveValuesToList(input)

  # List content types to evaluate based on switches
  eval_content <- c("always", "basic", "advanced", "uncertainty")[
    c(
      TRUE,
      !input$switch_advanced,
      input$switch_advanced,
      input$switch_uncertainty
      )
  ]

  # Generate vector of input names to evaluate
  tab <- if(is.null(tab)){input$tabset}else{tab}
  input_list <- input_list[[tab]][eval_content]
  input_list <- unlist(input_list)

  # Check inputs are valid (have a truthy value)
  is_valid <- sapply(input[input_list], isTruthy)

  # Pull out any invalid inputs
  invalid_inputs <- input_list[!is_valid]

  # Add error class to invalid inputs
  lapply(invalid_inputs, addClass, class = "is-invalid")

  # Return whether all inputs are valid
  return(all(is_valid))

}
