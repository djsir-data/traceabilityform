tab_start <- function(...) tabPanel(
  title = 'Start',
  value = 'start',

  # Note on not collecting data
  div(
    class = "alert alert-dismissible alert-info",
    tags$button(type = "button", class = "btn-close", `data-bs-dismiss` = "alert"),
    icon("circle-info"),
    br(),
    "This web tool does not collect any financial information that you may enter. ",
    "All information is deleted after your session ends. ",
    "You will have the option to download your results and inputs in a PDF report on the results page."
  ),

  # Title
  h1('Start'),

  # Some text
  p(
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
  ),

  # Advanced content
  advanced_content(
    border = TRUE,
    p("this content is hidden by the top switch:"),

    # Discount rate with info
    numericInput(
      inputId = "discount_rate",
      label = tagList(
        "Discount Rate ",
        tags$a(
          icon("circle-info"),
          href = "https://www.investopedia.com/terms/d/discountrate.asp",
          rel = "external",
          target = "blank"
          )
        ),
      value = "0.07",
      min = 0,
      max = 1
    ),

    # Evaluation period
    numericInput(
      inputId = "eval_period",
      label = "Evaluation period in years",
      value = "10",
      min = 1,
      max = 50
    )
  ) %>%
    # Start hidden
    tagAppendAttributes(style = "display: none;")
)
