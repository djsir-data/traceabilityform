# Packages
library(data.table)
library(shiny)
library(bslib)
library(shinyWidgets)
# library(highcharter)


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
  collapsible = TRUE,
  lang = "en",
  theme = bs_theme_update(
    bs_theme(bootswatch = "flatly"),
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

  # Results generation - only clean data once use is on results page
  input_set <- reactive({
    req(input$tabset == "results")
    parse_input_set(input$input_set, input_meta)
  })

  # Non-uncertainty results generation
  output$table_summary <- renderUI({
    assign("test", input_set(), envir = .GlobalEnv)
    html_summ_table(
      summ_data     = summ_input_set(input_set()),
      discount_rate = input$discount_rate,
      n_years       = input$eval_period
    )
  })

}

# Run the application
shinyApp(ui = ui, server = server)
