library(tidyverse)

# Lectura del archivo anguil.csv
anguil_csv <- readr::read_csv(
  "data/anguil.csv",
  col_types = cols(
    #X1 = col_skip(),
    fecha = col_date(format = "%d/%m/%Y"),
    codigo_nh = col_integer(),
    t_max = col_double(),
    hr = col_integer(),
    heliofania_efec = col_double(),
    radiacion = col_double(),
    etp = col_double(),
    t_media = col_double(),
    amplitud = col_double()
  )
)

# se agregan algunas columnas calculadas
data_anguil <- anguil_csv %>%
  mutate(
    anio = as.integer(lubridate::year(fecha)),
    mes =  as_factor(lubridate::month(fecha)),
    dias_mes = lubridate::days_in_month(fecha),
    dias_mes = replace(dias_mes, dias_mes == 29, 28),
    # en febrero, cambio el dia para bisiestos
    semana = lubridate::week(fecha),
    mes_nombre = as_factor(
      case_when(
        mes == 1  ~ "Ene",
        mes == 2  ~ "Feb",
        mes == 3  ~ "Mar",
        mes == 4  ~ "Abr",
        mes == 5  ~ "May",
        mes == 6  ~ "Jun",
        mes == 7  ~ "Jul",
        mes == 8  ~ "Ago",
        mes == 9  ~ "Sep",
        mes == 10  ~ "Oct",
        mes == 11  ~ "Nov",
        mes == 12  ~ "Dic"
      )
    ),
    clase_t_max = as_factor(case_when(
      t_max > 40 ~ "> 40º",
      t_max > 35 ~ "> 35º",
      t_max > 30 ~ "> 30º"
    )),
    clase_precip = as_factor(
      case_when(
        precip > 50 ~ "> 50mm",
        precip > 20 ~ "> 20mm",
        precip > 10 ~ "> 10mm",
        precip > 5 ~ "> 5mm",
        #precip > 2 ~ "> 2mm",
        precip > 0 ~ "> 0mm",
        precip == 0 ~ "0mm"
      )
    )
  )

#################################
# UI
anguilUI <- function(id) {
  ns <- NS(id)
  
  
  tagList(
    h1("Climatología de Anguil"),
    
    h1(""),
    h1(""),
    
    # TEMPERATURAS MEDIAS Y PRECIPITACIÓN
    fluidRow(
      column(width = 2),
      column(
        width = 8,
        align = "center",
        plotly::plotlyOutput(ns("grafico_1"))
      ),
      column(width = 2)
    ),
    
    h1(""),
    h1(""),
    
    # HELIOFANIA EFECTIVA MEDIA
    fluidRow(
      column(width = 2),
      column(
        width = 8,
        align = "center",
        plotly::plotlyOutput(ns("grafico_2"))
      ),
      column(width = 2)
    ),
    
    h1(""),
    h1(""),
    
    # CANTIDAD DE DIAS CON TEMPERATURA MAXIMA
    fluidRow(
      column(width = 2),
      column(
        width = 8,
        align = "center",
        plotly::plotlyOutput(ns("grafico_3"))
      ),
      column(width = 2)
    ),
    
    h1(""),
    h1(""),
    
    # CANTIDAD DE DIAS CON PRECIPITACIÓN
    fluidRow(
      column(width = 2),
      column(
        width = 8,
        align = "center",
        plotly::plotlyOutput(ns("grafico_4"))
      ),
      column(width = 2)
    ),
    
    h1(""),
    h1(""),
    
    # VELOCIDAD DEL VIENTO MEDIO
    fluidRow(
      column(width = 2),
      column(
        width = 8,
        align = "center",
        plotly::plotlyOutput(ns("grafico_5"))
      ),
      column(width = 2)
    ),
    
    h1(""),
    h1(""),
    
    # TEMPERATURA MINIMA/MAXIMA OBSERVADA
    fluidRow(
      column(width = 2),
      column(
        width = 8,
        align = "center",
        plotly::plotlyOutput(ns("grafico_6"))
      ),
      column(width = 2)
    )
    
  )
  
}

#################################
# SERVER
anguilServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 
                 ###########################################
                 # TEMPERATURAS MEDIAS Y PRECIPITACIÓN
                 output$grafico_1 <- plotly::renderPlotly({
                   ns <- session$ns
                   
                   data_grafico <- data_anguil %>%
                     filter(between(anio, 1981, 2010)) %>%
                     select(mes_nombre, precip, t_max, t_min) %>%
                     group_by(mes_nombre) %>%
                     summarise(
                       # suma de mm de los datos diarios para la suma mensual, 
                       # y despues se hace el promedio de todos los eneros
                       Precipitaciones = round(
                         ifelse(sum(is.na(precip)) <= 5 & n() > 25, 
                                sum(precip, na.rm = TRUE), 
                                NA) / 30, 
                         digits = 1),
                       prom_t_max = round(mean(t_max, na.rm = TRUE), digits = 1),
                       prom_t_min = round(mean(t_min, na.rm = TRUE), digits = 1)
                     )
                   
                   
                   fig <- plot_ly(data_grafico)
                   
                   fig <- fig %>% add_bars(
                     name = 'Precip (mm)',
                     x = ~ mes_nombre,
                     y = ~ Precipitaciones,
                     text = "",
                     texttemplate = '<b>%{y}</b> mm',
                     textposition = 'auto',
                     hovertemplate = 'Mes: %{x}<br>mm: %{y}',
                     marker = list(
                       color = 'rgb(158,202,225)',
                       line = list(color = 'rgb(8,48,107)',
                                   width = 1.5)
                     )
                   )
                   
                   fig <- fig %>% add_trace(
                     name = "TMAX",
                     x = ~ mes_nombre,
                     y = ~ prom_t_max,
                     type = 'scatter',
                     mode = 'text+markers',
                     text = "",
                     texttemplate = '<b>%{y}</b>',
                     textposition = 'top center',
                     hovertemplate = 'Mes: %{x}<br>ºC: %{y}',
                     yaxis = "y2",
                     fill = 'red',
                     text = ~ prom_t_max,
                     marker = list(color = 'red',
                                   width = 1.5),
                     textfont = list(color = 'red'),
                     showlegend = FALSE
                   )
                   
                   fig <- fig %>% add_trace(
                     name = 'TMAX (ºC)',
                     x = ~ mes_nombre,
                     y = ~ prom_t_max,
                     type = 'scatter',
                     mode = 'lines',
                     yaxis = "y2",
                     fill = 'red',
                     line = list(color = 'red',
                                 width = 1.5)
                   )
                   
                   fig <- fig %>% add_trace(
                     name = "TMIN",
                     x = ~ mes_nombre,
                     y = ~ prom_t_min,
                     type = 'scatter',
                     mode = 'text+markers',
                     text = "",
                     texttemplate = '<b>%{y}</b>',
                     textposition = 'bottom center',
                     hovertemplate = 'Mes: %{x}<br>ºC: %{y}',
                     yaxis = "y2",
                     fill = 'blue',
                     text = ~ prom_t_max,
                     marker = list(color = 'blue',
                                   width = 1.5),
                     textfont = list(color = 'blue'),
                     showlegend = FALSE
                   )
                   
                   fig <- fig %>% add_trace(
                     name = 'TMIN (ºC)',
                     x = ~ mes_nombre,
                     y = ~ prom_t_min,
                     type = 'scatter',
                     mode = 'lines',
                     yaxis = "y2",
                     fill = 'blue',
                     line = list(color = 'blue',
                                 width = 1.5)
                   )
                   
                   
                   fig <- fig %>% layout(
                     title = list(
                       text = paste0(
                         "Temperaturas medias y precipitación",
                         '<br>',
                         '<sup>',
                         'Temperaturas y precipitaciones entre 1980 y 2010',
                         '</sup>'
                       )
                     ),
                     yaxis2 = list(
                       overlaying = "y",
                       side = "right",
                       title = "TEMPERATURA (ºC)"
                     ),
                     xaxis = list(
                       title = paste0("MESES",
                                      '<br>',
                                      '<sup>',
                                      'FUENTE: INTA',
                                      '</sup>')
                     )
                     
                   )
                   
                   fig
                 })
                 
                 ###################################################
                 # HELIOFANIA EFECTIVA MEDIA
                 output$grafico_2 <- plotly::renderPlotly({
                   ns <- session$ns
                   
                   data_grafico <- data_anguil %>%
                     select(mes_nombre, heliofania_efec) %>%
                     group_by(mes_nombre) %>%
                     summarise(heliofania_efec_mean = mean(heliofania_efec, na.rm = TRUE))
                   
                   fig <- plot_ly(data_grafico)
                   
                   fig <- fig %>% add_bars(
                     name = 'Heliofania efectiva media',
                     x = ~ mes_nombre,
                     y = ~ heliofania_efec_mean,
                     color = I("khaki3")
                     
                   )
                   
                   fig <- fig %>% layout(
                     title = list(text = "Heliofania efectiva media"),
                     yaxis = list(title = "Heliofania (hs)"),
                     xaxis = list(title = "Meses")
                   )
                   
                   fig
                 })
                 
                 ###########################################
                 # CANTIDAD DE DIAS CON TEMPERATURA MAXIMA
                 output$grafico_3 <- plotly::renderPlotly({
                   ns <- session$ns
                   
                   data_grafico <- data_anguil %>%
                     filter(between(anio, 1981, 2010)) %>%
                     select(mes_nombre, clase_t_max) %>%
                     filter(!is.na(clase_t_max),
                            mes_nombre %in% c("Ene", "Feb", "Nov", "Dic")) %>%
                     mutate(mes_nombre = factor(mes_nombre, levels = c("Nov", "Dic", "Ene", "Feb"))) %>% # reorden de meses
                     group_by(mes_nombre, clase_t_max, .drop = FALSE) %>%
                     summarise(count = n() / 30) %>%
                     spread(clase_t_max, count)
                   
                   colores = brewer.pal(3, 'Spectral')
                   
                   fig <- plot_ly(
                     data_grafico,
                     x = ~ mes_nombre,
                     y = ~ `> 30º`,
                     type = 'bar',
                     name = '> 30º',
                     marker = list(color = colores[1])
                   )
                   fig <-
                     fig %>% add_trace(
                       y = ~ `> 35º`,
                       name = '> 35º',
                       marker = list(color = colores[2])
                     )
                   fig <-
                     fig %>% add_trace(
                       y = ~ `> 40º`,
                       name = '> 40º',
                       marker = list(color = colores[3])
                     )
                   
                   fig <- fig %>% layout(
                     barmode = 'stack',
                     title = list(text = "Cantidad de días con temperatura máxima"),
                     yaxis = list(title = "Cantidad de días"),
                     xaxis = list(title = "Meses")
                   )
                   
                   fig
                 })
                 
                 ###########################################
                 # CANTIDAD DE DIAS CON PRECIPITACIÓN
                 output$grafico_4 <- plotly::renderPlotly({
                   ns <- session$ns
                   
                   data_grafico <- data_anguil %>%
                     filter(between(anio, 1981, 2010)) %>%
                     select (mes_nombre, clase_precip) %>%
                     mutate(clase_precip = factor(
                       clase_precip,
                       levels = c("0mm", "> 0mm", "> 5mm", "> 10mm", "> 20mm", "> 50mm")
                     )) %>%
                     filter(!is.na(clase_precip)) %>%
                     group_by(mes_nombre, clase_precip) %>%
                     summarise(count = n() / 30) %>%
                     spread(clase_precip, count)
                   
                   colores = c("#ffffcc",
                               "#c7e9b4",
                               "#7fcdbb",
                               "#41b6c4",
                               "#1d91c0",
                               "#225ea8")
                   
                   fig <- plot_ly(
                     data_grafico,
                     x = ~ mes_nombre,
                     y = ~ `0mm`,
                     type = 'bar',
                     name = '0mm'
                     ,
                     marker = list(color = colores[1])
                   )
                   
                   fig <-
                     fig %>% add_trace(
                       y = ~ `> 0mm`,
                       name = '> 0mm',
                       marker = list(color = colores[2])
                     )
                   fig <-
                     fig %>% add_trace(
                       y = ~ `> 5mm`,
                       name = '> 5mm',
                       marker = list(color = colores[3])
                     )
                   fig <-
                     fig %>% add_trace(
                       y = ~ `> 10mm`,
                       name = '> 10mm',
                       marker = list(color = colores[4])
                     )
                   fig <-
                     fig %>% add_trace(
                       y = ~ `> 20mm`,
                       name = '> 20mm',
                       marker = list(color = colores[5])
                     )
                   fig <-
                     fig %>% add_trace(
                       y = ~ `> 50mm`,
                       name = '> 50mm',
                       marker = list(color = colores[6])
                     )
                   fig <- fig %>% layout(
                     barmode = 'stack',
                     title = list(text = "Cantidad de dias con precipitación"),
                     yaxis = list(title = "Cantidad de días"),
                     xaxis = list(title = "Meses")
                   )
                   
                   fig
                 })
                 
                 ###########################################
                 # VELOCIDAD DEL VIENTO MEDIO
                 output$grafico_5 <- plotly::renderPlotly({
                   ns <- session$ns
                   
                   data_grafico <- data_anguil %>%
                     select(mes_nombre, viento_2m) %>%
                     filter(!is.na(viento_2m)) %>%
                     group_by(mes_nombre) %>%
                     summarise(quantile = t(quantile(viento_2m, c(
                       0.25, 0.5, 0.75
                     ))))
                   
                   fig <- plot_ly(data_grafico)
                   
                   fig <- fig %>% add_trace(
                     name = 'Tercer cuartil',
                     x = ~ mes_nombre,
                     y = ~ quantile[, 3],
                     type = 'scatter',
                     mode = 'lines+text',
                     line = list(color = 'transparent'),
                     showlegend = FALSE,
                     text = "",
                     texttemplate = '%{y}',
                     textposition = 'top center',
                     hovertemplate = 'Mes: %{x}<br>Q3: %{y}'
                   )
                   
                   fig <- fig %>% add_trace(
                     name = 'Primer cuartil',
                     x = ~ mes_nombre,
                     y = ~ quantile[, 1],
                     type = 'scatter',
                     mode = 'lines+text',
                     fill = 'tonexty',
                     fillcolor = 'rgba(0,100,80,0.2)',
                     line = list(color = 'transparent'),
                     showlegend = FALSE,
                     text = "",
                     texttemplate = '%{y}',
                     textposition = 'bottom center',
                     hovertemplate = 'Mes: %{x}<br>Q1: %{y}'
                   )
                   
                   fig <- fig %>% add_trace(
                     name = 'Segundo cuartil',
                     x = ~ mes_nombre,
                     y = ~ quantile[, 2],
                     type = 'scatter',
                     mode = 'lines+text+markers',
                     line = list(color = 'rgb(0,100,80)'),
                     text = "",
                     texttemplate = '<b>%{y}</b>',
                     textposition = 'top center',
                     hovertemplate = 'Mes: %{x}<br>Q2: %{y}'
                   )
                   
                   fig <- fig %>% layout(
                     title = "Velocidad del viento medio",
                     yaxis = list(title = "Velocidad (km/h)"),
                     xaxis = list(title = "Meses")
                   )
                   
                   fig
                 })
                 
                 ###########################################
                 # TEMPERATURA MINIMA/MAXIMA OBSERVADA
                 output$grafico_6 <- plotly::renderPlotly({
                   ns <- session$ns
                   
                   data_grafico_t_max <- data_anguil %>%
                     select(mes_nombre, t_max) %>%
                     filter(!is.na(t_max)) %>%
                     group_by(mes_nombre) %>%
                     summarise(
                       max  = max(t_max, na.rm = TRUE),
                       mean = mean(t_max, na.rm = TRUE),
                       min  = min(t_max, na.rm = TRUE),
                       quantile = t(quantile(t_max, c(
                         0.25, 0.5, 0.75
                       )))
                     )
                   
                   data_grafico_t_min <- data_anguil %>%
                     select(mes_nombre, t_min) %>%
                     filter(!is.na(t_min)) %>%
                     group_by(mes_nombre) %>%
                     summarise(
                       max  = max(t_min, na.rm = TRUE),
                       mean = mean(t_min, na.rm = TRUE),
                       min  = min(t_min, na.rm = TRUE),
                       quantile = t(quantile(t_min, c(
                         0.25, 0.5, 0.75
                       )))
                     )
                   
                   
                   fig <- plot_ly()
                   
                   fig <- fig %>% add_trace(
                     data = data_grafico_t_max,
                     type = 'scatter',
                     mode = 'markers',
                     name = 'tmax',
                     x = ~ mes_nombre,
                     y = ~ max,
                     marker = list(color = "red", symbol = 'cross')
                   )
                   
                   fig <- fig %>% add_trace(
                     data = data_grafico_t_max,
                     type = 'scatter',
                     mode = 'lines+text',
                     name = 'Tercer cuartil',
                     x = ~ mes_nombre,
                     y = ~ quantile[, 3],
                     line = list(color = 'transparent'),
                     showlegend = FALSE
                   )
                   
                   fig <- fig %>% add_trace(
                     data = data_grafico_t_max,
                     name = 'Banda tmax',
                     type = 'scatter',
                     mode = 'lines',
                     fill = 'tonexty',
                     x = ~ mes_nombre,
                     y = ~ quantile[, 1],
                     fillcolor = 'rgba(255, 0, 0, 0.2)',
                     line = list(color = 'transparent')
                   )
                   
                   fig <- fig %>% add_trace(
                     data = data_grafico_t_max,
                     name = 'Mediana tmax',
                     x = ~ mes_nombre,
                     y = ~ quantile[, 2],
                     type = 'scatter',
                     mode = 'lines',
                     line = list(color = 'rgb(255,0,0)'),
                     text = "",
                     texttemplate = '<b>%{y}</b>',
                     textposition = 'top center',
                     hovertemplate = 'Mes: %{x}<br>Q2: %{y}'
                   )
                   
                   fig <- fig %>% add_trace(
                     data = data_grafico_t_min,
                     type = 'scatter',
                     mode = 'markers',
                     name = 'tmin',
                     x = ~ mes_nombre,
                     y = ~ min,
                     marker = list(color = "blue", symbol = 'circle')
                   )
                   
                   fig <- fig %>% add_trace(
                     data = data_grafico_t_min,
                     type = 'scatter',
                     mode = 'lines+text',
                     name = 'Tercer cuartil',
                     x = ~ mes_nombre,
                     y = ~ quantile[, 3],
                     line = list(color = 'transparent'),
                     showlegend = FALSE
                   )
                   
                   fig <- fig %>% add_trace(
                     data = data_grafico_t_min,
                     name = 'Banda tmin',
                     type = 'scatter',
                     mode = 'lines',
                     fill = 'tonexty',
                     x = ~ mes_nombre,
                     y = ~ quantile[, 1],
                     fillcolor = 'rgba(0, 0, 255, 0.2)',
                     line = list(color = 'transparent')
                   )
                   
                   fig <- fig %>% add_trace(
                     data = data_grafico_t_min,
                     name = 'Mediana tmin',
                     x = ~ mes_nombre,
                     y = ~ quantile[, 2],
                     type = 'scatter',
                     mode = 'lines',
                     line = list(color = 'rgb(0,0,255)'),
                     text = "",
                     texttemplate = '<b>%{y}</b>',
                     textposition = 'top center',
                     hovertemplate = 'Mes: %{x}<br>Q2: %{y}'
                   )
                   
                   fig <- fig %>% layout(
                     title = "Temperatuda mínima/máxima observada",
                     yaxis = list(title = "Temperatura (ºC)"),
                     xaxis = list(title = "Meses")
                   )
                   
                   fig
                 })
                 
               })
  
}
