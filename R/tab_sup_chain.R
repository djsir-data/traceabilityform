tab_sup_chain <- function(...) tabPanel(
  title = 'Supply chain',
  value = 'sup_chain',
  h2('Supply chain costs'),
  p(
    "This page accounts for any costs your business is expected to incur from",
    "integrating the new system with the systems of supply chain partners.",
    "All inputs are dollar value."
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
  h3("Ongoing costs (per year)"),
  input_row(
    inputId = "sup_ongoing_tot",
    label = "Total ongoing costs",
    content_type = "always",
    input_type = "dollar",
    uncertainty_label = "Ongoing costs"
  )
)
