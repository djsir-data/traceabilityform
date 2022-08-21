# Packages
library(magrittr)
library(shiny)
library(bslib)
library(shinyWidgets)
library(shinyjs)
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
      useShinyjs(),
      tags$link(rel = "stylesheet", type = "text/css", href = "agvic.css")
    ),
    # Advanced switch
    column(
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
server <- function(input, output, session) {

  # Tab order
  tab_values <- c(
    "start",
    "financials",
    "add_revenue",
    "red_costs",
    "red_crisis",
    "sol_provider",
    "bus_costs",
    "sup_chain",
    "results"
  )

  # Disable Steps not yet completed & advanced content by default
  disable(selector = '.navbar-nav a:not(.active, .completed)')
  hide(selector = '.advancedContent')

  # DIAGNOSTIC TOOL - enable all tabs
  observeEvent(input$diag_enable_tab, {enable(selector = ".navbar-nav a")})

  # Toggle advanced content
  observeEvent(input$switch_advanced, {

    if(input$switch_advanced == TRUE){
      hide(selector = '.basicContent', anim = TRUE, time = 0.4)
      show(selector = '.advancedContent', anim = TRUE, time = 0.4)
    } else if(input$switch_advanced == FALSE){
      show(selector = '.basicContent', anim = TRUE, time = 0.4)
      hide(selector = '.advancedContent', anim = TRUE, time = 0.4)
    } else {
      waring("switch_advanced input invalid")
    }

  })

  # Forward and backwards navigation
  observeEvent(input$btn_next, {
    # Last tab handler
    req(input$tabset != tab_values[length(tab_values)])

    # Clear invalid form classes
    removeClass(selector = ".shiny-bound-input", class = "is-invalid")

    # Evaluate whether this page's requirements are met
    requirements_met <- switch(
      input$tabset,
      financials = input$cur_rev != 0 & input$cur_costs != 0,
      TRUE
      )

    # DIAGNOSTIC FEATURE
    # Only test requirements if enabled
    requirements_met <- requirements_met | !input$diag_input_checks

    # Throw error if requirements not met
    if(!requirements_met){

      # Error message
      sendSweetAlert(
        session = session,
        width = 400,
        title = "Missing values",
        text = "Please ensure all inputs are filled",
        type = "error"
      )

      # Incorrect form highlighting
      badinputs <- switch(
        input$tabset,
        financials = c("cur_rev", "cur_costs")[
          c(input$cur_rev == 0, input$cur_costs == 0)
          ],
        character(0)
      )

      lapply(badinputs, addClass, class = "is-invalid")

    }

    # Prevent tab switch without requirements met
    req(requirements_met)

    # Tab increment
    target_tab <- tab_values[match(input$tabset, tab_values) + 1]
    enable(selector = paste0(".nav-item a[data-value=", target_tab, "]"))
    updateNavbarPage(inputId = "tabset", selected = target_tab)
  })

  observeEvent(input$btn_prev, {
    # First tab handler
    req(input$tabset != tab_values[1])
    # Tab increment
    target_tab <- tab_values[match(input$tabset, tab_values) - 1]
    updateNavbarPage(inputId = "tabset", selected = target_tab)
  })

}

# Run the application
shinyApp(ui = ui, server = server)
