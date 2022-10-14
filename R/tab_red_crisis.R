tab_red_crisis <- function(...) tabPanel(
  title = 'Crisis management',
  value = 'red_crisis',
  h2('Reduced crisis costs'),
  p("Could a traceability system assist your business during a crisis?"),
  p(
    "This section estimates how an effective traceability system may assist
    during a crisis. Benefits may include a quicker response time during a food
    safety recall or the ability to generate more detailed reports."
  ),
  p(
    "For each category, input: ",
    tags$ul(
      tags$li(
        "how many times you expect a crisis to occur",
        tags$strong(
          class = "text-decoration-underline",
          "over a five year period"
          )
      ),
      tags$li(
        "how much you expect each crisis to cost your business in dollars."
      )
    )
   ),
  br(),
  tags$i(
    "Tip:",
    "Use the ‘uncertainty’ switch to include expected claim range and the
    certainty level of each event occurring."
  ),
  br(),
  br(),

  h3("Claims/lawsuits"),
  input_row("claims_dollar_old", "Current claim cost", "dollar", "always"),
  input_row("claims_time_old", "Expected number of claims", "number", "always"),

  input_row("claims_dollar_new", "Claim cost with traceability", "dollar", "always"),
  input_row("claims_time_new", "Number of claims with traceability", "number", "always"),

  h3("Recalls"),
  input_row("recalls_dollar_old", "Current cost of recall", "dollar", "always"),
  input_row("recalls_time_old", "Expected number of recalls", "number", "always"),

  input_row("recalls_dollar_new", "Recall cost with traceability", "dollar", "always"),
  input_row("recalls_time_new", "Number of recalls with traceability", "number", "always"),

  h3("Biosecurity"),
  input_row("bio_dollar_old", "Current cost of outbreak", "dollar", "always"),
  input_row("bio_time_old", "Expected number of outbreaks", "number", "always"),

  input_row("bio_dollar_new", "Outbreak cost with traceability", "dollar", "always"),
  input_row("bio_time_new", "Number of outbreaks with traceability", "number", "always"),

  h3("Weather & natural disasters"),
  input_row("weather_dollar_old", "Current cost of disaster", "dollar", "always"),
  input_row("weather_time_old", "Expected number of disasters", "number", "always"),

  input_row("weather_dollar_new", "Disaster cost with traceability", "dollar", "always"),
  input_row("weather_time_new", "Number of disasters with traceability", "number", "always")

)
