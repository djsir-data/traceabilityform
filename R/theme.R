ag_chart <- function(hc){

  highcharter::hc_add_theme(
    hc,
    highcharter::hc_theme(
      chart = list(
        backgroundColor = NULL,
        style = list(
          fontFamily = "VIC-Regular",
          `font-size` = "var(--bs-body-font-size)",
          color = "#000000"
        )
      ),
      title = list(
        align = "left",
        style = list(
          color = "#000000",
          fontFamily = "VIC-Regular",
          `font-weight` =  "bold",
          `font-size` = "2rem",
          `background-color` = "#000000"
        )
      ),
      subtitle = list(
        align = "left",
        style = list(
          color = "#000000",
          fontFamily = "VIC-Regular",
          `font-size` = "var(--bs-body-font-size)"
        )
      ),
      xAxis = list(
        labels = list(
          style = list(
            color = "#000000",
            `font-size` = "var(--bs-body-font-size)"
          )
        ),
        title = list(style = list(color = "#000000", `font-weight` =  "bold")),
        lineWidth = 3,
        lineColor = "#000000",
        tickPosition = "inside",
        tickColor = "#000000",
        tickWidth = 3,
        tickLength = 7
      ),
      yAxis = list(
        labels = list(
          style = list(
            color = "#000000",
            `font-size` = "var(--bs-body-font-size)"
          ),
          y = 5
        ),
        title = list(style = list(color = "#000000", `font-weight` =  "bold")),
        minorGridLineWidth = 0,
        lineWidth = 3,
        lineColor = "#000000",
        gridLineColor = "transparent",
        opposite = FALSE
      ),
      caption = list(
        style = list(
          color = "#000000"
        )
      ),
      series = list(
        line = list(lineWidth = 4),
        spline = list(lineWidth = 4)
      )
    )
  )

}


hc_axis_label_dollars <- highcharter::JS(
  "
  function(){
    const sign = (this.value < 0 ? '-' : '');
    return sign + '$'+ Highcharts.numberFormat(Math.abs(this.value), 0);
  }
  "
)
