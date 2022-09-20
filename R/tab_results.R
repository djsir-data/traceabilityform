tab_results <- function(...) tabPanel(
  title = 'Results',
  value = 'results',


  h2('Results'),
  div(
    class = "row",
    div(
      class = "col py-4",
      uiOutput("results_card")
    )
  ),

  # Summary table
  div(
    class = "row g-5",
    div(
      class = "col-md-6",
      highchartOutput("annual_chart", height = "100%")
    ),
    div(
      class = "col-md-6",
      uiOutput("table_summary")
    )
  ),

  # Uncertainty content
  h3("Probably of positive returns"),
  div(
    class = "row g-5",
    div(
      class = "col-md-6",
      highchartOutput("uncertainty_hist")
    ),
    div(
      class = "col-md-6",
      p("SOme text")
    )
  )
)

