FROM rocker/geospatial
RUN install2.r --error \
    --deps TRUE \
    epitweetr
# make dir
RUN mkdir -p /src/
COPY /src    /src
WORKDIR /src
