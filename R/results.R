

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

  # Collapse crisis costs
  crisis[, c("variable", "measure", "time") := tstrsplit(variable, split = "_")]
  crisis <- dcast(crisis, variable + measure ~ time, value.var = "expected")
  crisis <- crisis[, .(new = prod(new), old = prod(old)), variable]
  crisis <- crisis[,
    .(
      group = "Crisis management",
      flow = ifelse(sum(old - new) >= 0, "Ongoing benefit", "Ongoing cost"),
      expected = abs(sum(old - new)) / 5
      )
  ]

  # Bind crisis back in
  input_set <- rbindlist(list(input_set, crisis), fill = TRUE)

  # Summarise
  input_set <- input_set[, .(value = sum(expected)), keyby = .(flow, group)]

  # Return table
  return(input_set)

}


html_summ_table <- function(summ_data, discount_rate, n_years){

  # Ensure we're not editing summary data
  summ_data <- copy(summ_data)

  # Generate totals
  ongoing_benefits <- summ_data[flow == "Ongoing benefit", sum(value)]
  ongoing_costs    <- summ_data[flow == "Ongoing cost",    sum(value)]
  upfront_costs    <- summ_data[flow == "Upfront cost",    sum(value)]

  # Change discount rate to decimal
  discount_rate <- discount_rate / 100

  # Discounting function
  discount <- function(x) x * (1 - ( 1 + discount_rate) ^ (-n_years)) / discount_rate
  # discount_v <- function(x) x * (1 - ( 1 + discount_rate) ^ (-1:(-n_years))) / discount_rate

  # Totals
  total_dollar <- round(
    discount(ongoing_benefits) -
      upfront_costs -
      discount(ongoing_costs)
  )

  total_roi <- round(
    discount(ongoing_benefits) /
      (upfront_costs + discount(ongoing_costs)) - 1,
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
        scientific = FALSE,
      ),
      text_class = ifelse(
        flow == "Ongoing benefits",
        "text-success",
        "text-danger"
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
        tags$td(x["prefix"], class = x["text_class"], style = pre_col_css),
        # Value col
        tags$td(x["value"], class = x["text_class"], style = val_col_css),
        # Suffix column
        tags$td(HTML(x["suffix"]), class = x["text_class"], style = suf_col_css)
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
  total_row_class <- ifelse(total_dollar >= 0, "table-success", "table-danger")

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
      # class = total_row_class,
      tags$td("Discounted return on investment", style = group_col_css),
      tags$td(ifelse(total_roi > 0, "+ ", "- "), style = pre_col_css),
      tags$td(format(total_roi, big.mark = ","), style = val_col_css),
      tags$td("%", style = suf_col_css)
    ),
    tags$tr(
      # class = total_row_class,
      style = "border-bottom: thick double;",
      tags$td("Discounted returns", style = group_col_css),
      tags$td(ifelse(total_dollar > 0, "+$", "-$"), style = pre_col_css),
      tags$td(format(total_dollar, big.mark = ","), style = val_col_css),
      tags$td("", style = suf_col_css)
    )
  )

  # Generate table
  tags$table(
    class = "table table-borderless table-hover",
    tags$thead(),
    tags$tbody(
      lapply(names(flows), table_flow),
      total_rows
    )
  )


}


