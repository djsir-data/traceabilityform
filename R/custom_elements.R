
# Helper function for creating standard input rows
input_row <- function(
    inputId,
    label,
    input_type = "percent",
    content_type = "always",
    uncertainty_label = NULL,
    grid_size = "md",
    col_width = 4
){

  # Determine row classes to apply
  row_classes <- switch(
    content_type,
    always   = "row",
    basic    = c("row", "basicContent"),
    advanced = c("row", "advancedContent"),
    stop("content_type must be one of always, basic or advanced")
  )

  # Determine input function
  input_fun <- switch(
    input_type,
    percent = percentInput,
    dollar  = dollarInput,
    number = novalNumericInput,
    claims  = function(inputId, label, width) suffixNumericInput(inputId, label, "Claims", width = width),
    recalls  = function(inputId, label, width) suffixNumericInput(inputId, label, "Recalls", width = width),
    outbreaks  = function(inputId, label, width) suffixNumericInput(inputId, label, "Outbreaks", width = width),
    disasters  = function(inputId, label, width) suffixNumericInput(inputId, label, "Distasters", width = width),
    stop("input_type not recognised")
  )

  # Determine input range function to use (for uncertainty)
  input_range_fun <- switch(
    input_type,
    percent = percentRangeInput,
    dollar  = dollarRangeInput,
    number = novalRangeInput,
    claims  = function(inputId, label, width) suffixRangeInput(inputId, label, "Claims", width = width),
    recalls  = function(inputId, label, width) suffixRangeInput(inputId, label, "Recalls", width = width),
    outbreaks  = function(inputId, label, width) suffixRangeInput(inputId, label, "Outbreaks", width = width),
    disasters  = function(inputId, label, width) suffixRangeInput(inputId, label, "Distasters", width = width),
    stop("input_type must be one of percent, dollar")
  )

  # determine column class
  col_class <- paste0("col-", grid_size, "-", col_width)

  # Determine labels for uncertainty content (if different to main input)
  if(!is.null(uncertainty_label)){
    label_range       <- paste0(uncertainty_label, " range")
    label_uncertainty <- paste0(uncertainty_label, " certainty")
  } else {
    label_range       <- paste0(label, " range")
    label_uncertainty <- paste0(label, " certainty")
  }

  # Generate content
  row_content <- div(
    class = row_classes,
    # Main input
    div(
      class = col_class,
      input_fun(
        inputId = inputId,
        label = label,
        width = "100%"
      )
    ),
    # Uncertainty content
    div(
      class = c(col_class, "uncertaintyContent"),
      input_range_fun(
        inputId = paste0(inputId, "-range"),
        label = label_range,
        width = "100%"
      )
    ),
    div(
      class = c(col_class, "uncertaintyContent"),
      radioGroupButtons(
        inputId = paste0(inputId, "-uncertainty"),
        label = label_uncertainty,
        choices = c("High", "Medium", "Low"),
        status = "primary",
        justified  = TRUE
      )
    )
  )

}

input_row_set <- function(
    inputIds,
    labels,
    input_type = "percent",
    content_type = "advanced"
){
  mapply(
    input_row,
    inputId = inputIds,
    label = labels,
    input_type = input_type,
    content_type = content_type,
    SIMPLIFY = FALSE
  )
}


# Numeric input with no default
novalNumericInput <- function(
    inputId,
    label,
    value = NULL,
    min = NA,
    max = NA,
    step = NA,
    width = NULL
){
  input <- numericInput(
    inputId = inputId,
    label  = label,
    value = if(is.null(value)) {0} else {value},
    min = min,
    max = max,
    step = step,
    width = width
  )

  # Remove mandatory default value
  if(is.null(value)){input$children[[2]]$attribs$value <- NULL}

  return(input)
}



# Input with dollar prefix
dollarInput <- function(
    inputId,
    label,
    value = NULL,
    min = NA,
    max = NA,
    step = NA,
    width = NULL,
    suffix00 = FALSE
    ){

  input <- numericInput(
    inputId = inputId,
    label  = label,
    value = if(is.null(value)) {0} else {value},
    min = min,
    max = max,
    step = step,
    width = width
  )

  # Remove mandatory default value
  if(is.null(value)){input$children[[2]]$attribs$value <- NULL}

  # Add prefix and suffix
  input$children[[2]] <- div(
    class = "input-group",
    span(class="input-group-text", "$"),
    input$children[[2]],
    if(suffix00) {span(class="input-group-text", ".00")} else {NULL}
  )

  return(input)
}


# Percent input
percentInput <- function(
    inputId,
    label,
    value = NULL,
    min = NA,
    max = NA,
    step = NA,
    width = NULL
){

  input <- numericInput(
    inputId = inputId,
    label  = label,
    value = if(is.null(value)) {0} else {value},
    min = min,
    max = max,
    step = step,
    width = width
  )

  # Remove mandatory default value
  if(is.null(value)){input$children[[2]]$attribs$value <- NULL}

  # Add prefix and suffix
  input$children[[2]] <- div(
    class = "input-group",
    input$children[[2]],
    span(class="input-group-text", "%")
  )

  return(input)
}


# Suffix input
suffixNumericInput <- function(
    inputId,
    label,
    suffix,
    value = NULL,
    min = NA,
    max = NA,
    step = NA,
    width = NULL
){

  input <- numericInput(
    inputId = inputId,
    label  = label,
    value = if(is.null(value)) {0} else {value},
    min = min,
    max = max,
    step = step,
    width = width
  )

  # Remove mandatory default value
  if(is.null(value)){input$children[[2]]$attribs$value <- NULL}

  # Add prefix and suffix
  input$children[[2]] <- div(
    class = "input-group",
    input$children[[2]],
    span(class="input-group-text", suffix),
  )

  return(input)
}

# Dollar range input
dollarRangeInput <- function(
    inputId,
    label,
    value = NULL,
    width = NULL,
    separator = " to $",
    min = NA,
    max = NA,
    step = NA,
    suffix00 = FALSE
){

  input <- numericRangeInput(
    inputId = inputId,
    label  = label,
    value = if(is.null(value)) {0} else {value},
    separator = separator,
    min = min,
    max = max,
    step = step,
    width = width
  )

  # Remove mandatory default value
  if(is.null(value)){
    input$children[[2]]$children[[1]]$attribs$value <- NULL
    input$children[[2]]$children[[3]]$attribs$value <- NULL
  }

  # Add prefix and suffix
  input$children[[2]]$children <- list(
    span(class="input-group-text", "$"),
    input$children[[2]]$children[[1]],
    input$children[[2]]$children[[2]],
    input$children[[2]]$children[[3]],
    if(suffix00) {span(class="input-group-text", ".00")} else {NULL}
  )

  return(input)
}

# Percent range input
percentRangeInput <- function(
    inputId,
    label,
    value = NULL,
    width = NULL,
    separator = "% to ",
    min = NA,
    max = NA,
    step = NA
){

  input <- numericRangeInput(
    inputId = inputId,
    label  = label,
    value = if(is.null(value)) {0} else {value},
    separator = separator,
    min = min,
    max = max,
    step = step,
    width = width
  )

  # Remove mandatory default value
  if(is.null(value)){
    input$children[[2]]$children[[1]]$attribs$value <- NULL
    input$children[[2]]$children[[3]]$attribs$value <- NULL
  }

  # Add prefix and suffix
  input$children[[2]]$children <- list(
    input$children[[2]]$children[[1]],
    input$children[[2]]$children[[2]],
    input$children[[2]]$children[[3]],
    span(class="input-group-text", "%")
  )

  return(input)
}

# Custom suffix range input
suffixRangeInput <- function(
    inputId,
    label,
    suffix,
    value = NULL,
    width = NULL,
    separator = " to ",
    min = NA,
    max = NA,
    step = NA
){

  separator <- paste0(suffix, separator)

  input <- numericRangeInput(
    inputId = inputId,
    label  = label,
    value = if(is.null(value)) {0} else {value},
    separator = separator,
    min = min,
    max = max,
    step = step,
    width = width
  )

  # Remove mandatory default value
  if(is.null(value)){
    input$children[[2]]$children[[1]]$attribs$value <- NULL
    input$children[[2]]$children[[3]]$attribs$value <- NULL
  }

  # Add prefix and suffix
  input$children[[2]]$children <- list(
    input$children[[2]]$children[[1]],
    input$children[[2]]$children[[2]],
    input$children[[2]]$children[[3]],
    span(class="input-group-text", suffix)
  )

  return(input)
}

# Range input with no default
novalRangeInput <- function(
    inputId,
    label,
    value = NULL,
    width = NULL,
    separator = " to ",
    min = NA,
    max = NA,
    step = NA
){

  input <- numericRangeInput(
    inputId = inputId,
    label  = label,
    value = if(is.null(value)) {0} else {value},
    separator = separator,
    min = min,
    max = max,
    step = step,
    width = width
  )

  # Remove mandatory default value
  if(is.null(value)){
    input$children[[2]]$children[[1]]$attribs$value <- NULL
    input$children[[2]]$children[[3]]$attribs$value <- NULL
  }


  return(input)
}
