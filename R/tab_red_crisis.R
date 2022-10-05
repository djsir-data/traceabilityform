tab_red_crisis <- function(...) tabPanel(
  title = 'Crisis management',
  value = 'red_crisis',
  h2('Reduced crisis costs'),
  p(
    "This page estimates how traceability may help in various crisis",
    "situations, including lawsuits, recalls, biosecurity emergencies and ",
    "natural disasters. For each category of crisis, this page will ask for",
    "how many times you expect a crisis to occur",
    tags$strong(class = "text-decoration-underline", "over a five year period"),
    "and how much you expect each crisis to cost your business in dollars."
  ),
  h3("Claims/lawsuits"),
  input_row("claims_dollar_old", "Current claim cost", "dollar", "always"),
  input_row("claims_time_old", "Expected number of claims", "number", "always"),

  input_row("claims_dollar_new", "Claim cost with traceability", "dollar", "always"),
  input_row("claims_time_new", "number of claims with traceability", "number", "always"),

  h3("Recalls"),
  input_row("recalls_dollar_old", "Current cost of recall", "dollar", "always"),
  input_row("recalls_time_old", "Expected number of recalls", "number", "always"),

  input_row("recalls_dollar_new", "Recall cost with traceability", "dollar", "always"),
  input_row("recalls_time_new", "number of recalls with traceability", "number", "always"),

  h3("Biosecurity"),
  input_row("bio_dollar_old", "Current cost of outbreak", "dollar", "always"),
  input_row("bio_time_old", "Expected number of outbreaks", "number", "always"),

  input_row("bio_dollar_new", "Outbreak cost with traceability", "dollar", "always"),
  input_row("bio_time_new", "number of outbreaks with traceability", "number", "always"),

  h3("Weather & natural disasters"),
  input_row("weather_dollar_old", "Current cost of disaster", "dollar", "always"),
  input_row("weather_time_old", "Expected number of disasters", "number", "always"),

  input_row("weather_dollar_new", "Disaster cost with traceability", "dollar", "always"),
  input_row("weather_time_new", "number of disasters with traceability", "number", "always")

)
