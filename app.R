#################################
# UI
ui <- navbarPage(
  id = "tabs",
  title =
    "Sistema Anguil",
  windowTitle = "Sistema Anguil",
  theme = shinytheme("superhero"),
  
  #################
  # Inicio
  tabPanel(
    title = " Inicio",
    icon = icon("home"),
    inicioUI(id = "inicio")
  ),
  
  #################
  # Registros históricos y Climatología Anguil
  navbarMenu(
    title = "Registros históricos",
    tabPanel(
      title = "Registro Histórico",
      value = "historico",
      h1("Histórico"),
      historicoUI(id = "historico")
    ),
    tabPanel(title = "Climatología Anguil",
             value = "anguil",
             anguilUI(id = "anguil"))
  ),
  
  #################
  # Cartografía de variables agrometeorológicas
  tabPanel(
    title = "Cartografía",
    icon = icon("map-marked-alt"),
    value = "cartografia",
    h1("Cartografía de variables agrometeorológicas"),
    cartografiaUI(id = "cartografia")
  ),
  
  #################
  # Calcular índices agrometeorológicos
  tabPanel(
    title = "Calcular índices agrometeorológicos",
    icon = icon("calculator"),
    value = "agromet",
    agrometUI(id = "agromet")
  ),
  
  #################
  # Links
  tabPanel(
    title = "Links",
    icon = icon("link"),
    value = "links",
    linksUI(id = "links")
  ),
  
  #################
  # Informes técnicos y publicaciones
  tabPanel(
    title = "Informes técnicos y publicaciones",
    icon = icon("publicaciones"),
    value = "publicaciones",
    publicacionesUI(id = "publicaciones")
  ),
  
  #################
  # Eventos climáticos extremos
  tabPanel(
    title = "Eventos",
    icon = icon("eventos"),
    value = "eventos",
    eventosUI(id = "eventos")
  ),
  
  #################
  # Radar meteorológico
  tabPanel(
    title = "Radar",
    icon = icon("radar"),
    value = "radar",
    radarUI(id = "radar")
  ),
  
  #################
  # Radiación solar
  tabPanel(
    title = "Radiación solar",
    icon = icon("radiacion"),
    value = "radiacion",
    radiacionUI(id = "radiacion")
  )
  
)

#################################
# SERVER
server <- function(input, output, session) {
  #################
  # Inicio
  callModule(inicioServer, "inicio", parent_session = session)
  
  #################
  # historico
  historicoServer(id = "historico")
  
  #################
  # anguil
  anguilServer(id = "anguil")
  
  #################
  # cartografia
  cartografiaServer(id = "cartografia")
  
  #################
  # agromet
  agrometServer(id = "agromet")
  
  #################
  # links
  linksServer(id = "links")
  
  #################
  # publicaciones
  publicacionesServer(id = "publicaciones")
  
  #################
  # eventos
  eventosServer(id = "eventos")
  
  #################
  # radar
  radarServer(id = "radar")
  
}

shinyApp(ui = ui, server = server)
