#################################
# UI
radiacionUI <- function(id) {
  ns <- NS(id)
  
  
  
  tagList(
    tags$h1("Radiación solar"),
    
<<<<<<< HEAD
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
=======
    navlistPanel(
      widths = c(3, 9),
      tabPanel(
        "info",
        tags$iframe(style = "height:800px; width:100%; scrolling=yes",
                    src = "./radiacion/radiacion.png")
      ),
      "Atlas de energia solar",
      "Radiacíon solar promedio mensual y anual de la pampa húmeda",
      "",
      tabPanel(
        "Enero",
        "RD_promedio_Enero.png",
        tags$iframe(style = "height:800px; width:100%; scrolling=yes",
                    src = "./radiacion/RD_promedio_Enero.png")
      ),
      tabPanel(
        "Febrero",
        "RD_promedio_Febrero.png",
        tags$iframe(style = "height:800px; width:100%; scrolling=yes",
                    src = "./radiacion/RD_promedio_Febrero.png")
      ),
      tabPanel(
        "Marzo",
        "RD_promedio_Marzo.png",
        tags$iframe(style = "height:800px; width:100%; scrolling=yes",
                    src = "./radiacion/RD_promedio_Marzo.png")
      ),
      tabPanel(
        "Abril",
        "RD_promedio_Abril.png",
        tags$iframe(style = "height:800px; width:100%; scrolling=yes",
                    src = "./radiacion/RD_promedio_Abril.png")
      ),
      tabPanel(
        "Mayo",
        "RD_promedio_Mayo.png",
        tags$iframe(style = "height:800px; width:100%; scrolling=yes",
                    src = "./radiacion/RD_promedio_Mayo.png")
      ),
      tabPanel(
        "Junio",
        "RD_promedio_Junio.png",
        tags$iframe(style = "height:800px; width:100%; scrolling=yes",
                    src = "./radiacion/RD_promedio_Junio.png")
      ),
      tabPanel(
        "Julio",
        "RD_promedio_Julio.png",
        tags$iframe(style = "height:800px; width:100%; scrolling=yes",
                    src = "./radiacion/RD_promedio_Julio.png")
      ),
      tabPanel(
        "Agosto",
        "RD_promedio_Agosto.png",
        tags$iframe(style = "height:800px; width:100%; scrolling=yes",
                    src = "./radiacion/RD_promedio_Agosto.png")
      ),
      tabPanel(
        "Septiembre",
        "RD_promedio_Septiembre.png",
        tags$iframe(style = "height:800px; width:100%; scrolling=yes",
                    src = "./radiacion/RD_promedio_Septiembre.png")
      ),
      tabPanel(
        "Octubre",
        "RD_promedio_Octubre.png",
        tags$iframe(style = "height:800px; width:100%; scrolling=yes",
                    src = "./radiacion/RD_promedio_Octubre.png")
      ),
      tabPanel(
        "Noviembre",
        "RD_promedio_Noviembre.png",
        tags$iframe(style = "height:800px; width:100%; scrolling=yes",
                    src = "./radiacion/RD_promedio_Noviembre.png")
      ),
      tabPanel(
        "Diciembre",
        "RD_promedio_Diciembre.png",
        tags$iframe(style = "height:800px; width:100%; scrolling=yes",
                    src = "./radiacion/RD_promedio_Diciembre.png")
      ),
      tabPanel(
        "ANUAL",
        "RD_promedio_Anual.png",
        tags$iframe(style = "height:800px; width:100%; scrolling=yes",
                    src = "./radiacion/RD_promedio_Anual.png")
      ),
      
      
      "Mapas de radiacón solar mensual",
      
      tabPanel(
        "AÑO 2021",
        "Radiacion_solar_Agosto_2021.jpg",
        tags$iframe(style = "height:800px; width:100%; scrolling=yes",
                    src = "./radiacion/Radiacion_solar_Agosto_2021.jpg")
      )
      
>>>>>>> 3481b1015dc0b555aacb564ca8128aa11fcc1e35
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
