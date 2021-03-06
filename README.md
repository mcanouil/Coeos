
# Coeos Docker Image <img src="login_page/logo.png" align="right" width="120" />

  - BUILD\_DATE: `2020-01-24`  
  - R: `v3.6.2`  
  - BIOCONDUCTOR: `v3.10`  
  - SHINY: `v1.5.12.933`  
  - RSTUDIO: `v1.2.5019`

## Build Docker image

### Development

``` bash
docker build --tag mcanouil/coeos:dev --compress

docker push mcanouil/coeos:dev
```

### Stable

``` bash
R_VERSION=362

docker tag mcanouil/coeos:dev mcanouil/coeos:${R_VERSION} \
  && docker push mcanouil/coeos:${R_VERSION}
  
docker tag mcanouil/coeos:${R_VERSION} mcanouil/coeos:latest \
  && docker push mcanouil/coeos:latest
```

### Run Docker container

``` bash
docker run \
  --name coeos \
  --hostname tartarus \
  --detach \
  --publish 8888:8787 \
  mcanouil/coeos:latest
```
