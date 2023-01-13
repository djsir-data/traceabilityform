# load all packages
pkgload::load_all()


ui <- navbarPage(
  # Titles and logos
  windowTitle = "Traceability cost-benefit",
  title = span(
    style = "font-family:VIC-Bold;",
    "Is tracability right for your business?"
  ),
  # Tabs
  tab_start(),
  tab_financials(),
  tab_add_revenue(),
  tab_red_costs(),
  tab_red_crisis(),
  tab_sol_provider(),
  tab_sup_chain(),
  tab_bus_costs(),
  tab_results(),
  # Page options
  id = "tabset",
  selected = "start",
  # fluid = FALSE,
  collapsible = TRUE,
  lang = "en",
  theme = bslib::bs_theme(bootswatch = "flatly", version = 5) %>%
    bslib::bs_theme_update(
    primary = "#00573F",
    secondary = "#003A28",
    success = "#00573F",
    warning = "#DDD4C2",
    info = "#00573F",
    font_scale = 1,
    base_font = "VIC-Regular",
    heading_font = "VIC-Bold"
  ),
  #header content
  header = tagList(
    # Head items (stylesheets and scripts)
    tags$head(
      tags$link(rel = "stylesheet", type = "text/css", href = "agvic.css"),
      tags$script(src = "navigation_validation.js"),
      # DEV
      shinyjs::useShinyjs()
    ),
    # Advanced switch
    column(
      12,
      div(
        style = "float: right;",
        materialSwitch(
          "switch_advanced",
          label = "Additional detail",
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
  footer =
    tagList(
      fluidRow(
        column(
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
      ),
      fluidRow(
        disclaimer(),
        div(
          class = "col-sm-12 text-center pb-2",
          tags$button(
            type="button",
            class="btn btn-link",
            `data-bs-toggle`="modal",
            `data-bs-target`="#disclaimer",
            "Disclaimer"
          )
        )
      )
    )
)


# Define server logic required to draw a histogram
server <- function(input, output, session) {

  # DEV feature
  observeEvent(input$dev_prefill, {
    if(input$switch_advanced) shinyjs::click("switch_advanced")
    if(input$switch_uncertainty) shinyjs::click("switch_uncertainty")
    prefill_values(input, output, session)
    shinyjs::removeClass(class = "disabled", selector = "a[data-toggle='tab']")
  })

  observeEvent(input$dev_prefill_uncertainty, {
    if(!input$switch_advanced) shinyjs::click("switch_advanced")
    if(!input$switch_uncertainty) shinyjs::click("switch_uncertainty")
    prefill_values(input, output, session)
    shinyjs::removeClass(class = "disabled", selector = "a[data-toggle='tab']")
  })

  # Get input metadata
  input_meta <- readRDS("app-cache/input_metadata.rds")

  # Results generation - only clean data once user is on results page
  input_set <- reactive({
    req(input$tabset == "results")
    parse_input_set(input$input_set, input_meta)
  })

  input_summary <- reactive({
    .GlobalEnv$test_input_set <- input_set()
    summ_input_set(input_set())
  })

  # Cost benefit totals
  ongoing_benefits <- reactive({
    .GlobalEnv$test_input_summary <- input_summary()
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

    discount(ongoing_benefits(), i, n) /
      (upfront_costs() + discount(ongoing_costs(), i, n)) - 1
  })

  roi_v <- reactive({

    i <- input$discount_rate / 100
    n <- input$eval_period

    discount_v(ongoing_benefits(), i, n) /
      (upfront_costs() + discount_v(ongoing_costs(), i, n)) - 1
  })

  returns <- reactive({

    i <- input$discount_rate / 100
    n <- input$eval_period

    discount(ongoing_benefits(), i, n) -
      upfront_costs() -
      discount(ongoing_costs(), i, n)
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
  annual_chart <- reactive({
    viz_annual_benefits(input_summary(), input$discount_rate, input$eval_period)
  })

  output$annual_chart <- renderHighchart(annual_chart())

  # Monte carlo data
  simulation_data <- reactive(
    if("beta" %in% names(input_set())){
      simulate_beta(input_set(), input$eval_period, input$discount_rate)
    } else {
      NULL
    }
  )

  # Uncertainty histogram
  output$uncertainty_hist <- renderHighchart({

    df <- input_set()

    if("beta" %in% names(df)){
      .GlobalEnv$test_simulation_data <- simulation_data()
      .GlobalEnv$test_params <- list(
        business_name = if(!is.null(input$bus_name) & input$bus_name != ""){
          input$bus_name
        } else {
          NULL
        },
        input_summary = input_summary(),
        input_set = input_set(),
        simulation_data = simulation_data(),
        ongoing_benefits = ongoing_benefits(),
        ongoing_costs = ongoing_costs(),
        upfront_costs = upfront_costs(),
        roi = roi(),
        returns = returns(),
        break_even_year = break_even_year(),
        discount_rate = input$discount_rate,
        n_years = input$eval_period
      )
      out <- vis_uncertainty_hist(simulation_data(), n_years = input$eval_period)
    } else {
      out <- viz_placeholder_hist()
    }

    out

  })

  # Uncertainty card
  output$uncertainty_card <- renderUI({
    uncertainty_card(simulation_data())
  })

  # Report download
  output$report <- downloadHandler(
    filename = "traceability_cost_benefit.pdf",
    contentType = "application/pdf",
    content = function(file){

      # Ensure template is in editable location
      temp_location <- tempdir()
      file.copy("report", temp_location, overwrite = TRUE, recursive = TRUE)

      # Generate report
      rmarkdown::render(
        file.path(temp_location, "report", "report_template.Rmd"),
        output_file = file,
        params = list(
          business_name = if(!is.null(input$bus_name) & input$bus_name != ""){
            input$bus_name
          } else {
            NULL
          },
          input_summary = input_summary(),
          input_set = input_set(),
          simulation_data = simulation_data(),
          ongoing_benefits = ongoing_benefits(),
          ongoing_costs = ongoing_costs(),
          upfront_costs = upfront_costs(),
          roi = roi(),
          returns = returns(),
          break_even_year = break_even_year(),
          discount_rate = input$discount_rate,
          n_years = input$eval_period
        )
        )
    }
  )

}

# Run the application
shinyApp(ui = ui, server = server)
