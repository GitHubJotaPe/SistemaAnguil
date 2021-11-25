# Listado de los nombres de los archivos (imagenes, pdf's, etc)
archivos_precip <-
  list.files("./www/precipitaciones/", recursive = TRUE)

archivos_sequia <- list.files("./www/sequias/", pattern = "^SP3")

archivos_heladas <-
  list.files("./www/heladas/", pattern = "^HELADAS", recursive = TRUE)

fechas_heladas <-
  as.Date(str_sub(archivos_heladas, start = -13, end = -6), format = "%d%m%Y")

# ordenado
fechas_heladas <- sort(fechas_heladas)

dias <- seq(from = as.Date("2021/7/1"),
            to = Sys.Date(),
            by = "day")

sacar_fechas <- dias[!(dias %in% fechas_heladas)]

#################################
# UI
cartografiaUI <- function(id) {
  ns <- NS(id)
  
  tabsetPanel(
    type = "pills",
    #: tabs” o “pills”
    tabPanel(
      "Precipitaciones",
      sidebarLayout(
        sidebarPanel(
          selectInput(ns('inAnio'),
                      'AÑO',
                      choices = c(#"PP_LAPAMPA_1Q_NOVIEMBRE.jpeg",
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
        mainPanel(textOutput(ns("salida")),
                  uiOutput(ns("imagen_1")))
      )
    ),
    
    tabPanel(
      "Índices de sequía",
      sidebarLayout(sidebarPanel(
        selectInput(
          ns('inImgSeq'),
          'Seleccione imagen',
          choices = c(archivos_sequia)
        )
        
      ),
      mainPanel(uiOutput(ns(
        "imagen_2"
      ))))
    ),
    
    tabPanel("Mapas de heladas",
             sidebarLayout(
               sidebarPanel(
                 dateInput(
                   ns("inImgHeladas"),
                   "Seleccione fecha:",
                   language = "es",
                   min = "2021-07-01",
                   #desde
                   max = Sys.Date(),
                   #hasta
                   value = tail(fechas_heladas, 1),
                   #de arranque, ultimo dia con heleada
                   datesdisabled = sacar_fechas # se sacan las fechas que no tengan heladas
                 )
               ),
               mainPanel(uiOutput(ns("imagen_3")))
             ))
    ,
    
    tabPanel(
      "Promedios históricos de precipitación en la provincia de La Pampa",
      navlistPanel(
        #"Informes mensuales",
        tabPanel(
          "MAPA 1",
          "inta-mapa-precipitaciones-la-pampa-1.pdf",
          tags$iframe(style = "height:800px; width:100%; scrolling=yes",
                      src = "./precipitaciones/inta-mapa-precipitaciones-la-pampa-1.pdf")
        ),
        tabPanel(
          "MAPA 2",
          "inta-mapa-precipitaciones-la-pampa-2.pdf",
          tags$iframe(style = "height:800px; width:100%; scrolling=yes",
                      src = "./precipitaciones/inta-mapa-precipitaciones-la-pampa-2.pdf")
        ),
        tabPanel(
          "MAPA 3",
          "inta-mapa-precipitaciones-la-pampa-3.pdf",
          tags$iframe(style = "height:800px; width:100%; scrolling=yes",
                      src = "./precipitaciones/inta-mapa-precipitaciones-la-pampa-3.pdf")
        ),
        tabPanel(
          "MAPA 4",
          "inta-mapa-precipitaciones-la-pampa-4.pdf",
          tags$iframe(style = "height:800px; width:100%; scrolling=yes",
                      src = "./precipitaciones/inta-mapa-precipitaciones-la-pampa-4.pdf")
        )
        
      )
    ),
    
    tabPanel(
      "Mapas de índice de sequía provincia de La Pampa 2015-2019",
      tags$h4(
        "El Índice de Sequía de Palmer (ISP) (1965) fue desarrollado para medir la intensidad, duración y extensión espacial de la sequía."
      ),
      tags$h4(
        "Este informe propone mostrar mapas de ISP en la región centro oriental agropecuaria de la provincia de La Pampa, para monitorear mensualmente la ocurrencia de sequía y determinar áreas con distintos niveles de riesgo."
      ),
      tags$h4(
        "La variabilidad interanual de las precipitaciones está ocasionada por la presencia frecuente de eventos secos, y eventos húmedos. Las consecuencias de estas situaciones extremas impactan sobre el desarrollo social, económico y ambiental de la región afectada."
      ),
      tags$a("Link al sitio web",
             href = "https://inta.gob.ar/documentos/mapas-de-indice-de-sequia-provincia-de-la-pampa-2015-2019", target =
               "_blank")
    )
    
  )
  
}

#################################
# SERVER
cartografiaServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 
                 output$imagen_1 <- renderUI({
                   ns <- session$ns
                   
                   src <- archivos_precip %>%
                     str_subset(input$inAnio) %>%
                     str_subset(input$inMes) %>%
                     str_subset(input$inX)
                   
                   if (identical(src, character(0))) {
                     HTML('<h2 style="color: red;">No hay imagen para el periodo seleccionado</h2>')
                   } else {
                     src <- paste0("./precipitaciones/", src)
                     img(src = src, width = "100%")
                   }
                   
                 })
                 
                 output$imagen_2 <- renderUI({
                   ns <- session$ns
                   src <- paste0("./sequias/", input$inImgSeq)
                   img(src = src, width = "100%")
                 })
                 
                 output$imagen_3 <- renderUI({
                   ns <- session$ns
                   
                   src <- paste0("./heladas/",
                                 grep(
                                   pattern = format(input$inImgHeladas,
                                                    format = "%d%m%Y"),
                                   archivos_heladas,
                                   value = TRUE
                                 ))
                   
                   img(src = src, width = "100%")
                 })
                 
               })
}
