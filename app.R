##############################
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
    icon = icon("home",verify_fa = FALSE),
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
    icon = icon("map-marked-alt",verify_fa = FALSE),
    value = "cartografia",
    h1("Cartografía de variables agrometeorológicas"),
    cartografiaUI(id = "cartografia")
  ),
  
  # #################
  # # Calcular índices agrometeorológicos
  # tabPanel(
  #   title = "Calcular índices agrometeorológicos",
  #   icon = icon("calculator"),
  #   value = "agromet",
  #   agrometUI(id = "agromet")
  # ),
  
  #################
  # Registros históricos y Climatología Anguil
  navbarMenu(
    title = "Índices Agrometeorológicos",
    tabPanel(
      title = "Estadística Básica",
      value = "agromet_basica",
      agroBasicaUI(id = "agromet_basica")
    ),
    tabPanel(
      title = "Índices",
      value = "agromet_indices",
      agroIndicesUI(id = "agromet_indices")
    )
  ),
  
  #################
  # Links
  tabPanel(
    title = "Links",
    icon = icon("link",verify_fa = FALSE),
    value = "links",
    linksUI(id = "links")
  ),
  
  #################
  # Informes técnicos y publicaciones
  tabPanel(
    title = "Informes técnicos y publicaciones",
    icon = icon("publicaciones",verify_fa = FALSE),
    value = "publicaciones",
    publicacionesUI(id = "publicaciones")
  ),
  
  #################
  # Eventos climáticos extremos
  tabPanel(
    title = "Eventos",
    icon = icon("eventos",verify_fa = FALSE),
    value = "eventos",
    eventosUI(id = "eventos")
  ),
  
  #################
  # Radar meteorológico
  tabPanel(
    title = "Radar",
    icon = icon("radar",verify_fa = FALSE),
    value = "radar",
    radarUI(id = "radar")
  ),
  
  #################
  # Radiación solar
  tabPanel(
    title = "Radiación solar",
    icon = icon("radiacion",verify_fa = FALSE),
    value = "radiacion",
    radiacionUI(id = "radiacion")
  ),
  
  #################
  # REPOSITORIO DIGITAL DE ARCHIVOS DE CARTOGRAFIA
  tabPanel(
    title = "Repositorio digital de archivos de cartografía",
    icon = icon("",verify_fa = FALSE),
    value = "gis",
    gisUI(id = "gis")
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
  #agrometServer(id = "agromet")
  agroBasicaServer(id = "agromet_basica")
  agroIndicesServer(id = "agromet_indices")
  
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
  
  #################
  # gis
  gisServer(id = "gis")
  
}

shinyApp(ui = ui, server = server)
