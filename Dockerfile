FROM rocker/shiny:4.0.4
RUN install2.r rsconnect
WORKDIR /home/shinyusr
COPY app.R app.R
COPY R/ R/
COPY data/ data/
COPY www/ www/
COPY deploy.R deploy.R
RUN R -e 'remotes::install_github("AgRoMeteorologiaINTA/agromet", build_vignettes = FALSE)'
CMD Rscript deploy.R