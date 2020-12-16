FROM rocker/rstudio:latest 

## update system libraries
RUN apt-get update && \
    apt-get upgrade -y && \
    apt-get clean

# Install dependencies for system and epitweetr
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
    openjdk-8-jre \ 
    gnupg2 \ 
    curl
#    nginx

# Install sbt 
RUN echo "deb https://dl.bintray.com/sbt/debian /" | sudo tee -a /etc/apt/sources.list.d/sbt.list
RUN sudo apt-key adv --keyserver hkp://keyserver.ubuntu.com:80 --recv 642AC823
RUN sudo apt-get update
RUN sudo apt-get install sbt

# Set openjdk environment variable
ENV JAVA_HOME /usr/lib/jvm/java-1.8.0-openjdk-amd64 

# install renv & restore packages
RUN Rscript -e 'install.packages("renv")'
RUN Rscript -e 'install.packages("tinytex"); tinytex::install_tinytex()'
RUN Rscript -e 'install.packages("epitweetr",dependencies = TRUE)'
RUN Rscript -e 'renv::restore()'

# Make the directory where you will store the tweets 
RUN mkdir /home/rstudio/tweets

# Import the necessary files into the container
COPY epitweetr_app.r /home/rstudio/
COPY detect_loop.sh /home/rstudio/
COPY search_loop.sh /home/rstudio/
COPY INSTRUCTIONS.txt /home/rstudio/

RUN chmod 777 /home/rstudio
RUN chmod 777 /home/rstudio/tweets