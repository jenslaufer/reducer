FROM python:3.7-slim-buster

RUN apt-get update && apt-get install -y r-base

RUN R -e "install.packages(c('tidyverse', 'lubridate', 'devtools'), repos = 'http://cran.us.r-project.org')"
RUN R -e "install.github('jenslaufer/reducer')"