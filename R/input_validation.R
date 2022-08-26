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
    basic = c("add_rev_tot"),
    advanced = c(
      "new_markets",
      "brand_value",
      "market_share",
      "new_product",
      "pricing",
      "product_ranging",
      "repeat_purchasing",
      "add_rev_other",
      "add_rev_cost"
      ),
    uncertainty = c(),
    basic_uncertainty = c("add_rev_tot_range", "add_rev_tot_uncertainty"),
    advanced_uncertainty = c(
      "new_markets_range",
      "brand_value_range",
      "market_share_range",
      "new_product_range",
      "pricing_range",
      "product_ranging_range",
      "repeat_purchasing_range",
      "add_rev_other_range",
      "add_rev_cost_range",
      "new_markets_uncertainty",
      "brand_value_uncertainty",
      "market_share_uncertainty",
      "new_product_uncertainty",
      "pricing_uncertainty",
      "product_ranging_uncertainty",
      "repeat_purchasing_uncertainty",
      "add_rev_other_uncertainty",
      "add_rev_cost_uncertainty"
    )
  ),
  red_costs = list(
    always = c(),
    basic = c("red_costs_total"),
    advanced = c(
      'accreditation',
      'audit_comp',
      'auto',
      'brand_prot',
      'data',
      'inventory',
      'marketing_savings',
      'packaging',
      'quality',
      'rejections',
      'supplychain',
      'insurance',
      'red_costs_other'
    ),
    uncertainty = c(),
    basic_uncertainty = c(
      "red_costs_total_range",
      "red_costs_total_uncertainty"
      ),
    advanced_uncertainty = c(
      "accreditation_range",
      "audit_comp_range",
      "auto_range",
      "brand_prot_range",
      "data_range",
      "inventory_range",
      "marketing_savings_range",
      "packaging_range",
      "quality_range",
      "rejections_range",
      "supplychain_range",
      "insurance_range",
      "red_costs_other_range",
      "accreditation_uncertainty",
      "audit_comp_uncertainty",
      "auto_uncertainty",
      "brand_prot_uncertainty",
      "data_uncertainty",
      "inventory_uncertainty",
      "marketing_savings_uncertainty",
      "packaging_uncertainty",
      "quality_uncertainty",
      "rejections_uncertainty",
      "supplychain_uncertainty",
      "insurance_uncertainty",
      "red_costs_other_uncertainty"
    )
  ),
  red_crisis = list(
    always = c(
      "claims_dollar_old",
      "claims_time_old",
      "claims_dollar_new",
      "claims_time_new",
      "recalls_dollar_old",
      "recalls_time_old",
      "recalls_dollar_new",
      "recalls_time_new",
      "bio_dollar_old",
      "bio_time_old",
      "bio_dollar_new",
      "bio_time_new",
      "weather_dollar_old",
      "weather_time_old",
      "weather_dollar_new",
      "weather_time_new"
    ),
    basic = c(),
    advanced = c(),
    uncertainty = c(
      "claims_dollar_old_range",
      "claims_time_old_range",
      "claims_dollar_new_range",
      "claims_time_new_range",
      "recalls_dollar_old_range",
      "recalls_time_old_range",
      "recalls_dollar_new_range",
      "recalls_time_new_range",
      "bio_dollar_old_range",
      "bio_time_old_range",
      "bio_dollar_new_range",
      "bio_time_new_range",
      "weather_dollar_old_range",
      "weather_time_old_range",
      "weather_dollar_new_range",
      "weather_time_new_range",
      "claims_dollar_old_uncertainty",
      "claims_time_old_uncertainty",
      "claims_dollar_new_uncertainty",
      "claims_time_new_uncertainty",
      "recalls_dollar_old_uncertainty",
      "recalls_time_old_uncertainty",
      "recalls_dollar_new_uncertainty",
      "recalls_time_new_uncertainty",
      "bio_dollar_old_uncertainty",
      "bio_time_old_uncertainty",
      "bio_dollar_new_uncertainty",
      "bio_time_new_uncertainty",
      "weather_dollar_old_uncertainty",
      "weather_time_old_uncertainty",
      "weather_dollar_new_uncertainty",
      "weather_time_new_uncertainty"
    ),
    basic_uncertainty = c(),
    advanced_uncertainty = c()
  ),
  sol_provider = list(
    always = c(),
    basic = c("sol_upfront_tot", "sol_ongoing_tot"),
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
