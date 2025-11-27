FROM rocker/verse:latest

WORKDIR /work

RUN R -e "install.packages(c('gridExtra', 'caret', 'randomForest', 'Polychrome'), dependencies=TRUE, repos='http://cran.rstudio.com/')"

