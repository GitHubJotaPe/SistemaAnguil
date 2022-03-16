FROM rocker/shiny:4.0.4
RUN install2.r rsconnect
WORKDIR /home/shinyusr
COPY app.R app.R
COPY R/ R/
COPY data/ data/
COPY www/ www/
COPY deploy.R deploy.R
CMD Rscript deploy.R