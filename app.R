# Packages
library(shiny)
library(shinyjs)
library(bslib)
library(shinyWidgets)


# Get functions from R directory
lapply(
  list.files("./R", ".R|.r", full.names = TRUE),
  source
)


ui <- navbarPage(
  # Head items (stylesheets and scripts)
  tags$head(
    useShinyjs(),
    tags$link(rel = "stylesheet", type = "text/css", href = "agvic.css")
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
  tab_add_revenue(),
  tab_results(),
  # Tabset options
  id = "tabset",
  selected = "start",
  theme = bs_theme_update(
    bs_theme(bootswatch = "flatly"),
    primary = "#67823A",
    secondary = "#53565A",
    success = "#759157",
    info = "#BBBCBC",
    font_scale = 1.1,
    base_font = "VIC-Regular",
    heading_font = "VIC-Bold"
  ),
  # Advanced switch
  header = column(
    12,
    tagAppendAttributes(
      tagAppendAttributes(
        materialSwitch(
          "switch_advanced",
          label = "Additonal detail"
        ),
        style = "float: right;"
      ),
      style = "float: right;",
      .cssSelector = ".material-switch"
    )
  ),
  # Previous and next button footer
  footer = column(
    12,
    style = "padding-top:50px;",
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
server <- function(input, output) {
  disable(selector = '.navbar-nav a:not(.active, .completed)')
  tab_values <- c(
    "start",
    "financials",
    "add_revenue",
    "red_costs",
    "red_crisis",
    "sol_provider",
    "bus_costs",
    "sup_chain",
    "add_revenue",
    "results"
  )
  observeEvent(input$btn_next, {enable(selector = ".navbar-nav a")})
}

# Run the application
shinyApp(ui = ui, server = server)
