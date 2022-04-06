library(shiny)
library(shinythemes)
library(agromet)
library(siga)
library(shinydashboard)
library(plotly)
library(RColorBrewer)
library(wesanderson)
#library(shinyjs)

# La parte izquierda es la que se ve por ejemplo en la tabla de historicos
# La parte derecha, es la que busca coincidencia en los nombres de la cartografía

mes_id <- c("ENE", "FEB","MAR", "ABR","MAY", "JUN","JUL", "AGO","SEP", "OCT", "NOV", "DIC")
mes_desc <- c("Enero", "Febrero", "Marzo", "Abril","Mayo", "Junio","Julio", "Agosto","Septiembre", "Octubre","Noviembre", "Diciembre")
meses_df <- data.frame(mes_id,mes_desc)
meses = setNames(meses_df$mes_id , meses_df$mes_desc)

direcciones_viento <- as_tibble(c("E","NE", "N","NO","O","SO","S","SE"))

# Para gromet
A872823 <-  siga::siga_datos("A872823") # Descarga de datos de Anguil
fecha_min_A872823 <- min(A872823$fecha) # Fecha minima del dataset
fecha_max_A872823 <- max(A872823$fecha) # Fecha maxima del dataset