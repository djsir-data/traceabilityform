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
      value = "7",
      min = 0,
      max = 100
    ),

    # Evaluation period
    suffixNumericInput(
      inputId = "eval_period",
      label = "Evaluation period in years",
      value = "10",
      min = 1,
      max = 50,
      suffix = "years"
    )
  ) %>%
    # Start hidden
    tagAppendAttributes(style = "display: none;"),

  # # Diagnostic tool
  # br(),
  # div(
  #   class = "card text-white bg-primary mb-3",
  #   style = "max-width: 20rem;",
  #   div(class = "card-header", "Diagnostic tools"),
  #   div(
  #     class = "card-body",
  #     p(
  #       class = "card-text",
  #       "These features are only intended for development puroses and will not be available on release."
  #     ),
  #     tags$label("Enable all steps"),
  #     br(),
  #     actionButton(
  #       "diag_enable_tab",
  #       label = "Enable"
  #     ),
  #     br(),
  #     tags$label("Input validation"),
  #     switchInput(
  #       "diag_input_checks", value = T
  #     ),
  #     tags$label("Test bad input alert"),
  #     br(),
  #     actionButton(
  #       "diag_alert",
  #       label = "Alert"
  #     )
  #   )
  # )

)
