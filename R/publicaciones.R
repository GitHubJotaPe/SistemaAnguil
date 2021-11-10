#################################
# UI
publicacionesUI <- function(id) {
  ns <- NS(id)
  
  tagList(
    tags$h1("Informes y publicaciones"),
    
    navlistPanel(
      "Informe de evaluación de cultivos",
      tabPanel(
        "Febrero 2021",
        "Informe de FEBRERO.pdf",
        tags$iframe(style = "height:800px; width:100%; scrolling=yes",
                    src = "./informes/Informe de FEBRERO.pdf")
      ),
      tabPanel(
        "Marzo 2021",
        "Informe de MARZO.pdf",
        tags$iframe(style = "height:800px; width:100%; scrolling=yes",
                    src = "./informes/Informe de MARZO.pdf")
      ),
      tabPanel(
        "Junio 2021",
        "Informe de JUNIO.pdf",
        tags$iframe(style = "height:800px; width:100%; scrolling=yes",
                    src = "./informes/Informe de JUNIO.pdf")
      ),
      
      "Publicaciones climáticas",
      
      tabPanel(
        "Precipitaciones de General Acha",
        "inta_analisis_de_precipitaciones_gralacha.pdf",
        tags$iframe(style = "height:800px; width:100%; scrolling=yes",
                    src = "./informes/inta_analisis_de_precipitaciones_gralacha.pdf")
      ),
      tabPanel(
        "Cambio climático en Anguil",
        "inta_belmonte_indices_de_cambio_climatico_en_anguil_0.pdf",
        tags$iframe(style = "height:800px; width:100%; scrolling=yes",
                    src = "./informes/inta_belmonte_indices_de_cambio_climatico_en_anguil_0.pdf")
      ),
      tabPanel(
        "Estadísticas agroclimáticasde la EEA Anguil",
        "inta_estadisticas_agroclimaticas_eea_anguil.pdf",
        tags$iframe(style = "height:800px; width:100%; scrolling=yes",
                    src = "./informes/inta_estadisticas_agroclimaticas_eea_anguil.pdf")
      ),
      tabPanel(
        "Caracterización agroclimática de las heladas en Anguil",
        "inta_pt_100_heladas_0.pdf",
        tags$iframe(style = "height:800px; width:100%; scrolling=yes",
                    src = "./informes/inta_pt_100_heladas_0.pdf")
      ),
      tabPanel(
        "Síntesis agrometeorológica de 25 de Mayo, La",
        "inta_sintesis_agrometeorologica_25_de_mayo.pdf",
        tags$iframe(style = "height:800px; width:100%; scrolling=yes",
                    src = "./informes/inta_sintesis_agrometeorologica_25_de_mayo.pdf")
      ),
      tabPanel(
        "CARACTERIZACION DEL REGIMEN DE HELADAS EN GENERAL PICO",
        "script-tmp-inta-caracterizacin-del-rgimen-de-heladas-en-general-.pdf",
        tags$iframe(style = "height:800px; width:100%; scrolling=yes",
                    src = "./informes/script-tmp-inta-caracterizacin-del-rgimen-de-heladas-en-general-.pdf")
      ),
      tabPanel(
        "VARIABLES ASTRONÓMICAS LOCALIDADES DE LA PAMPA",
        "variables_astronomicas_la_pampa.pdf",
        tags$iframe(style = "height:800px; width:100%; scrolling=yes",
                    src = "./informes/variables_astronomicas_la_pampa.pdf")
      )
      
    )
    
  )
}

#################################
# SERVER
publicacionesServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 
               })
}
