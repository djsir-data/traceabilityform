tab_results <- function(...) tabPanel(
  title = 'Results',
  value = 'results',
  h2('Results'),
  fluidRow(
    uiOutput("results_card")
  ),

  # Summary table
  fluidRow(
    column(
      6,
      highchartOutput("annual_chart", height = "550px")
    ),
    column(
      6,
      uiOutput("table_summary")
    )
  )
)

