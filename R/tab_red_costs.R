tab_red_costs <- function(...) tabPanel(
  title = 'Cost savings',
  value = 'red_costs',
  h2('Cost savings'),
  p(
    "The following inputs represent how much traceability can reduce ",
    "various business costs such as regulatory compliance or inventory",
    "management. All inputs are presented as percent of total cost.",
    "Please note that this does not include the reduced costs of crisis",
    "management which are estimated on the next page"
  ),

  input_row(
    inputId = "red_costs_total",
    label = "Cost savings",
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
      'marketing_savings',
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
