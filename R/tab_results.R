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
      div(
        class = "card h-100",
        div(
          class = "card-header",
          tags$b("Expected return on investment by year")
        ),
        div(
          class = "card-body h-100",
          highchartOutput("annual_chart", height = "100%")
        )
      )
    ),
    div(
      class = "col-md-6",
      div(
        class = "card h-100",
        div(
          class = "card-header",
          tags$b("Cost/benefit breakdown")
        ),
        div(
          class = "card-body h-100",
          uiOutput("table_summary")
        )
      )
    )
  ),

  # Uncertainty content
  h3("Probably of positive returns"),
  div(
    class = "row g-5",
    div(
      class = "col-md-6",
      div(
        class = "card h-100",
        div(
          class = "card-header",
          tags$b("Simulated return on investment distribution")
        ),
        div(
          class = "card-body h-100",
          highchartOutput("uncertainty_hist")
        )
      )
    ),
    div(
      class = "col-md-6",
      div(
        class = "card h-100",
        div(
          class = "card-header",
          tags$b("To be filled")
        ),
        div(
          class = "card-body h-100",
          p("some text")
        )
      )
    )
  )
)

