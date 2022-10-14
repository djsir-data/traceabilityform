tab_sol_provider <- function(...) tabPanel(
  title = 'Provider costs',
  value = 'sol_provider',
  h2('Solution provider costs'),
  p(
  "How much will it cost to upgrade or install a new traceability system in
  your business?"
  ),
  p(
    "TThis section accounts for costs charged by the traceability service
    provider. All inputs are dollar values."
  ),
  br(),
  tags$i(
    "Tip:", br(),
    "Use the ‘additional detail’ and ‘uncertainty’ switches to calculate costs
    you may not have considered."
  ),
  br(),
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
  h3("Ongoing costs (per year)"),
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
