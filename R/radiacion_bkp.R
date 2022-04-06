# #################################
# # UI
# radiacionUI <- function(id) {
#   ns <- NS(id)
#   
#   tagList(
#     tags$h1("Radiación solar"),
#     
#     navlistPanel(
#       widths = c(3, 9),
#       
#       tabPanel(
#         "Enero",
#         "RD_promedio_Enero.png",
#         tags$iframe(style = "height:800px; width:100%; scrolling=yes",
#                     src = "./radiacion/RD_promedio_Enero.png")
#       ),
#       tabPanel(
#         "Febrero",
#         "RD_promedio_Febrero.png",
#         tags$iframe(style = "height:800px; width:100%; scrolling=yes",
#                     src = "./radiacion/RD_promedio_Febrero.png")
#       ),
#       tabPanel(
#         "Marzo",
#         "RD_promedio_Marzo.png",
#         tags$iframe(style = "height:800px; width:100%; scrolling=yes",
#                     src = "./radiacion/RD_promedio_Marzo.png")
#       ),
#       tabPanel(
#         "Abril",
#         "RD_promedio_Abril.png",
#         tags$iframe(style = "height:800px; width:100%; scrolling=yes",
#                     src = "./radiacion/RD_promedio_Abril.png")
#       ),
#       tabPanel(
#         "Mayo",
#         "RD_promedio_Mayo.png",
#         tags$iframe(style = "height:800px; width:100%; scrolling=yes",
#                     src = "./radiacion/RD_promedio_Mayo.png")
#       ),
#       tabPanel(
#         "Junio",
#         "RD_promedio_Junio.png",
#         tags$iframe(style = "height:800px; width:100%; scrolling=yes",
#                     src = "./radiacion/RD_promedio_Junio.png")
#       ),
#       tabPanel(
#         "Julio",
#         "RD_promedio_Julio.png",
#         tags$iframe(style = "height:800px; width:100%; scrolling=yes",
#                     src = "./radiacion/RD_promedio_Julio.png")
#       ),
#       tabPanel(
#         "Agosto",
#         "RD_promedio_Agosto.png",
#         tags$iframe(style = "height:800px; width:100%; scrolling=yes",
#                     src = "./radiacion/RD_promedio_Agosto.png")
#       ),
#       tabPanel(
#         "Septiembre",
#         "RD_promedio_Septiembre.png",
#         tags$iframe(style = "height:800px; width:100%; scrolling=yes",
#                     src = "./radiacion/RD_promedio_Septiembre.png")
#       ),
#       tabPanel(
#         "Octubre",
#         "RD_promedio_Octubre.png",
#         tags$iframe(style = "height:800px; width:100%; scrolling=yes",
#                     src = "./radiacion/RD_promedio_Octubre.png")
#       ),
#       tabPanel(
#         "Noviembre",
#         "RD_promedio_Noviembre.png",
#         tags$iframe(style = "height:800px; width:100%; scrolling=yes",
#                     src = "./radiacion/RD_promedio_Noviembre.png")
#       ),
#       tabPanel(
#         "Diciembre",
#         "RD_promedio_Diciembre.png",
#         tags$iframe(style = "height:800px; width:100%; scrolling=yes",
#                     src = "./radiacion/RD_promedio_Diciembre.png")
#       ),
#       tabPanel(
#         
#         "info",
#         tags$iframe(style = "height:800px; width:100%; scrolling=yes",
#                     src = "./radiacion/radiacion.png")
#       ),
#       "ATLAS DE ENERGIA SOLAR",
#       "RADIACIÓN SOLAR PROMEDIO MENSUAL Y ANUAL DE LA PAMPA HUMEDA",
#       "",
#       
#       tabPanel(
#         "ANUAL",
#         "RD_promedio_Anual.png",
#         tags$iframe(style = "height:800px; width:100%; scrolling=yes",
#                     src = "./radiacion/RD_promedio_Anual.png")
#       ),
#       
#       
#       "MAPAS DE RADIACION SOLAR MENSUAL",
#       
#       tabPanel(
#         "AÑO 2021",
#         "Radiacion_solar_Agosto_2021.jpg",
#         tags$iframe(style = "height:800px; width:100%; scrolling=yes",
#                     src = "./radiacion/Radiacion_solar_Agosto_2021.jpg")
#       )
#       
#     )
#     
#   )
# }
# 
# #################################
# # SERVER
# radiacionServer <- function(id) {
#   moduleServer(id,
#                function(input, output, session) {
#                  
#                })
# }
