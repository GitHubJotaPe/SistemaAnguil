FROM rocker/shiny:4.0.4
WORKDIR /home/shinyusr
COPY app.R app.R
COPY R/ R/
COPY data/ data/
COPY www/ www/
COPY deploy.R deploy.R
RUN install2.r rsconnect
RUN install2.r remotes
RUN R -e 'remotes::install_github("AgRoMeteorologiaINTA/agromet", build_vignettes = FALSE)'
CMD Rscript deploy.R