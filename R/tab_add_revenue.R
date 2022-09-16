tab_add_revenue <- function(...) tabPanel(
  title = 'New revenue',
  value = 'add_revenue',
  h2('New revenue sources'),
  p(
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
  ),

  # Basic content (totals)
  div(
    class = c("row", "basicContent"),
    div(
      class = "col-md-4",
      percentInput(
        inputId = "add_rev_tot",
        label = "Increased revenue from traceability",
        width = "100%"
      )
    ),
    div(
      class = c("col-md-4", "uncertaintyContent"),
      percentRangeInput(
        inputId = "add_rev_tot-range",
        label = "Increased revenue range",
        width = "100%"
      )
    ),
    div(
      class = c("col-md-4", "uncertaintyContent"),
      radioGroupButtons(
        inputId = "add_rev_tot-uncertainty",
        label = "Increased  revenue certainty",
        choices = c("High", "Medium", "Low"),
        status = "primary",
        justified  = TRUE
      )
    )
  ),

  # Advanced content
  input_row(
    inputId = "new_markets",
    label = "Access to new markets",
    input_type = "percent",
    content_type = "advanced"
  ),

  input_row(
    inputId = "brand_value",
    label = "Brand value",
    input_type = "percent",
    content_type = "advanced"
  ),

  input_row(
    inputId = "market_share",
    label = "Market share",
    input_type = "percent",
    content_type = "advanced"
  ),

  input_row(
    inputId = "new_product",
    label = "New Product Development",
    input_type = "percent",
    content_type = "advanced"
  ),

  input_row(
    inputId = "pricing",
    label = "Pricing & purchasing",
    input_type = "percent",
    content_type = "advanced"
  ),

  input_row(
    inputId = "product_ranging",
    label = "Product Ranging",
    input_type = "percent",
    content_type = "advanced"
  ),

  input_row(
    inputId = "repeat_purchasing",
    label = "Repeat purchasing",
    input_type = "percent",
    content_type = "advanced"
  ),

  input_row(
    inputId = "add_rev_other",
    label = "other",
    input_type = "percent",
    content_type = "advanced"
  ),

  input_row(
    inputId = "add_rev_cost",
    label = "Costs from revenue increase",
    input_type = "percent",
    content_type = "advanced"
  )

)
