tab_financials <- function(...) tabPanel(
  title = 'Current position',
  value = 'financials',

  # Title
  h2('Current financial position'),

  # Some text
  p(
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
  ),

  # Inputs
  fluidRow(
    div(
      class = "col-md-4",
      dollarInput(
        inputId = "cur_rev",
        label = "Current annual revenue",
        min = 0,
        max = 1e11, # One hundred billion dollars,
        width = "100%"
      )
    ),
    div(
      class = c("col-md-4", "uncertaintyContent"),
      dollarRangeInput(
        inputId = "cur_rev-range",
        label = "Annual revenue range",
        width = "100%"
      )
    ),
    div(
      class = c("col-md-4", "uncertaintyContent"),
      radioGroupButtons(
        inputId = "cur_rev-uncertainty",
        label = "Annual revenue certainty",
        choices = c("High", "Medium", "Low"),
        status = "primary",
        justified  = TRUE
      )
    )
  ),
  fluidRow(
    div(
      class = "col-md-4",
      dollarInput(
        inputId = "cur_costs",
        label = "Current annual costs",
        min = 0,
        max = 1e11, # One hundred billion dollars,
        width = "100%"
      )
    ),
    div(
      class = c("col-md-4", "uncertaintyContent"),
      dollarRangeInput(
        inputId = "cur_costs-range",
        label = "Annual cost range",
        width = "100%"
      )
    ),
    div(
      class = c("col-md-4", "uncertaintyContent"),
      radioGroupButtons(
        inputId = "cur_costs-uncertainty",
        label = "Annual costs certainty",
        choices = c("High", "Medium", "Low"),
        status = "primary",
        justified = TRUE
      )
    )
  )


)

