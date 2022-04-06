#################################
# UI
radiacionUI <- function(id) {
  ns <- NS(id)
  
  
  
  tagList(
    tags$h1("Radiación solar"),
    
    sidebarLayout(
      sidebarPanel(
        
        radioGroupButtons(
          inputId = "inGB1",
          label = "Irradiación diaria promedio mensual",
          choices = c(meses),
          direction = "horizontal",
          individual = TRUE
        ),
        
        "------------------",
        
        radioGroupButtons(
          inputId = "inGB2",
          label = "Irradiación diaria promedio mensual",
          choices = c(meses),
          direction = "vertical",
          individual = FALSE
        ),
        
        "------------------",
        
        selectInput(ns('inAnio'),
                    'AÑO',
                    choices = c("2022",
                                "2021",
                                "2020")),
        selectInput(ns('inMes'),
                    'MES',
                    choices = c(meses)),
        selectInput(
          ns('inX'),
          'ÍTEM',
          choices = c(
            "1Q" = "1Q",
            "2Q" = "2Q",
            "Acumulado" = "TOT",
            "Anomalias" = "ANOM"
          )
        )
      ),
      mainPanel(mainPanel(uiOutput(ns("imagen_radiacion")))
                )
    )
      
    
    
  )
}

#################################
# SERVER
radiacionServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 
                 output$imagen_radiacion <- renderUI({
                   ns <- session$ns
                   
                   src <- archivos_sequia %>%
                     str_subset(input$inAnioRad) %>%
                     str_subset(input$inMesRad)
                   
                   if (identical(src, character(0))) {
                     HTML('<h2 style="color: red;">No hay imagen para el periodo seleccionado</h2>')
                   } else {
                     src <- paste0("./sequias/", src)
                     img(src = src, width = "100%")
                   }
                 })
                 
               })
}
