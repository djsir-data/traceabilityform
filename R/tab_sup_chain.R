tab_sup_chain <- function(...) tabPanel(
  title = 'Supply chain',
  value = 'sup_chain',
  h2('Supply chain costs'),
  p(
    "Have you considered all costs associated with upgrading or installing a
    new traceability system?"
    ),
  p(
    "This section accounts for costs incurred by your business (excluding those
    imposed by the service provider) to integrate a new traceability system.
    All inputs are dollar values."
  ),
  br(),
  tags$i(
    "Tip:", br(),
    "Use the ‘additional detail’ and ‘uncertainty’ switches to calculate costs
    you may not have considered."
  ),
  br(),
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
