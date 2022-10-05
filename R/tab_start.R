tab_start <- function(...) tabPanel(
  title = 'Start',
  value = 'start',

  # Title
  h2('Start'),

  # Intro text
  p(
    "The Agriculture Victoria traceability cost-benefit tool helps businesses",
    "estimate the financial returns to adopting traceability systems. This",
    "tool asks questions about where your business may benefit from",
    "traceability and costs you may incur and summarises to generate an",
    "expected return on investment. This web tool does not collect any",
    "financial information that you may enter. All information is deleted",
    "after your session ends. You will have the option to download your",
    "results and inputs in a PDF report on the results page."
  ),
  p(
    "Please note that this tool is for guidance purposes only. Any results",
    "presented are general in nature and the choice to adopt a traceability",
    "system should be considered alongside other information and expertise.",
    "No claim is made as to the accuracy or appropriateness of any content",
    "or results in this report at any time."
  ),
  br(),
  tags$strong(
    class = "text-decoration-underline",
    "Analysis options"
    ),
  p(
    "When using this tool, you can toggle additional detail or uncertianty",
    "using the switches in the top right corner. Where applicable, the",
    "additional detail switch will itemise a cost or benefit into more",
    "detailed componenets. This may be useful when trying to determine how a",
    "cost or benefit may impact your business. The uncertainty switch enables ",
    "calculation of proabalistic returns. By entering additional detail on",
    "how certain you are about the value of a cost or benefit, this tool will",
    "simulate 5000 plausable scenarios and report how many of them generated",
    "a positive return for your business."
  ),
  br(),
  tags$strong(
    class = "text-decoration-underline",
    "Evaluation period and discounting"
    ),
  p(
    "Before you begin, please enter how many years into the future you would",
    "like this analysis to evaluate and a prefered discount rate. A discount",
    "rate can be thought of as the rate your investment dollars would be",
    "earning if not used for traceability systems, for example, they could be",
    "earning interest in a bank account or invested in securities."
  ),
  br(),

  percentInput(
    inputId = "discount_rate",
    label = tagList(
      "Discount Rate ",
      tags$a(
        icon("circle-info"),
        href = "https://www.investopedia.com/terms/d/discountrate.asp#mntl-sc-block_1-0-49",
        rel = "external",
        target = "blank"
      )
    ),
    value = 10,
    min = 0,
    max = 100
  ),

  # Evaluation period
  suffixNumericInput(
    inputId = "eval_period",
    label = "Evaluation period",
    value = "10",
    min = 1,
    max = 50,
    suffix = "years"
  ),


  br(),
  br(),
  br(),
  br(),



  # Dev options
  div(
    class = "card",
    style="max-width: 30rem;",
    div(
      class = "card-header",
      "Developer options (to be removed)"
    ),
    div(
      class = "card-body",
      actionButton("dev_prefill", "Skip to results"),
      actionButton("dev_prefill_uncertainty", "Skip to results with uncertainty")
    )
  )

)
