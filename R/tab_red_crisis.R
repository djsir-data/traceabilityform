tab_red_crisis <- function(...) tabPanel(
  title = 'Crisis management',
  value = 'red_crisis',
  h2('Reduced crisis costs'),
  p(
    "Lorem ipsum dolor sit amet, consectetur adipiscing elit, sed do eiusmod tempor incididunt ut labore et dolore magna aliqua. Ut enim ad minim veniam, quis nostrud exercitation ullamco laboris nisi ut aliquip ex ea commodo consequat. Duis aute irure dolor in reprehenderit in voluptate velit esse cillum dolore eu fugiat nulla pariatur. Excepteur sint occaecat cupidatat non proident, sunt in culpa qui officia deserunt mollit anim id est laborum."
  ),
  h3("Claims/lawsuits"),
  input_row("claims_dollar_old", "Current claim cost", "dollar", "always"),
  input_row("claims_time_old", "Expected No. claims", "number", "always"),

  input_row("claims_dollar_new", "Claim cost with traceability", "dollar", "always"),
  input_row("claims_time_new", "No. claims with traceability", "number", "always"),

  h3("Recalls"),
  input_row("recalls_dollar_old", "Current cost of recall", "dollar", "always"),
  input_row("recalls_time_old", "Expected No. recalls", "number", "always"),

  input_row("recalls_dollar_new", "Recall cost with traceability", "dollar", "always"),
  input_row("recalls_time_new", "No. recalls with traceability", "number", "always"),

  h3("Biosecurity"),
  input_row("bio_dollar_old", "Current cost of outbreak", "dollar", "always"),
  input_row("bio_time_old", "Expected No. outbreaks", "number", "always"),

  input_row("bio_dollar_new", "Outbreak cost with traceability", "dollar", "always"),
  input_row("bio_time_new", "No. outbreaks with traceability", "number", "always"),

  h3("Weather & nautural disasters"),
  input_row("weather_dollar_old", "Current cost of disaster", "dollar", "always"),
  input_row("weather_time_old", "Expected No. disasters", "number", "always"),

  input_row("weather_dollar_new", "Disaster cost with traceability", "dollar", "always"),
  input_row("weather_time_new", "No. disasters with traceability", "number", "always")

)
