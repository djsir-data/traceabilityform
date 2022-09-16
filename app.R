# Packages
library(data.table)
library(shiny)
library(bslib)
library(shinyWidgets)
library(highcharter)


# Get functions from R directory
lapply(
  list.files("./R", ".R|.r", full.names = TRUE),
  source
)


ui <- navbarPage(
  # Titles and logos
  windowTitle = "Traceability cost-benefit",
  title = span(
    style = "font-family:VIC-Bold;",
    HTML("Is tracability</br>right for you?")
  ),
  # Tabs
  tab_start(),
  tab_financials(),
  tab_add_revenue(),
  tab_red_costs(),
  tab_red_crisis(),
  tab_sol_provider(),
  tab_bus_costs(),
  tab_sup_chain(),
  tab_results(),
  # Page options
  id = "tabset",
  selected = "start",
  # fluid = FALSE,
  collapsible = TRUE,
  lang = "en",
  theme = bs_theme_update(
    bs_theme(bootswatch = "flatly", version = 5),
    primary = "#67823A",
    secondary = "#53565A",
    success = "#759157",
    info = "#00573F",
    font_scale = 1.1,
    base_font = "VIC-Regular",
    heading_font = "VIC-Bold"
  ),
  #header content
  header = tagList(
    # Head items (stylesheets and scripts)
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "agvic.css"),
      tags$script(src = "navigation_validation.js")
    ),
    # Advanced switch
    column(
      12,
      div(
        style = "float: right;",
        materialSwitch(
          "switch_advanced",
          label = "Additonal detail",
          inline = TRUE
        ),
        materialSwitch(
          "switch_uncertainty",
          label = "Uncertainty",
          inline = TRUE
        )
      )
    )
  ),
  # Previous and next button footer
  footer = column(
    12,
    style = "padding-top:50px;padding-bottom:50px;",
    actionButton(
      "btn_prev",
      span(icon("arrow-left"), " Previous")
    ),
    actionButton(
      "btn_next",
      span("Next ", icon("arrow-right")),
      style = "float: right;"
    )
  )

)


# Define server logic required to draw a histogram
server <- function(input, output, session) {

  # DEV feature
  observeEvent(input$dev_prefill, {
    prefill_values(input, output, session)
  })

  # Get input metadata
  input_meta <- readRDS("app-cache/input_metadata.rds")

  # Results generation - only clean data once user is on results page
  input_set <- reactive({
    req(input$tabset == "results")
    parse_input_set(input$input_set, input_meta)
  })

  input_summary <- reactive({
    summ_input_set(input_set())
  })

  # Cost benefit totals
  ongoing_benefits <- reactive({
    input_summary()[flow == "Ongoing benefit", sum(value)]}
    )
  ongoing_costs <- reactive({
    input_summary()[flow == "Ongoing cost", sum(value)]
    })
  upfront_costs <- reactive({
    input_summary()[flow == "Upfront cost", sum(value)]
    })



  # ROI and absolute returns generation
  roi <- reactive({

    i <- input$discount_rate / 100
    n <- input$eval_period

    round(
      discount(ongoing_benefits(), i, n) /
        (upfront_costs() + discount(ongoing_costs(), i, n)) - 1,
      1
    )
  })

  roi_v <- reactive({

    i <- input$discount_rate / 100
    n <- input$eval_period

    round(
      discount_v(ongoing_benefits(), i, n) /
        (upfront_costs() + discount_v(ongoing_costs(), i, n)) - 1,
      1
    )
  })

  returns <- reactive({

    i <- input$discount_rate / 100
    n <- input$eval_period

    round(
      discount(ongoing_benefits(), i, n) -
        upfront_costs() -
        discount(ongoing_costs(), i, n)
    )
  })

  # When will the business break even
  break_even_year <- reactive({

    discount_rate <- input$discount_rate
    n_years <- input$eval_period

    if(any(roi_v() >= 0)){
      which(roi_v() >= 0)[1]
    } else {
      as.integer(NA)
    }

  })

  # Results card
  output$results_card <- renderUI({
    results_card(
      roi = roi(),
      results = returns(),
      n_years = input$eval_period,
      break_even_year = break_even_year()
    )
  })

  # Non-uncertainty results generation
  output$table_summary <- renderUI({
    html_summ_table(
      summ_data     = input_summary(),
      discount_rate = input$discount_rate,
      n_years       = input$eval_period
    )
  })

  # Annual chart
  output$annual_chart <- renderHighchart({
    viz_annual_benefits(input_summary(), input$discount_rate, input$eval_period)
  })

}

# Run the application
shinyApp(ui = ui, server = server)
