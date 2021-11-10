#################################
# UI
eventosUI <- function(id) {
  ns <- NS(id)

  tagList(
    tags$h1("eventos"),
    tags$h4("eventos")
  )
}

#################################
# SERVER
eventosServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 
               })
}
