tab_bus_costs <- function(...) tabPanel(
  title = 'Business costs',
  value = 'bus_costs',
  h2('Business costs'),
  p(
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
  ),

  # Upfront costs
  h3("Upfront costs"),
  input_row(
    inputId = "bus_upfront_tot",
    label = "Total upfront costs",
    content_type = "basic",
    input_type = "dollar",
    uncertainty_label = "upfront costs"
  ),
  input_row_set(
    inputIds = c(
      'printers',
      'labellers',
      'scanners',
      'equipment',
      'bus_integration',
      'bus_software',
      'labour',
      'bus_training',
      'marketing_costs',
      'bus_changeover',
      'bus_upfront_other'
    ),
    labels = c(
      'Printers',
      'Labellers',
      'Scanners',
      'Equipment',
      'Integration',
      'Software',
      'Labour',
      'Training',
      'Marketing',
      'Changeover',
      'Other'
    ),
    input_type = "dollar",
    content_type = "advanced"
  ),
  h3("Ongoing costs"),
  input_row(
    inputId = "bus_ongoing_tot",
    label = "Total ongoing business costs",
    content_type = "always",
    input_type = "dollar",
    uncertainty_label = "Ongoing costs"
  )
)
