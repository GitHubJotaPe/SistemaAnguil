FROM rocker/shiny:4.0.4
WORKDIR /home/shinyusr
# Copiado de archivos adentro del la imagen
COPY app.R app.R
COPY R/ R/
COPY data/ data/
COPY www/ www/
COPY deploy.R deploy.R
# Instalación de dependencias de R
RUN install2.r rsconnect
RUN install2.r remotes
# Instalación de software del INTA
RUN R -e 'remotes::install_github("AgRoMeteorologiaINTA/agromet", build_vignettes = FALSE)'
RUN R -e 'remotes::install_github("AgRoMeteorologiaINTA/siga", build = FALSE)'
# Deploy de la aplicación
CMD Rscript deploy.R