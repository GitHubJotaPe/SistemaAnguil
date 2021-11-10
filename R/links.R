#################################
# UI
linksUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    tags$h1("Links"),
    tags$h4(
      "link donde los usuarios puedan acceder a la información que muestran estas estaciones automáticas (que se actualizan cada 10 minutos)."
    ),
    tags$a("Pagina INTA - Anguil", href = "https://inta.gob.ar/anguil", target =
             "_blank")
  )
}

#################################
# SERVER
linksServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 
               })
}
