#################################
# UI
estadisticasAnguilUI <- function(id) {
  ns <- NS(id)
  
  tagList(tags$h1("Estadisticas Anguil"))
}

#################################
# SERVER
estadisticasAnguilServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 
               })
}
