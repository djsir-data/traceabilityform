tab_bus_costs <- function(...) tabPanel(
  title = 'Business costs',
  value = 'bus_costs',
  h2('Business costs'),
  p(
    "This page accounts for costs incurred by your business (excluding those",
    "imposed by the service provider) in order to integrate a new",
    "traceability system. All inputs are dollar values. "
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
  h3("Ongoing costs (per year)"),
  input_row(
    inputId = "bus_ongoing_tot",
    label = "Total ongoing business costs",
    content_type = "always",
    input_type = "dollar",
    uncertainty_label = "Ongoing costs"
  )
)
