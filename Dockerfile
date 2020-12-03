# Modified from: https://juanitorduz.github.io/dockerize-a-shinyapp/
# Added: install shiny server new package https://stackoverflow.com/questions/52377910/how-to-find-shiny-server-executable-and-reference-it-in-shiny-server-sh
# https://stackoverflow.com/questions/57421577/how-to-run-r-shiny-app-in-docker-container
# Used: https://www.statworx.com/de/blog/how-to-dockerize-shinyapps/
# Configuration setup from: https://github.com/kwhitehall/Shiny_app_Azure/blob/master/Dockerfile

FROM rocker/shiny:latest

# system libraries of general use -> Ubuntu packages
RUN apt-get update && apt-get install -y \
    sudo \
    pandoc \
    pandoc-citeproc \
    libcurl4-gnutls-dev \
    libcairo2-dev \
    libxt-dev \
    libssl-dev \
    libssh2-1-dev \
    iputils-ping \
    libxml2 \
    nano \
    libsodium-dev \
    libsecret-1-dev \
    openjdk-8-jre

# Set openjdk environment variable
ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-amd64 

## update system libraries
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean

COPY run_epitweetr.R /srv/shiny-server/
RUN mkdir /srv/shiny-server/twitter_data

# install renv & restore packages
RUN Rscript -e 'install.packages("renv")'
RUN Rscript -e 'install.packages("epitweetr",dependencies = TRUE)'
RUN Rscript -e 'install.packages("tinytex"); tinytex::install_tinytex()'
RUN Rscript -e 'renv::restore()' 

# Port 
EXPOSE 3838

# Copy further configuration files into the Docker image
COPY shiny-server.sh /usr/bin/shiny-server.sh

RUN ["chmod", "+x", "/usr/bin/shiny-server.sh"]

# allow permission
RUN sudo chmod -R 755 /srv/shiny-server

# run app
CMD ["R", "-e", "shiny::runApp('/srv/shiny-server/run_epitweetr.R', host = '0.0.0.0', port = 3838)"]