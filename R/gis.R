#################################
# UI
gisUI <- function(id) {
  ns <- NS(id)

  tagList(
    tags$h1("gis"),
    tags$h4("gis")
  )
}

#################################
# SERVER
gisServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 
               })
}
