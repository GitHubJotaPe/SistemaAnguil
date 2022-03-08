#################################
# UI
agroIndicesUI <- function(id) {
  ns <- NS(id)
  
  tagList(sidebarLayout(
    sidebarPanel(
      h3("A872823"),
      h4("filtros"),
      h6("EJ: t_min <= 0  , para filtrar sólo los días donde hay heladas."),
      dateRangeInput(
        ns("inFechas"),
        "Rango de fechas:",
        min    = fecha_min_A872823,
        max    = fecha_max_A872823,
        start  = fecha_max_A872823 - 10,
        end    = fecha_max_A872823,
        format = "dd/mm/yyyy",
        separator = " - ",
        language = "es"
      ),
      
      fluidRow(column(
        8,
        selectInput(
          ns("operacion"),
          "operacion",
          choices = c(
            "Temp. min. abrigo a 150cm <=" = "t_a_min",
            "Temp. max. abrigo a 150cm >=" = "t_a_max",
            "Temp. min. intemperie 50cm <=" = "t_i_min"
          )
        )
      ),
      column(
        4,
        numericInput(
          inputId = ns("valor"),
          label = "valor (en ºC)",
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
          
          h1("Estadísticas básicas"),
          
          fluidRow(column(6,
                          h3(
                            "PERIODO SELECCIONADO"
                          ))
                   ,
                   column(6,
                          h3(textOutput(
                            ns("titulo")
                          )))),
          
          h3(textOutput(ns("subtitulo_1"))),
          fluidRow(valueBoxOutput(ns("boxN")))
          
          # ,
          #
          # h3("Estadísticas básicas"),
          #
          # fluidRow(
          #   valueBoxOutput(ns("temp_min")),
          #   valueBoxOutput(ns("temp_max")),
          #   valueBoxOutput(ns("temp_mean")),
          #   valueBoxOutput(ns("lluvia_sum")),
          #   valueBoxOutput(ns("viento_mean")),
          #   valueBoxOutput(ns("viento_max"))
          #
          # ),
          # fluidRow(plotlyOutput(ns("grafico_radar")))
          #
          
        )
      )
      
    )
    
  ))
}

#################################
# SERVER
agroIndicesServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 output$titulo <- renderText({
                   paste0(
                     format(input$inFechas[1], "%d/%m/%Y"),
                     " - ",
                     format(input$inFechas[2], "%d/%m/%Y")
                   )
                 })
                 
                 ##### estadísticas generales
                 
                 # dataset
                 data_aux_2 <- reactive({
                   retorno <- A872823 %>%
                     filter(fecha >= input$inFechas[1] &
                              fecha <= input$inFechas[2]) %>%
                     summarise(
                       tmin = min(temperatura_abrigo_150cm_minima, na.rm = TRUE),
                       tmax = max(temperatura_abrigo_150cm_maxima, na.rm = TRUE),
                       tmean = mean(temperatura_abrigo_150cm, na.rm = TRUE),
                       sum = sum(precipitacion_pluviometrica, na.rm = TRUE),
                       media_viento = mean(velocidad_viento_200cm_media),
                       max_viento = max(velocidad_viento_maxima)
                     )
                   
                   retorno
                 })
                 
                 
                 # TEMP
                 # output$temp_min <- renderValueBox({
                 #   data <- data_aux_2() %>% select(tmin)
                 #   valueBox(
                 #     paste0(round(data, 1), "ºC"),
                 #     "Temp. mínima",
                 #     icon = icon("thermometer-empty"),
                 #     color = "blue"
                 #   )
                 # })
                 #
                 # output$temp_max <- renderValueBox({
                 #   data <- data_aux_2() %>% select(tmax)
                 #   valueBox(
                 #     paste0(round(data, 1), "ºC"),
                 #     "Temp. máxima",
                 #     icon = icon("thermometer-full"),
                 #     color = "red"
                 #   )
                 # })
                 #
                 # output$temp_mean <- renderValueBox({
                 #   data <- data_aux_2() %>% select(tmean)
                 #   valueBox(
                 #     paste0(round(data, 1), "ºC"),
                 #     "Temp. promedio",
                 #     icon = icon("thermometer-half"),
                 #     color = "purple"
                 #   )
                 # })
                 #
                 
                 
                 # # PRECIP
                 # output$lluvia_sum <- renderValueBox({
                 #   data <- data_aux_2() %>% select(sum)
                 #   valueBox(
                 #     paste0(round(data, 1), "mm"),
                 #     "Sumatoria de lluvias",
                 #     icon = icon("cloud-showers-heavy"),
                 #     color = "teal"
                 #   )
                 # })
                 
                 # # VIENTO
                 # output$viento_mean <- renderValueBox({
                 #   data <- data_aux_2() %>% select(media_viento)
                 #   valueBox(
                 #     paste0(round(data, 1), "km/h"),
                 #     "Promedio del viento",
                 #     icon = icon("wind"),
                 #     color = "light-blue"
                 #   )
                 # })
                 #
                 # output$viento_max <- renderValueBox({
                 #   data <- data_aux_2() %>% select(max_viento)
                 #   valueBox(
                 #     paste0(round(data, 1), "km/h"),
                 #     "Máximas de viento",
                 #     icon = icon("wind"),
                 #     color = "blue"
                 #   )
                 # })
                 
                 # # dataset
                 # data_plotly <- reactive({
                 #   retorno <- A872823 %>%
                 #     filter(fecha >= input$inFechas[1] &
                 #              fecha <= input$inFechas[2]) %>%
                 #     count(direccion_viento_200cm) %>%
                 #     rename (dir = direccion_viento_200cm) %>%
                 #     filter(dir != 'C') %>%
                 #     mutate(
                 #       dir = replace(dir, dir == "W", "O"),
                 #       dir = replace(dir, dir == "NW", "NO"),
                 #       dir = replace(dir, dir == "SW", "SO")
                 #     )
                 #
                 #   retorno <-
                 #     direcciones_viento %>% left_join(retorno, by = c("value" = "dir"))
                 #
                 #   retorno
                 # })
                 #
                 #
                 # output$grafico_radar <- renderPlotly({
                 #   mrg <- list(t = 50)
                 #
                 #   fig <- plot_ly(
                 #     name = "Dir. del Viento",
                 #     data = data_plotly(),
                 #     type = 'scatterpolar',
                 #     mode   = 'markers',
                 #     r = ~ n,
                 #     theta = ~ value,
                 #     hovertemplate = 'Orientación: %{theta}<br>Cantidad: %{r}',
                 #     #fill = 'toself',
                 #     marker = list(color = "blue",
                 #                   size = 10)
                 #   )
                 #
                 #   fig <- fig %>%
                 #     layout(
                 #       showlegend = T,
                 #       title = list(text = "CANTIDAD DE DÍAS CON VIENTO POR PUNTO CARDINAL"),
                 #       margin = mrg,
                 #       paper_bgcolor = '#b0bdca'
                 #     )
                 #
                 #   fig
                 #
                 # })
                 #
                 
                 ##### agromet - umbrales
                 output$subtitulo_1 <- renderText({
                   aux_formula <- switch(
                     input$operacion,
                     "t_a_min" = "Temperatura mínima en abrigo a 150cm <= ",
                     "t_a_max" = "Temperatura máxima en abrigo a 150cm >=" ,
                     "t_i_min" = "Temperatura mínima a la intemperie a 50cm <= "
                   )
                   
                   paste0("Uso de la funcion 'umbrales' con el filtro de ",
                          aux_formula,
                          input$valor)
                 })
                 
                 
                 data_aux <- reactive({
                   retorno <- A872823 %>%
                     filter(fecha >= input$inFechas[1] &
                              fecha <= input$inFechas[2])
                   
                   retorno <- switch(
                     input$operacion,
                     "t_a_min" = retorno %>% summarise(
                       agromet::umbrales(t_30 = temperatura_abrigo_150cm_minima <= input$valor)
                     ),
                     "t_a_max" = retorno %>% summarise(
                       agromet::umbrales(t_30 = temperatura_abrigo_150cm_maxima >= input$valor)
                     ) ,
                     "t_i_min" = retorno %>% summarise(
                       agromet::umbrales(t_30 = temperatura_intemperie_50cm_minima <= input$valor)
                     )
                   )
                   
                   retorno
                   
                 })
                 
                 # Caja con cantidad de días retornada por la funcion
                 output$boxN <- renderValueBox({
                   data <- data_aux() %>% select(N)
                   if (is.na(data)) {
                     data <- 0
                   }
                   valueBox(paste0(data),
                            "día/s",
                            icon = icon("list"),
                            color = "green")
                 })
                 
                 
               })
}
