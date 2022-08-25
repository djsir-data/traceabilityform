tab_red_costs <- function(...) tabPanel(
  title = 'Cost savings',
  value = 'red_costs',
  h2('Cost savings'),
  p(
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
  ),

  input_row(
    inputId = "red_costs_total",
    label = "Costs of traceability",
    input_type = "percent",
    content_type = "basic"
  ),

  input_row_set(
    inputIds = c(
      'accreditation',
      'audit_comp',
      'auto',
      'brand_prot',
      'data',
      'inventory',
      'marketing',
      'packaging',
      'quality',
      'rejections',
      'supplychain',
      'insurance',
      'red_costs_other'
    ),
    labels = c(
      'Accreditation',
      'Auditing & Compliance',
      'Automation',
      'Brand Protection',
      'Data Management',
      'Inventory Management',
      'Marketing',
      'Packaging',
      'Quality Preservation',
      'Rejections',
      'Supply Chain / Logistics',
      'Insurance',
      'Other'
    ),
    input_type = "percent",
    content_type = "advanced"
  )

)
