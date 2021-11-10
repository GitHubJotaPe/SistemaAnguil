# armado de arrays con localidades y variables climáticas
localidades_csv <-
  readr::read_delim("data/localidades.csv",
                    ";",
                    escape_double = FALSE,
                    trim_ws = TRUE)

localidades  <-
  setNames(localidades_csv$ID_LOCALIDAD,
           localidades_csv$DESC_LOCALIDAD)

fenomenos_csv <-
  readr::read_delim("data/fenomenos.csv",
                    ";",
                    escape_double = FALSE,
                    trim_ws = TRUE)

fenomenos <-
  setNames(fenomenos_csv$ID_FENOMENO, fenomenos_csv$DESC_FENOMENO)

# funcion para obtener los datos del archivo .dat
getDat <- function (paramId, paramDesc) {
  anguil_dat <- read_lines(paste0("data/", paramId, ".DAT"))
  
  # filas con datos, y saco las descripciones de los fenomenos
  if (TRUE) {
    anguil_dat <- anguil_dat[6:24]
    anguil_dat <- anguil_dat %>% str_sub(-92)
    
  }
  
  retorno <- anguil_dat %>%
    str_squish() %>% # reemplaza varios espacios en blanco por uno solo
    str_split(pattern = " ") %>%  # crea columnas por espacios en blanco
    as_tibble(.name_repair = "minimal") %>%
    t()
  
  retorno <- retorno %>%
    as.numeric() %>%
    matrix(nrow = 19, byrow = FALSE)
  
  colnames(retorno) <-
    c(meses, "AÑO") # a los meses, se le agrega AÑO
  
  retorno <-
    cbind(fenomenos_csv,
          retorno,
          LOCALIDAD = paramDesc,
          ID_LOCALIDAD = paramId)
  
  return(retorno)
}

# funcion para generar el dataset, con el llamado a la funcion anteriormente creada
generarDS <- function() {
  retorno <- NULL
  
  for (i in 1:nrow(localidades_csv)) {
    data <- getDat(paramId = localidades_csv$ID_LOCALIDAD[i],
                   paramDesc = localidades_csv$DESC_LOCALIDAD[i])
    retorno <- rbind(retorno, data)
  }
  
  return(retorno)
}


#################################
# UI
historicoUI <- function(id) {
  ns <- NS(id)
  
  tagList(fluidRow(
    column(
      width = 2,
      selectInput(ns('localidad'),
                  'Seleccione LOCALIDAD',
                  choices = localidades)
    ),
    column(
      width = 10,
      selectInput(ns('variable'),
                  'Seleccione VARIABLE CLIMÁTICA',
                  choices = fenomenos)
    )
  ),
  
  fluidRow(
    column(width = 2,
           DT::DTOutput(ns('tablaAnguilB'))),
    column(width = 10,
           plotly::plotlyOutput(ns("grafico_1B")))
  ))
}

#################################
# SERVER
historicoServer <- function(id) {
  moduleServer(id,
               function(input, output, session) {
                 
                 # Para dejar solo T. Min a 5 y 50
                 # solo para cuando se seleccione Anguil
                 esAnguil <- function(x)
                 {
                   if (x == 'anguil')
                     return(fenomenos) # retorna todo
                   else
                     # retorna todo menos los registros 5 y 6 (T.MIN 5º y 50º)
                     return(fenomenos[-5:-6]) 
                 }
                 
                 observeEvent(
                   input$localidad,
                   updateSelectInput(
                     session,
                     "variable",
                     "variable",
                     choices = esAnguil(input$localidad)
                   )
                 )
                 
                 # tabla
                 output$tablaAnguilB <- DT::renderDT({
                   ns <- session$ns
                   dataset <- generarDS()
                   
                   data_tabla <- dataset %>%
                     filter(ID_FENOMENO == input$variable) %>%
                     filter(ID_LOCALIDAD == input$localidad) %>%
                     select(-ID_FENOMENO,-ID_LOCALIDAD,-LOCALIDAD) %>%
                     t()
                   
                   DT::datatable(
                     tail(data_tabla, n = 13),
                     colnames = data_tabla[1],
                     options = list(searching = FALSE, paging = FALSE),
                     escape = FALSE
                   ) %>%
                     DT::formatStyle(0, fontWeight = DT::styleEqual("AÑO", 'bold'))

                 })
                 
                 # Gráfico
                 output$grafico_1B <- plotly::renderPlotly({
                   ns <- session$ns
                   
                   dataset <- generarDS()
                   
                   dataset <- dataset %>%
                     filter(ID_FENOMENO == input$variable) %>%
                     filter(ID_LOCALIDAD == input$localidad) %>%
                     select(-DESC_FENOMENO, -ID_LOCALIDAD, -AÑO) %>%
                     reshape2::melt(id.vars = c("ID_FENOMENO", "LOCALIDAD")) %>%
                     mutate(variable = factor(variable, levels = unique(variable)))
                   
                   colores <-
                     wes_palette(name = "GrandBudapest1", n = 3)
                   color <- switch (
                     input$localidad,
                     "anguil" = colores[1],
                     "gral_pico" = colores[2],
                     "santa_rosa" = colores[3]
                   )
                   
                   grafico <- ggplot(dataset,
                                     aes(x = variable ,
                                         y = value,
                                         group = LOCALIDAD))
                   
                   grafico <- switch (
                     input$variable,
                     "4" = grafico + geom_bar(
                       stat = 'identity',
                       color = color,
                       fill = color
                     ),
                     "9" = grafico + geom_point(color = color) + geom_line(color =
                                                                             color),
                     "15" = grafico + geom_bar(
                       stat = 'identity',
                       color = color,
                       fill = color
                     ),
                     "16" = grafico + geom_bar(
                       stat = 'identity',
                       color = color,
                       fill = color
                     ),
                     "17" = grafico + geom_point(color = color) + geom_line(color =
                                                                              color),
                     "18" = grafico + geom_bar(
                       stat = 'identity',
                       color = color,
                       fill = color
                     ),
                     "19" = grafico + geom_bar(
                       stat = 'identity',
                       color = color,
                       fill = color
                     ),
                     grafico + geom_line(color = color)
                     
                   )
                   
                   grafico <- grafico +
                     labs(x = "Meses", y = "Valores") +
                     theme_classic()
                   
                 })
                 
               })
}
