table_dollar <- function(x, prefix = "$", suffix = ""){
  sign <- ifelse(x > 0, "+", "-")
  is_0 <- x == 0

  x <- format(
    abs(x),
    digits = 1L,
    big.mark = ",",
    justify = "right",
    scientific = FALSE,
  )
  x <- paste0(sign, prefix, x, suffix)
  x <- gsub(" ", "&nbsp;", x)
  x[is_0] <- "-"
  return(x)
}

table_percent <- function(x, prefix = "", suffix = "%"){
  sign <- ifelse(x > 0, "+", "-")
  is_0 <- x == 0

  x <- format(
    abs(x),
    digits = 1L,
    big.mark = ",",
    justify = "right",
    scientific = FALSE
  )
  x <- paste0(sign, prefix, x, suffix)
  x <- gsub(" ", "&nbsp;", x)
  x[is_0] <- "-"
  return(x)
}
