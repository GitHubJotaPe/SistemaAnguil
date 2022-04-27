#################################
# UI
radarUI <- function(id) {
  ns <- NS(id)
  
  tagList(tags$h1("radar 2"),
          tags$h4("radar"))
}

#################################
# SERVER
radarServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 
               })
}
