tab_financials <- function(...) tabPanel(
  title = 'Current position',
  value = 'financials',

  # Title
  h1('Current financial position'),

  # Some text
  p(
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
  ),

  # Inputs
  fluidRow(
    div(
      class = "col-sm-3",
      style = "width: 300px;",
      numericInput(
        inputId = "cur_rev",
        label = "Current annual revenue ($)",
        min = 0,
        max = 1e11, # One hundred billion dollars,
        value = 0,
        width = "300px"
      )
    ),
    div(
      class = "col",
      advanced_content(
        radioGroupButtons(
          inputId = "cur_rev_uncertainty",
          label = "Certainty",
          choices = c("High", "Medium", "Low"),
          status = "primary"
        )
      )
    )
  ),
  fluidRow(
    column(
      3,
      style = "width: 300px;",
      numericInput(
        inputId = "cur_costs",
        label = "Current annual costs ($)",
        min = 0,
        max = 1e11, # One hundred billion dollars,
        value = 0
      )
    ),
    div(
      class = "col",
      advanced_content(
        radioGroupButtons(
          inputId = "cur_costs_uncertainty",
          label = "Certainty",
          choices = c("High", "Medium", "Low"),
          status = "primary"
        )
      )
    )
  )


)

