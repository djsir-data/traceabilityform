tab_sol_provider <- function(...) tabPanel(
  title = 'Provider costs',
  value = 'sol_provider',
  h2('Solution provider costs'),
  p(
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
  ),
  # Basic upfront costs
  h3("Upfront costs"),
  input_row(
    inputId = "sol_upfront_tot",
    label = "Total upfront provider costs",
    content_type = "basic",
    input_type = "dollar",
    uncertainty_label = "Provider costs"
    ),
  input_row_set(
    inputIds = c(
      "installation",
      "microsite_app",
      "dashboard",
      "labelling",
      "site_visits",
      "training",
      "trace_standards",
      "loggers",
      "isobio_test",
      "sol_equipment",
      "customisation",
      "sol_upfront_other"
    ),
    labels = c(
      'Installation / Set Up costs',
      'Microsite / Mobile Web App costs',
      'Dashboard  costs',
      'Labelling costs',
      'Site Visits costs',
      'Training costs',
      'Traceability Standards costs',
      'Loggers costs',
      'Isotope Or Biochemical Testing costs',
      'Equipment costs',
      'Customisation costs',
      'Other upfront costs'
    ),
    input_type = "dollar",
    content_type = "advanced"
  ),
  h3("Ongoing costs"),
  input_row(
    inputId = "sol_ongoing_tot",
    label = "Total ongoing provider costs",
    content_type = "basic",
    input_type = "dollar",
    uncertainty_label = "Provider costs"
  ),
  input_row_set(
    inputIds = c(
      'subscription',
      'service',
      'upgrades',
      'consumables',
      'sol_ongoing_other'
    ),
    labels = c(
      'Subscription costs',
      'Service costs',
      'Upgrades costs',
      'Consumables costs',
      'Other ongoing costs'
    ),
    input_type = "dollar",
    content_type = "advanced"
  )


)
