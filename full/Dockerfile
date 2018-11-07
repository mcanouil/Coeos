FROM mcanouil/coeos:base


### Install R packages
RUN R -e " \
    install.packages( \
      c('udunits2', 'units', 'devtools'), \
      quiet = TRUE, \
      configure.args = '--with-udunits2-lib=/usr/local/lib' \
    );" \
  && install.r \
    docopt \
    tidyverse \
    shiny \
    viridis \
    readxl \
    writexl \
    qdap \
    Hmisc \
    kableExtra \
    ggrepel \
    ggsignif \
    ggthemes \
    ggnetwork \
    ggridges \
    qqplotr \
    ggdendro \
    ggExtra \
    ggpubr \
    ggbeeswarm \
    ggraph \
    ggpmisc \
    caTools \
    devtools \
    styler \
    conflicted \
    benchr \
    gifski \
    DT \
    pwr \
    glmnet \
    reshape \
    git2r \
    bookdown \
    DBI \
    RMariaDB \
    mongolite \
    officer \
    av \
    remotes \
    pryr \
    odbc\
    roxygen2 \
    shinydashboard \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds
  

### Install R packages from GitHub
RUN installGithub.r \
  gabraham/flashpca/flashpcaR \
  dreamRs/prefixer \
  thomasp85/tweenr \
  thomasp85/transformr \
  thomasp85/gganimate \
  && rm -rf /tmp/downloaded_packages/ /tmp/*.rds \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/


### Install Bioconductor packages
# RUN install.r BiocManager \
  # && R -e " \
  # BiocManager::install(ask = FALSE, version = Sys.getenv('BIOCONDUCTOR_VERSION')); \
    # BiocManager::install(c( \
      # 'HDF5Array', \
      # 'minfi', \
      # 'ChAMP', \
      # 'tximport', \
      # 'DESeq2', \
      # 'biomaRt', \
      # 'NanoStringDiff', \ 
      # 'ENmix', \
      # 'hgu133plus2.db', \
      # 'snpStats', \
      # 'IlluminaHumanMethylationEPICanno.ilm10b2.hg19', \
      # 'IlluminaHumanMethylationEPICanno.ilm10b3.hg19', \
      # 'IlluminaHumanMethylationEPICanno.ilm10b4.hg19', \
      # 'MafDb.gnomAD.r2.1.hs37d5', \
      # 'FlowSorted.Blood.EPIC', \
      # 'FlowSorted.CordBlood.450k' \
    # ), ask = FALSE, update = TRUE);" \
    # && rm -rf /tmp/downloaded_packages/ /tmp/*.rds


EXPOSE 8787


CMD ["sh /home/boot.sh"]
