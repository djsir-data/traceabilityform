
basic_content <- function(..., border = FALSE){
  div(
    class = if(border == FALSE){
      "basicContent"
    } else {
      c("basicContent", "bordered")
    },
    ...
  )
}

advanced_content <- function(..., border = FALSE){
  div(
    class = if(border == FALSE){
      "advancedContent"
      } else {
        c("advancedContent", "bordered")
      },
    ...
  )
}

uncertainty_content <- function(..., border = FALSE){
  div(
    class = if(border == FALSE){
      "uncertaintyContent"
    } else {
      c("uncertaintyContent", "bordered")
    },
    ...
  )
}

basic_uncertainty_content <- function(..., border = FALSE){
  div(
    class = if(border == FALSE){
      "basicUncertaintyContent"
    } else {
      c("basicUncertaintyContent", "bordered")
    },
    ...
  )
}

advanced_uncertainty_content <- function(..., border = FALSE){
  div(
    class = if(border == FALSE){
      "advancedUncertaintyContent"
    } else {
      c("advancedUncertaintyContent", "bordered")
    },
    ...
  )
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

