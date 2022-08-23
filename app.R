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
      tags$link(rel = "stylesheet", type = "text/css", href = "agvic.css"),
      tags$script("$(document).ready(function(){$(\".nav-link:not(.active)\").addClass(\"disabled\")});")
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
  hide(selector = '.uncertaintyContent')


  # Toggle advanced content
  observeEvent(input$switch_advanced, {

    if(input$switch_advanced == TRUE){
      hide(selector = '.basicContent', anim = TRUE, time = 0.4)
      show(selector = '.advancedContent', anim = TRUE, time = 0.4)
    } else if(input$switch_advanced == FALSE){
      show(selector = '.basicContent', anim = TRUE, time = 0.4)
      hide(selector = '.advancedContent', anim = TRUE, time = 0.4)
    } else {
      warning("switch_advanced input invalid")
    }

  })

  # Toggle uncertainty content
  observeEvent(input$switch_uncertainty, {

    if(input$switch_uncertainty == TRUE){
      show(selector = '.uncertaintyContent', anim = TRUE, time = 0.4)
    } else if(input$switch_advanced == FALSE){
      hide(selector = '.uncertaintyContent', anim = TRUE, time = 0.4)
    } else {
      warning("switch_advanced input invalid")
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
      financials = isTruthy(input$cur_rev) & isTruthy(input$cur_costs),
      TRUE
      )

    # Throw error if requirements not met
    if(!requirements_met){

      # Incorrect form highlighting
      badinputs <- switch(
        input$tabset,
        financials = c("cur_rev", "cur_costs")[
          !c(isTruthy(input$cur_rev), isTruthy(input$cur_costs))
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
