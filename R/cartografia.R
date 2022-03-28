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
    
    # PRECIPITACIONES   ######################
    tabPanel(
      "Precipitaciones",
      sidebarLayout(
        sidebarPanel(
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
        mainPanel(textOutput(ns("salida")),
                  uiOutput(ns("imagen_1")))
      )
    ),
    
    # SEQUIA  ######################
    tabPanel(
      "Índices de sequía",
      sidebarLayout(
        sidebarPanel(
          selectInput(ns('inAnioSeq'),
                      'AÑO',
                      choices = c("2022",
                                  "2021",
                                  "2020")),
          selectInput(ns('inMesSeq'),
                      'MES',
                      choices = c(meses)),
          
          tags$a(
            "Índice de Sequía de Palmer (2015-2019)",
            href = "https://inta.gob.ar/documentos/mapas-de-indice-de-sequia-provincia-de-la-pampa-2015-2019",
            target =
              "_blank"
          )
          
          
        ),
        mainPanel(uiOutput(ns("imagen_2")))
      )
    ),
    
    # HELADAS ######################
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
    
    # PROMEDIOS HISTORICOS ######################
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
    )
    
    
  )
  
}

#################################
# SERVER
cartografiaServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 # PRECIPITACIONES ######################
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
                 
                 # SEQUIAS ######################
                 output$imagen_2 <- renderUI({
                   ns <- session$ns
                   
                   src <- archivos_sequia %>%
                     str_subset(input$inAnioSeq) %>%
                     str_subset(input$inMesSeq)
                   
                   if (identical(src, character(0))) {
                     HTML('<h2 style="color: red;">No hay imagen para el periodo seleccionado</h2>')
                   } else {
                     src <- paste0("./sequias/", src)
                     img(src = src, width = "100%")
                   }
                 })
                 
                 # HELADAS ######################
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
