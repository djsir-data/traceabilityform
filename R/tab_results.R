tab_results <- function(...) tabPanel(
  title = 'Results',
  value = 'results',
  h2('Results'),

  # Summary table
  fluidRow(
    column(
      6,
      uiOutput("table_summary")
    ),
    column(
      6,
      p("some example text")
    )
  )

)
