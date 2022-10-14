tab_red_costs <- function(...) tabPanel(
  title = 'Cost savings',
  value = 'red_costs',
  h2('Cost savings'),
  p(
  "Can traceability reduce various business costs by automating processes and
   generating reports?"
  ),
  p(
    "The following inputs represent how much traceability can reduce various
    business costs such as regulatory compliance or inventory management."
  ),
  p(
    "All inputs are presented as",
    tags$strong(
      class = "text-decoration-underline",
      "percentage decrease in total cost."
    ),
    "For example:",
    tags$figure(
      class = "text-center",
      tags$blockquote(
        class = "blockquote",
        HTML("0.2% decrease &times; $100,000 total cost = $200 cost reduction")
      )
    ),
    "Please note: this does not include the reduced costs of crisis management
    as they’re estimated in the next section."
  ),
  br(),
  tags$i(
    "Tip:",
    br(),
    "Use the ‘additional detail’ and ‘uncertainty’ switches to calculate your
    business’ potential cost savings if using an effective system."
  ),
  br(),
  br(),

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
      'Auditing & compliance',
      'Automation',
      'Brand protection',
      'Data management',
      'Inventory management',
      'Marketing',
      'Packaging',
      'Quality preservation',
      'Rejections',
      'Supply chain / logistics',
      'Insurance',
      'Other'
    ),
    input_type = "percent",
    content_type = "advanced"
  )

)
