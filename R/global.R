library(shiny)
library(shinythemes)
library(agromet)
library(siga)
library(shinydashboard)
library(plotly)
library(RColorBrewer)
library(wesanderson)

meses <-
  c(
    "ENE.",
    "FEB.",
    "MAR.",
    "ABR.",
    "MAY.",
    "JUN.",
    "JUL.",
    "AGO.",
    "SET.",
    "OCT.",
    "NOV.",
    "DIC."
  )

direcciones_viento <- as_tibble(c("E","NE", "N","NO","O","SO","S","SE"))

# Para gromet
A872823 <-  siga::siga_datos("A872823") # Descarga de datos de Anguil
fecha_min_A872823 <- min(A872823$fecha) # Fecha minima del dataset
fecha_max_A872823 <- max(A872823$fecha) # Fecha maxima del dataset