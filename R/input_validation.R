# inputs have six variants:
# Always - always required; always visible
# Basic - visible when additional detail is off
# Advanced  - visible when additional detail is on
# uncertainty - visible when uncertainty is on
# Basic uncertainty
# Advanced uncertainty
# Input validation will only apply to the visIble content


input_list <- list(
  start = list(
    always = c("discount_rate", "eval_period"),
    basic = c(),
    advanced = c(),
    uncertainty = c(),
    basic_uncertainty = c(),
    advanced_uncertainty = c()
    ),
  financials = list(
    always = c("cur_rev", "cur_costs"),
    basic = c(),
    advanced = c(),
    uncertainty = c(
      "cur_rev_range",
      "cur_rev_uncertainty",
      "cur_costs_range",
      "cur_costs_uncertainty"
      ),
    basic_uncertainty = c(),
    advanced_uncertainty = c()
  ),
  add_revenue = list(
    always = c(),
    basic = c(),
    advanced = c(),
    uncertainty = c(),
    basic_uncertainty = c(),
    advanced_uncertainty = c()
  ),
  red_costs = list(
    always = c(),
    basic = c(),
    advanced = c(),
    uncertainty = c(),
    basic_uncertainty = c(),
    advanced_uncertainty = c()
  ),
  red_crisis = list(
    always = c(),
    basic = c(),
    advanced = c(),
    uncertainty = c(),
    basic_uncertainty = c(),
    advanced_uncertainty = c()
  ),
  sol_provider = list(
    always = c(),
    basic = c(),
    advanced = c(),
    uncertainty = c(),
    basic_uncertainty = c(),
    advanced_uncertainty = c()
  ),
  bus_costs = list(
    always = c(),
    basic = c(),
    advanced = c(),
    uncertainty = c(),
    basic_uncertainty = c(),
    advanced_uncertainty = c()
  ),
  sup_chain = list(
    always = c(),
    basic = c(),
    advanced = c(),
    uncertainty = c(),
    basic_uncertainty = c(),
    advanced_uncertainty = c()
  ),
  results = list(
    always = c(),
    basic = c(),
    advanced = c(),
    uncertainty = c(),
    basic_uncertainty = c(),
    advanced_uncertainty = c()
  )
)

# Checks if relevant inputs are valid, if not marks them
validate_inputs <- function(input, tab = NULL){

  # Convert input to list
  input <- reactiveValuesToList(input)

  # List content types to evaluate based on switches
  eval_content <- c(
    "always"               = TRUE,
    "basic"                = !input$switch_advanced,
    "advanced"             = input$switch_advanced,
    "uncertainty"          = input$switch_uncertainty,
    "basic_uncertainty"    = !input$switch_advanced & input$switch_uncertainty,
    "advanced_uncertainty" = input$switch_advanced & input$switch_uncertainty
    )

  eval_content <- names(eval_content)[eval_content]

  # Generate vector of input names to evaluate
  tab <- if(is.null(tab)){input$tabset}else{tab}
  input_list <- input_list[[tab]][eval_content]
  input_list <- unlist(input_list)

  # Check inputs are valid (have a truthy value)
  # Uses double sapply as some inputs are a range (multiple values to eval)
  is_range <- sapply(input[input_list], function(x) length(x) > 1)
  is_valid <- ifelse(
    is_range,
    sapply(input[input_list], function(x) all(sapply(x, isTruthy))),
    sapply(input[input_list], isTruthy)
  )

  # Error handling
  if(!all(is_valid)){

    # Pull out any invalid inputs
    invalid_inputs <- input_list[!is_valid]

    # Add error class to invalid single inputs
    lapply(invalid_inputs,  function(x) addClass(
      class = "is-invalid",
      selector = paste0("input#", x)
    ))

    # Add error class to invalid range inputs
    lapply(invalid_inputs, function(x) addClass(
      class = "is-invalid",
      selector = paste0("#", x, ">.input-numeric-range>input")
    ))

  }

  # Return whether all inputs are valid
  return(all(is_valid))

}
