#################################
# UI
inicioUI <- function(id) {
  ns <- NS(id)
  tagList(
    
    # texto que se observa sobre la imagen
    fluidRow(column(
    12,
    shiny::HTML(
      '<center>Bienvenidos al <b>Sistema de consulta de datos e información agrometeorológica y agroclimática
para la provincia de La Pampa</b></center><br>'
    ),
  )),
  
  # imagen central de INTA Anguil
  fluidRow(column(
    12,
    shiny::HTML(
      '<center><img src="entrada_inta_anguil.png"></center><br>'
    ),
    
  )),
  
  # botones en la parte inferior de la página
  fluidRow(
    column(3),
    column(
      6,
      actionButton(inputId = ns("btnHistorico"), label = "Historico"),
      actionButton(inputId = ns("btnAnguil"), label = "Anguil"),
      actionButton(inputId = ns("btnCartografia"), label = "Cartografía"),
      actionButton(inputId = ns("btnAgromet"), label = "Funciones Agromet"),
      actionButton(inputId = ns("btnLink"), label = "Links"),
      actionButton(inputId = ns("btnPublicaciones"), label = "Informes y Publicaciones"),
      actionButton(inputId = ns("btnEventos"), label = "Eventos"),
      actionButton(inputId = ns("btnRadar"), label = "Radar"),
      actionButton(inputId = ns("btnRadiacion"), label = "Radiación solar")
    ),
    column(3)
  ))
}

#################################
# SERVER
inicioServer <- function(input, output, session, parent_session) {
  
  # acciones sobre los botones
  
  observeEvent(input$btnHistorico, {
    updateTabsetPanel(session = parent_session,
                      inputId = "tabs",
                      selected = "historico")
  })
  
  observeEvent(input$btnAnguil, {
    updateTabsetPanel(session = parent_session,
                      inputId = "tabs",
                      selected = "anguil")
  })
  
  observeEvent(input$btnCartografia, {
    updateTabsetPanel(session = parent_session,
                      inputId = "tabs",
                      selected = "cartografia")
  })
  
  observeEvent(input$btnAgromet, {
    updateTabsetPanel(session = parent_session,
                      inputId = "tabs",
                      selected = "agromet")
  })
  
  observeEvent(input$btnLink, {
    updateTabsetPanel(session = parent_session,
                      inputId = "tabs",
                      selected = "links")
  })
  
  observeEvent(input$btnPublicaciones, {
    updateTabsetPanel(session = parent_session,
                      inputId = "tabs",
                      selected = "publicaciones")
  })
  
  observeEvent(input$btnEventos, {
    updateTabsetPanel(session = parent_session,
                      inputId = "tabs",
                      selected = "eventos")
  })
  
  observeEvent(input$btnRadar, {
    updateTabsetPanel(session = parent_session,
                      inputId = "tabs",
                      selected = "radar")
  })
  
  observeEvent(input$btnRadiacion, {
    updateTabsetPanel(session = parent_session,
                      inputId = "tabs",
                      selected = "radiacion")
  })
  
}
