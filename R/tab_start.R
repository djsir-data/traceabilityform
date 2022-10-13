tab_start <- function(...) tabPanel(
  title = 'Start',
  value = 'start',

  # Title
  h2('Introduction'),

  # Intro text
  p(
    "The traceability cost-benefit analysis tool has been developed to help",
    "agricultural businesses calculate: ",
    tags$ul(
      tags$li("whether a traceability system would benefit their business"),
      tags$li(
        "their expected return on investment (ROI)",
        tags$sup(
          tags$a(
            icon("circle-info"),
            href = "https://www.investopedia.com/terms/r/returnoninvestment.asp",
            rel = "external",
            target = "blank",
            style = "text-decoration: none;"
          )
        ),
        " by year and"
        ),
      tags$li(
        "a breakdown of the cost/benefit depending on the detail of data",
        "provided."
        )
    ),
    "Users are asked questions about the benefits of traceability in their",
    "business. And are required to estimate any costs associated with",
    "upgrading or introducing a new traceability system."
  ),
  tags$strong(tags$em("Please note:")),
  tags$ul(
    tags$li(
      "This web tool does not collect and/or store any financial information",
      "a user may enter."
      ),
    tags$li("All information is deleted after the session ends.")
  ),
  p(
    "Users will have the option to download results and inputs in a PDF",
    "report on the results page. This tool is for guidance purposes only. Any",
    "results are general in nature and the choice to adopt a traceability",
    "system should be considered alongside other information and expertise.",
    "No claim is made about the accuracy or appropriateness of any content or",
    "results in this report at any time."
  ),
  br(),
  tags$strong(
    class = "text-decoration-underline",
    "Analysis options"
    ),
  p(
    "Using the switches in the top right corner, users  can select ‘additional",
    "detail’ or ‘uncertainty’ when inputting data.",
    tags$img(
      src = "switch_demo.png",
      alt = "Image of toggle switches",
      style = "display: block; border-radius: 5px;border: 1px solid black;",
      class = "my-2"
      ),
    "Where applicable, the ‘additional detail’ switch will list individual",
    "cost/benefit considerations. This may be useful when trying to determine",
    "how a cost or benefit may impact a business. "
  ),
  p(
    "The ‘uncertainty’ switch enables calculation of risk in returns.",
    tags$sup(
      tags$a(
        icon("circle-info"),
        href = "https://www.investopedia.com/terms/r/risk.asp",
        rel = "external",
        target = "blank",
        style = "text-decoration: none;"
      )
    ),
    " By selecting a level of certainty (High | Medium | Low), users can",
    "confirm the accuracy of the amount they’ve used for each item. Using the",
    "‘uncertainty’ switch will simulate 5,000 plausible scenarios",
    " and report how many of them lead to a positive return for the business.",
    tags$sup(
      tags$a(
        icon("circle-info"),
        href = "https://www.investopedia.com/terms/m/montecarlosimulation.asp",
        rel = "external",
        target = "blank",
        style = "text-decoration: none;"
      )
    )
  ),
  h2("Start"),
  tags$strong(
    class = "text-decoration-underline",
    "Evaluation period and discounting"
    ),
  p(
    "Before you begin, please enter how many years into the future you would",
    "like this analysis to evaluate and a preferred",
    tags$a(
      "discount rate.",
      href="#",
      `data-bs-toggle`="tooltip",
      `data-bs-placement`="bottom",
      onclick="return false;",
      `data-bs-title`=paste(
        "A discount rate can be thought of as the rate your investment dollars",
        "would be earning if not used for traceability systems, for example,",
        "they could be earning interest in a bank account or invested in",
        "securities."
      )
    )
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
