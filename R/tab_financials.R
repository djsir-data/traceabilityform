tab_financials <- function(...) tabPanel(
  title = 'Current position',
  value = 'financials',

  # Title
  h2('Current financial position'),

  # Some text
  p(
    "What is your current annual revenue and total business operating costs?
    This information is used to calculate the dollar value equivalent of
    percentage changes in revenue and costs.",
    br(),
    br(),
    tags$strong(
      "This information will not be saved and is deleted after your session
      ends."
    )
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

