FROM jenslaufer/python-r:py37

RUN R -e "devtools::install_github('jenslaufer/sample-r-library-reducer')"