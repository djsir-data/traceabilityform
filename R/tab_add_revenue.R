tab_add_revenue <- function(...) tabPanel(
  title = 'New revenue',
  value = 'add_revenue',
  h2('New revenue sources'),
  p(
    "The following inputs gauge how traceability may help your business increase",
    "revenue. All inputs are presented as ",
    tags$strong(
      class = "text-decoration-underline",
      "percentage increases in total revenue."
      ),
    "For example:",
    tags$figure(
      class = "text-center",
      tags$blockquote(
        class = "blockquote",
        HTML("0.5% increase &times; $100,000 total revenue = $500 revenue increase")
      )
    ),
    "If you're unsure of how traceability may help your business increase revenue, use",
    "the additional detail switch to itemise various ways traceability may",
    "benefit your business. If you are uncertain in your estimates of revenue",
    "increase, use the uncertainty toggle to estimate a range of outcomes."
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
    label = "New product development",
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
    label = "Product ranging",
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
    label = "Other",
    input_type = "percent",
    content_type = "advanced"
  ),

  tags$strong(
    "What costs (excluding traceability costs) would be required to achieve this growth?"
  ),
  input_row(
    inputId = "add_rev_cost",
    label = "Costs from revenue increase",
    input_type = "percent"
  )

)
