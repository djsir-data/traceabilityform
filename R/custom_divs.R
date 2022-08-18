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
