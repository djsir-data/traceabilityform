

parse_input_set <- function(set, input_meta){

  # Remove any variables from the start or results tab
  set$Start <- NULL
  set$Results <- NULL

  # Error handling
  if(is.null(set)) return(NULL)
  if(all(is.null(unlist(set)))) return(NULL)

  # Turn tab inputs into matrix
  set <- lapply(
    names(set),
    function(n){
      # Get tab results within the set object
      in_list <- set[[n]]
      # Split input name on '-'. left side is the variable right is the measure
      var_measure <- tstrsplit(names(in_list), split = "-")
      # turn values into vector
      vals <- unlist(in_list, use.names = F)
      # Combine into data table
      data.table(
        group = n,
        variable = var_measure[[1]],
        measure = var_measure[[2]],
        value = vals
      )
    }
  )

  # Bind rows and convert to data table
  set <- rbindlist(set)

  # Pivot wider & reclass
  set <- dcast(set, group + variable ~ measure, value.var = "value")

  # Reclass to numeric
  to_numeric <- intersect(names(set), c("expected", "range_min", "range_max"))
  set[, (to_numeric) := lapply(.SD, as.numeric), .SDcols = to_numeric]

  # Change uncertainty to alpha
  if("uncertainty" %in% names(set)){
    alphas <- c(Low = 34, Medium = 6, High = 2)
    set[, alpha := alphas[match(uncertainty, names(alphas))]]
    set[,
        beta := alpha * (range_max - range_min) / (expected - range_min) - alpha
    ]
    set[, uncertainty := NULL]
  }

  # Join metadata
  set <- input_meta[set, on = c("group", "variable")]

  return(set)
}



# Summarise input set
summ_input_set <- function(input_set){

  # This function relies on data table syntax
  setDT(input_set)

  # Separate out data
  cur_rev   <- input_set[flow == "Current revenue", expected]
  cur_costs <- input_set[flow == "Current costs",   expected]
  crisis    <- input_set[flow == "Crisis"]
  input_set <- input_set[
    flow %in% c("Upfront cost", "Ongoing cost", "Ongoing benefit")
  ]

  # Convert new revenue percent to dollar
  input_set[
    units == "percent" & group == "New revenue",
    `:=`(
      expected = expected * cur_rev / 100,
      units    = "dollar"
    )
  ]

  #  Convert cost saving percent to dollar
  input_set[
    units == "percent" & group == "Cost savings",
    `:=`(
      expected = expected * cur_costs / 100,
      units    = "dollar"
    )
  ]

  # Drop superflous variables
  input_set[, c("variable", "units") := NULL]

  # Separate out crisis dimensions
  crisis[, c("variable", "measure", "period") := tstrsplit(variable, split = "_")]
  crisis[, c("group", "flow") := NULL]

  # Summarise crisis costs by multiplying dollar costs by expected occurrences
  crisis <- crisis[, split(expected, measure), .(variable, period)]
  crisis[, expected := dollar * time]
  crisis[, c("dollar", "time") := NULL]

  # Summarise crisis costs by differencing old and new expenses
  crisis <- crisis[, split(expected, period), variable]
  crisis[, expected := old - new]
  crisis[, c("old", "new") := NULL]

  # Add flow and group back to crisis + divide by five years (input is per five years)
  crisis[, `:=`(group = "Crisis management", flow = ifelse(
    expected >= 0,
    "Ongoing benefit",
    "Ongoing cost"
  ))]
  crisis[, expected := abs(expected) / 5]

  # Bind crisis back in
  input_set <- rbindlist(list(input_set, crisis), fill = TRUE)

  # Summarise
  input_set <- input_set[, .(value = sum(expected)), keyby = .(flow, group)]

  # Return table
  return(input_set)

}


# Title card
results_card <- function(roi, results, n_years, break_even_year){

  returns_sign <- if(results < 0 ) "-$" else "$"

  # Card text
  out_text <- if(roi >= 0){
    paste0(
      "This model estimates traceability systems should benefit your business ",
      "with ", tags$b(
        paste0(
          "a total ", round(roi, 1), "% discounted return on investment"
          )
        ),
      " (or ", returns_sign, format(round(abs(results)), big.mark = ","),
      ") over ", n_years, " years. ",
      tags$b(
        paste0(
          "Your business is estimated to break even on traceability systems within ",
          break_even_year, " year", if(break_even_year > 1){"s"}, "."
        )
      )
    )
  } else {
    paste0(
      "Results suggest traceability systems will not benefit your business ",
      "with ",
      tags$b(
        paste0(
          "a total ", round(roi, 1), "% discounted return on investment"
        )
      ),
      " (or ", returns_sign, format(round(abs(results)), big.mark = ","),
      ") over ", n_years, " years."
    )
  }

  # Card icon
  out_icon <- if(roi >= 0){
    icon("circle-check")#, class = "text-success")
  } else (
    icon("circle-xmark")#, class = "text-danger")
  )

  # Cart title
  out_title <- if(roi >= 0){
    "Traceability is right for you"
  } else (
    "Traceability is not right for you"
  )

  # Header class
  header_class <- if(roi > 0){
    "card-header text-white bg-success"
  } else {
    "card-header text-white bg-danger"
  }


  # out
  return(
    div(
      class = "card h-100",
      div(
        class = header_class,
        out_icon,
        out_title
      ),
      div(
        class = "card-body",
        HTML(out_text)
      )
    )
  )

}


html_summ_table <- function(summ_data, discount_rate, n_years){

  # Ensure we're not editing summary data
  summ_data <- copy(summ_data)

  # Discounting doesn't work with 0
  if(discount_rate == 0){ discount_rate <- 0.0000001}

  # Generate totals
  ongoing_benefits <- summ_data[flow == "Ongoing benefit", sum(value)]
  ongoing_costs    <- summ_data[flow == "Ongoing cost",    sum(value)]
  upfront_costs    <- summ_data[flow == "Upfront cost",    sum(value)]

  # Change discount rate to decimal
  discount_rate <- discount_rate / 100

  # Totals
  total_dollar <- round(
    discount(ongoing_benefits, discount_rate, n_years) -
      upfront_costs -
      discount(ongoing_costs, discount_rate, n_years)
  )

  total_roi <- round(
    discount(ongoing_benefits, discount_rate, n_years) /
      (upfront_costs + discount(ongoing_costs, discount_rate, n_years)) - 1,
    1
  )

  # Recode variables
  summ_data[
    group == "Supply chain",
    group := "Assistance for supply chain partners"
  ]
  summ_data[
    group == "Business costs",
    group := "Changes to business"
  ]
  summ_data[
    group == "Provider costs",
    group := "Solution provider expenses"
  ]
  summ_data[,
            `:=`(
              flow = factor(
                paste0(flow, "s"),
                levels = c("Upfront costs", "Ongoing benefits", "Ongoing costs")
              ),
              group = factor(
                group,
                levels = c(
                  "Solution provider expenses",
                  "Changes to business",
                  "Assistance for supply chain partners",
                  "New revenue",
                  "Cost savings",
                  "Crisis management"
                )
              )
            )
  ]

  # Format values (see theme.R for table_dollar function)
  summ_data[,
            `:=`(
              prefix = ifelse(flow == "Ongoing benefits", "+$", "-$"),
              suffix = ifelse(
                flow == "Upfront costs",
                "",
                as.character(
                  tags$abbr(
                    "p.a.",
                    title = "Per Annum",
                    style = "text-decoration: none;"
                  )
                )
              ),
              value = format(
                abs(value),
                digits = 1L,
                big.mark = ",",
                justify = "none",
                scientific = FALSE
              )
            )
  ]

  # sort
  setkey(summ_data, flow, group)

  # set up flows
  flows <- table(summ_data$flow)

  # Value column formatting
  val_col_width <- max(
    nchar(summ_data$value),
    nchar(format(total_dollar, big.mark = ",", scientific = FALSE)),
    nchar(format(total_roi, big.mark = ",", scientific = FALSE))
  )
  val_col_css <- paste0("width: ", val_col_width, ";text-align: right;")

  # group/prefix/suffix column formatting
  group_col_css <- "padding-left: 2rem;"
  pre_col_css <- "width: 2rem;text-align: right;"
  suf_col_css <- "width: 2rem;text-align: left;"

  # Table flow fun
  table_flow <- function(flow_name){
    # Generate table data
    out <- apply(summ_data[flow == flow_name], 1, function(x){
      tags$tr(
        # Group name
        tags$td(x["group"], style = group_col_css),
        # Dollar sign prefix col
        tags$td(x["prefix"], style = pre_col_css),
        # Value col
        tags$td(x["value"], style = val_col_css),
        # Suffix column
        tags$td(HTML(x["suffix"]), style = suf_col_css)
      )
    })
    # Add row heading
    out <- tagList(
      tags$tr(
        tags$th(
          flow_name,
          colspan = 4
        )
      ),
      out
    )
    return(out)
  }

  # Generate total row
  total_class <- ifelse(total_dollar >= 0, "text-success", "text-danger")

  total_rows <- tagList(
    tags$tr(
      style = "border-top: 2px solid;",
      # class = total_row_class,
      tags$th(
        paste0(n_years, "-year total"),
        colspan = 5
      )
    ),
    tags$tr(
      tags$td("Discounted return on investment", style = group_col_css),
      tags$td(
        HTML(ifelse(total_roi > 0, "+&nbsp;", "-&nbsp;")),
        class = total_class,
        style = paste0(pre_col_css, "font-weight: bold;")
      ),
      tags$td(
        format(abs(total_roi), big.mark = ",", scientific = FALSE),
        class = total_class,
        style = paste0(val_col_css, "font-weight: bold;")
      ),
      tags$td(
        "%",
        class = total_class,
        style = paste0(suf_col_css, "font-weight: bold;")
      )
    ),
    tags$tr(
      style = "border-bottom: thick double;",
      tags$td("Discounted returns", style = group_col_css),
      tags$td(
        ifelse(total_dollar > 0, "+$", "-$"),
        class = total_class,
        style = paste0(pre_col_css, "font-weight: bold;")
      ),
      tags$td(
        format(abs(total_dollar), big.mark = ",", scientific = FALSE),
        class = total_class,
        style = paste0(val_col_css, "font-weight: bold;")
      ),
      tags$td(
        "",
        class = total_class,
        style = paste0(suf_col_css, "font-weight: bold;")
      )
    )
  )

  # Generate table
  tags$table(
    class = "table table-borderless table-hover table-sm",
    tags$thead(),
    tags$tbody(
      lapply(names(flows), table_flow),
      total_rows
    )
  )

}


# Annual benefits chart
viz_annual_benefits <- function(
    summ_data,
    discount_rate,
    n_years,
    type = "roi"
){

  # Ensure we're not editing summary data
  summ_data <- copy(summ_data)

  # Discounting doesn't work with 0
  if(discount_rate == 0){ discount_rate <- 0.0000001}

  # Generate totals
  ongoing_benefits <- summ_data[flow == "Ongoing benefit", sum(value)]
  ongoing_costs    <- summ_data[flow == "Ongoing cost",    sum(value)]
  upfront_costs    <- summ_data[flow == "Upfront cost",    sum(value)]

  # Change discount rate to decimal
  discount_rate <- discount_rate / 100

  # Chart series
  series <- if(type == "roi"){
      discount_v(ongoing_benefits, discount_rate, n_years) /
        (upfront_costs + discount_v(ongoing_costs, discount_rate, n_years)) - 1
  } else {
      discount_v(ongoing_benefits, discount_rate, n_years) -
        upfront_costs -
        discount_v(ongoing_costs, discount_rate, n_years)
  }

  # Add year information

  chart_lab <- ifelse(type == "roi", "Return on investment", "Returns")
  chart_prefix <- ifelse(type == "roi", "", "$")
  chart_suffix <- ifelse(type == "roi", "%", "")
  chart_y_format <- ifelse(type == "roi", "{text}%", "${text}")

  series <- data.frame(
    x = paste("Year", 1:n_years),
    y = series,
    group = chart_lab
  )

  hchart(
    series,
    "spline",
    hcaes(x = x, y = y, group = group),
    color = "#00573F"
    ) %>%
    hc_yAxis(
      gridLineWidth = 0,
      minorGridLineWidth = 0,
      title = list(text = chart_lab),
      labels = list(format = chart_y_format),
      plotLines = list(
        list(
          value = 0,
          width = 1,
          color = '#000000'
        )
      )

    ) %>%
    ag_chart() %>%
    hc_xAxis(
      title = list(enabled = FALSE),
      tickLength = 0
    ) %>%
    hc_legend(
      enabled = FALSE
    ) %>%
    hc_tooltip(
      valuePrefix = chart_prefix,
      valueSuffix = chart_suffix,
      valueDecimals = 2
    ) %>%
    hc_chart(
      events = list(
        load = highcharter::JS(
          "
          function(){
            this.setSize(null,null);
          }
          "
        )
      )
    )
}


# Simulate various ROI with beta distribution
simulate_beta <- function(input_set, n_years, discount_rate, n = 5000, seed = 1){

  # Make sure discount rate is ratio
  discount_rate <- discount_rate / 100

  # ensure we're not editing the og input set
  input_set <- copy(input_set)
  setDT(input_set)

  # Get current values
  cur_rev   <- input_set[flow == "Current revenue", expected]
  cur_costs <- input_set[flow == "Current costs",   expected]
  input_set <- input_set[!(flow %in% c("Current revenue", "Current costs"))]

  # Convert new revenue percent to dollar
  input_set[
    units == "percent" & group == "New revenue",
    `:=`(
      expected = expected * cur_rev / 100,
      range_min = range_min * cur_rev / 100,
      range_max = range_max * cur_rev / 100
    )
  ]

  #  Convert cost saving percent to dollar
  input_set[
    units == "percent" & group == "Cost savings",
    `:=`(
      expected = expected * cur_costs / 100,
      range_min = range_min * cur_costs / 100,
      range_max = range_max * cur_costs / 100
    )
  ]

  # Drop superflous variables
  input_set[, units := NULL]

  # Split dataset into crisis, uncertainty and non-uncertainty content
  crisis    <- input_set[flow == "Crisis"]
  uncertain <- input_set[flow != "Crisis" & is.finite(beta)]
  certain   <- input_set[
    flow != "Crisis" & !is.finite(beta),
    .(group, variable, flow, expected)
  ]

  # Clean up crisis costs then separate out into certain and uncertain
  crisis[, c("variable", "measure", "period") := tstrsplit(variable, split = "_")]
  crisis[, c("group", "flow") := NULL]

  crisis_uncertain <- crisis[is.finite(beta)]
  crisis_certain   <- crisis[
    !is.finite(beta),
    .(variable, measure, expected, period)
    ]

  # Monte Carlo
  set.seed(seed)

  uncertain <- uncertain[,
    .(
      expected = rbeta_min_max(
        n = n,
        shape1 = alpha,
        shape2 = beta,
        min = range_min,
        max = range_max
      )
      ),
    .(group, variable, flow)
    ]

  crisis_uncertain <- crisis_uncertain[,
    .(
      expected = rbeta_min_max(
        n = n,
        shape1 = alpha,
        shape2 = beta,
        min = range_min,
        max = range_max
      )
    ),
    .(variable, measure, period)
  ]


  # Rebind data
  crisis <- rbind(crisis_certain, crisis_uncertain, fill = TRUE)
  input_set <- rbind(certain, uncertain, fill = TRUE)

  # remove other datasets to minimise memory usage with concurrent users
  rm(crisis_certain, crisis_uncertain, certain, uncertain)

  # Summarise crisis costs by multiplying dollar costs by expected occurrences
  crisis <- crisis[, split(expected, measure), .(variable, period)]
  crisis[, expected := dollar * time]
  crisis[, c("dollar", "time") := NULL]

  # Summarise crisis costs by differencing old and new expenses
  crisis <- crisis[, split(expected, period), variable]
  crisis[, expected := old - new]
  crisis[, c("old", "new") := NULL]

  # Add flow and group back to crisis + divide by five years (input is per five years)
  crisis[, `:=`(group = "Crisis management", flow =  "crisis")]
  crisis[, expected := expected / 5]

  # Add crisis costs back into main dataset
  input_set <- rbind(input_set, crisis, fill = TRUE)
  rm(crisis)

  # Sum over flow
  input_set <- input_set[,
    .(expected = Reduce(`+`, split(expected, variable))),
    flow
  ]

  # Pivot
  input_set <- input_set[, split(expected, flow)]

  # Add crisis to either benefits or costs depending on value
  input_set[,
    `:=`(
      `Ongoing benefit` = ifelse(
        test = crisis >= 0,
        yes  = `Ongoing benefit` + crisis,
        no   = `Ongoing benefit`
        ),
      `Ongoing cost` = ifelse(
        test = crisis >= 0,
        yes  = `Ongoing cost`,
        no   = `Ongoing cost`+ abs(crisis)
      )
    )
  ]

  input_set[, crisis := NULL]

  # Clean up names
  setnames(input_set, tolower)
  setnames(input_set, function(x) gsub(" ", "_", x))
  setnames(input_set, function(x) paste0(x, "s"))

  # Calculate ROI
  input_set[,
    `:=`(
      returns = discount(ongoing_benefits, discount_rate, n_years) -
        upfront_costs -
        discount(ongoing_costs, discount_rate, n_years),
      roi = discount(ongoing_benefits, discount_rate, n_years) /
        (upfront_costs + discount(ongoing_costs, discount_rate, n_years)) - 1
    )
  ]

  return(input_set)

}

vis_uncertainty_hist <- function(simulation_data, n_years, breaks = "Sturges"){

  df_hist <- hist(simulation_data$roi, breaks = breaks)
  df_hist <- data.table(
    x = head(df_hist$breaks, -1),
    y = df_hist$density,
    tip = paste0(
      round(rev(cumsum(rev(df_hist$counts)) / sum(df_hist$counts)) * 100, 1),
      "% chance of >",
      head(df_hist$breaks, -1),
      "% discounted return on investment in ",
      n_years,
      " years"
      )
    )

  hchart(
    df_hist,
    "area",
    hcaes(x = x, y = y),
    pointPadding = 0,
    borderWidth =  0,
    groupPadding = 0,
    shadow = FALSE,
    color = "#00573F"
  ) %>%
    hc_yAxis(visible = FALSE) %>%
    hc_tooltip(
      useHTML = TRUE,
      formatter = highcharter::JS(
        "
        function(){
        return this.point.tip;
        }
        ")
    ) %>%
    ag_chart() %>%
    hc_xAxis(
      plotLines = list(
        list(
          dashStyle = "Dash",
          value = 0
        )
      ),
      tickLength = 0,
      title = list(text = "Return on investment"),
      labels = list(
        format = "{text}%"
      )
    )


}


viz_placeholder_hist <- function(...){

  df <- data.frame(
    x = seq(-10, 10, by = .1),
    y = dnorm(seq(-10, 10, by = .1), mean = 5, sd = 3)
  )

  hchart(df, "area", hcaes(x, y), color = "#00573F") %>%
    hc_plotOptions(
      series = list(
        opacity = 0.35,
        enableMouseTracking = FALSE,
        states = list(
          inactive = list(
            opacity = 1
          )
        )
      )
    ) %>%
    hc_yAxis(
      visible = FALSE
    ) %>%
    ag_chart() %>%
    hc_xAxis(
      tickLength = 0,
      title = list(enabled = FALSE),
      plotLines = list(
        list(
          dashStyle = "Dash",
          value = 0
        )
      ),
      labels = list(
        enabled = FALSE
      )
    ) %>%
    hc_annotations(
      list(
        draggable = "",
        labels = list(
          list(
            backgroundColor = "#FFFFFF80",
            borderColor = "#FFFFFF00",
            shape = 'rect',
            point = list(x = 0, y = 0.07, xAxis = 0, yAxis = 0),
            text = "<b>Use the uncertainty switch to estimate</br>probability of positive returns</b>",
            style = list(
              `font-size` = "3rem",
              color = "#000000",
              `text-align` = "center"
              )
            )
        )
      )
    )
}

uncertainty_card <- function(simulation_data){

  if(is.null(simulation_data)) return(
    div(
      class = "card h-100",
      div(
        class = "card-header",
        tags$b("Uncertainty content")
      ),
      div(
        class = "card-body h-100",
        p(
          "When uncertainty information in entered using the top right",
          "toggle, this analysis will perform 5000 simualtions of possible",
          "returns on investment, allowing businesses to guage likelyhood",
          "of posititive returns."
        )
      )
    )
  )

  roi_dist <- simulation_data$roi
  roi_prob <- round(sum(roi_dist > 0) * 100 / length(roi_dist))

  uncertainty_header <- fcase(
    all(roi_dist == 0), "Something doesn't look right...",
    all(roi_dist >= 0), "Very high probability of positive returns",
    all(roi_dist <= 0), "Very high probability of negative returns",
    roi_prob >= 70, "High probability of positive returns",
    roi_prob <= 30, "High probability of negative returns",
    TRUE, "Moderate probability of positive returns"
  )

  uncertainty_header_class <- fcase(
    all(roi_dist == 0), "card-header text-white bg-warning",
    all(roi_dist >= 0), "card-header text-white bg-success",
    all(roi_dist <= 0), "card-header text-white bg-danger",
    roi_prob >= 70, "card-header text-white bg-success",
    roi_prob <= 30, "card-header text-white bg-danger",
    TRUE, "card-header"
  )

  uncertainty_text <- fcase(
    all(roi_dist == 0), "All 5000 simulation runs returned 0% discounted return on investment.",
    all(roi_dist >= 0), "All 5000 simulation runs returned a positive discounted return on investment, suggesting a very high likelyhood of positive returns.",
    all(roi_dist <= 0), "All 5000 simulation runs returned a negative discounted return on investment, suggesting a very high likelyhood of negative returns.",
    roi_prob >= 70, paste0(roi_prob, "% of 5000 simulation runs returned a positive discounted return on investment, suggesting a good chance of positive return on investment."),
    roi_prob <= 30, paste0(roi_prob, "% of 5000 simulation runs returned a positive discounted return on investment, suggesting a poor chance of positive return on investment."),
    TRUE, paste0(roi_prob, "% of 5000 simulation runs returned a positive discounted return on investment.")
  )

  out <- div(
    class = "card h-100",
    div(
      class = uncertainty_header_class,
      tags$b(uncertainty_header)
    ),
    div(
      class = "card-body h-100",
      p(
        "Using uncertainty input information, this analysis ran 5000",
        "simualtions of possible returns on investment.",
        uncertainty_text
      )
    )
  )

  return(out)

}

