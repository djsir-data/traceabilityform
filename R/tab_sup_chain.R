tab_sup_chain <- function(...) tabPanel(
  title = 'Supply chain',
  value = 'sup_chain',
  h2('Supply chain costs'),
  p(
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
  ),
  h3("Upfront costs"),
  input_row(
    inputId = "sup_upfront_tot",
    label = "Total upfront costs",
    content_type = "basic",
    input_type = "dollar",
    uncertainty_label = "upfront costs"
  ),
  input_row_set(
    inputIds = c(
      'mobile_app',
      'integration',
      'sup_software',
      'changeover',
      'sup_upfront_other'
    ),
    labels = c(
      'Mobile Web App / Scanners',
      'Integration',
      'Software',
      'Changeover',
      'Other'
    ),
    input_type = "dollar",
    content_type = "advanced"
  ),
  h3("Ongoing costs"),
  input_row(
    inputId = "sup_ongoing_tot",
    label = "Total ongoing costs",
    content_type = "always",
    input_type = "dollar",
    uncertainty_label = "Ongoing costs"
  )
)
