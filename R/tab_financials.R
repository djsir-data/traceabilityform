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
      class = "col-lg-3",
      dollarInput(
        inputId = "cur_rev",
        label = "Current annual revenue",
        min = 0,
        max = 1e11, # One hundred billion dollars,
        width = "100%"
      )
    ),
    div(
      class = c("col-lg-3", "uncertaintyContent"),
      dollarRangeInput(
        inputId = "cur_rev_range",
        label = "Annual revenue range",
        width = "100%"
      )
    ),
    div(
      class = c("col-lg-3", "uncertaintyContent"),
      radioGroupButtons(
        inputId = "cur_rev_uncertainty",
        label = "Annual revenue certainty",
        choices = c("High", "Medium", "Low"),
        status = "primary",
        justified  = TRUE
      )
    )
  ),
  tags$hr(),
  fluidRow(
    div(
      class = "col-lg-3",
      dollarInput(
        inputId = "cur_costs",
        label = "Current annual costs",
        min = 0,
        max = 1e11, # One hundred billion dollars,
        width = "100%"
      )
    ),
    div(
      class = c("col-lg-3", "uncertaintyContent"),
      dollarRangeInput(
        inputId = "cur_costs_range",
        label = "Annual cost range",
        width = "100%"
      )
    ),
    div(
      class = c("col-lg-3", "uncertaintyContent"),
      radioGroupButtons(
        inputId = "cur_costs_uncertainty",
        label = "Annual costs certainty",
        choices = c("High", "Medium", "Low"),
        status = "primary",
        justified = TRUE
      )
    )
  )


)

