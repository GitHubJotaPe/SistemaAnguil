NH0446 <-  siga::siga_datos("NH0446") # Descarga de datos de Anguil
fecha_min_NH0446 <- min(NH0446$fecha) # Fecha minima del dataset
fecha_max_NH0446 <- max(NH0446$fecha) # Fecha maxima del dataset

#################################
# UI
agrometUI <- function(id) {
  ns <- NS(id)
  
  tagList(sidebarLayout(
    sidebarPanel(
      h3("NH0446"),
      h4("filtros"),
      h6("EJ: t_min <= 0  , para filtrar sólo los días donde hay heladas."),
      dateRangeInput(
        ns("inFechas"),
        "Rango de fechas:",
        min    = fecha_min_NH0446,
        max    = fecha_max_NH0446,
        start  = fecha_max_NH0446 - 10,
        end    = fecha_max_NH0446,
        format = "dd/mm/yyyy",
        separator = " - ",
        language = "es"
      ),
      
      fluidRow(
        column(
          8,
          selectInput(
            ns("operacion"),
            "operacion",
            choices = c("Tmin <=" = "tmin", "Tmax >=" = "tmax")
          )
        ),
        column(
          4,
          numericInput(
            inputId = ns("valor"),
            label = "valor",
            value = 0,
            min = -10,
            max = 10,
            step = 1
          )
        ))
      
    ),
    
    mainPanel(
      dashboardPage(
        dashboardHeader(disable = TRUE),
        dashboardSidebar(disable = TRUE),
        dashboardBody(
          tags$head(tags$style(
            HTML(
              '
              /* body */
              .content-wrapper, .right-side {
                background-color: #2b3e50; //4e5d6c
              }
              '
            )
          )),
          h2("PERIODO SELECCIONADO"),
          h2(textOutput(ns("titulo"))),
          h3("Estadisticas básicas con R"),
          fluidRow(
            valueBoxOutput(ns("Rmin")),
            valueBoxOutput(ns("Rmax")),
            valueBoxOutput(ns("Rmean")),
            valueBoxOutput(ns("Rsum"))
          ),
          h3(textOutput(ns("subtitulo_1"))),
          fluidRow(
            valueBoxOutput(ns("boxN")),
            valueBoxOutput(ns("boxProp")),
            valueBoxOutput(ns("boxNa"))
          )
        )
      )
      
    )

  ))
}

#################################
# SERVER
agrometServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 output$titulo <- renderText({
                   paste0(
                     format(input$inFechas[1], "%d/%m/%Y"),
                     " al ",
                     format(input$inFechas[2], "%d/%m/%Y")
                   )
                 })
                 
                 output$subtitulo_1 <- renderText({
                   paste0(
                     "Uso de la funcion 'umbrales' con el filtro ",
                     if (input$operacion == "tmin")
                       "tmin <= a "
                     else
                       "tmax >= a ",
                     input$valor
                   )
                 })
                 
                 data_aux <- reactive({
                   retorno <- NH0446 %>%
                     filter(fecha >= input$inFechas[1] &
                              fecha <= input$inFechas[2])
                   
                   if (input$operacion == "tmin") {
                     retorno <- retorno %>%
                       summarise(agromet::umbrales(t_30 = temperatura_abrigo_150cm_minima <= input$valor))
                   } else{
                     retorno <- retorno %>%
                       summarise(agromet::umbrales(t_30 = temperatura_abrigo_150cm_maxima >= input$valor))
                   }
                   
                   retorno
                   
                 })
                 
                 output$boxN <- renderValueBox({
                   
                   data <- data_aux() %>% select(N)
                   if (is.na(data)) {
                     data <- 0
                   }
                   
                   valueBox(paste0(data),
                            "N",
                            icon = icon("list"),
                            color = "green")
                   
                 })
                 
                 output$boxProp <- renderValueBox({
                   
                   data <- data_aux() %>% select(prop)
                   if (is.na(data)) {
                     data <- 0
                   }
                   
                   valueBox(paste0(round(data, 2)),
                            "prop",
                            icon = icon("list"),
                            color = "yellow")
                   
                 })
                 
                 output$boxNa <- renderValueBox({
                   
                   data <- data_aux() %>% select(na)
                   if (is.na(data)) {
                     data <- 0
                   }
                   
                   valueBox(paste0(round(data, 2)),
                            "na",
                            icon = icon("list"),
                            color = "red")
                   
                 })
                 
                 data_aux_2 <- reactive({
                   retorno <- NH0446 %>%
                     filter(fecha >= input$inFechas[1] &
                              fecha <= input$inFechas[2]) %>%
                     summarise(
                       tmin = min(temperatura_abrigo_150cm, na.rm = TRUE),
                       tmax = max(temperatura_abrigo_150cm, na.rm = TRUE),
                       tmean = mean(temperatura_abrigo_150cm, na.rm = TRUE),
                       sum = sum(precipitacion_pluviometrica, na.rm = TRUE)
                     )
                   
                   retorno
                 })
                 
                 output$Rmin <- renderValueBox({
                   data <- data_aux_2() %>% select(tmin)
                   
                   valueBox(
                     paste0(round(data, 2), "ºC"),
                     "Temp. mínima",
                     icon = icon("thermometer-empty"),
                     color = "blue"
                   )
                 })
                 
                 output$Rmax <- renderValueBox({
                   data <- data_aux_2() %>% select(tmax)
                   
                   valueBox(
                     paste0(round(data, 2), "ºC"),
                     "Temp. máxima",
                     icon = icon("thermometer-full"),
                     color = "red"
                   )
                 })
                 
                 output$Rmean <- renderValueBox({
                   data <- data_aux_2() %>% select(tmean)
                   
                   valueBox(
                     paste0(round(data, 2), "ºC"),
                     "Temp. promedio",
                     icon = icon("thermometer-half"),
                     color = "purple"
                   )
                 })
                 
                 output$Rsum <- renderValueBox({
                   data <- data_aux_2() %>% select(sum)
                   
                   valueBox(
                     paste0(round(data, 2), "mm"),
                     "Sumatoria de lluvias",
                     icon = icon("list"),
                     color = "yellow"
                   )
                 })
                 
               })
}
