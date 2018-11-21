utils::install.packages(
  pkgs = c(
    'udunits2', 'units', 'devtools', 'tidyverse', 'shiny', 'readxl', 'writexl', 
    'qdap', 'Hmisc', 'kableExtra', 'ggrepel', 'ggpubr', 'styler', 'conflicted', 
    'benchr', 'gifski', 'DT', 'bookdown', 'av', 'remotes', 'pryr', 'roxygen2' 
  ), 
  quiet = TRUE, 
  Ncpus = min(parallel::detectCores(), 5),
  dependencies = TRUE,
  configure.args = '--with-udunits2-lib=/usr/local/lib'
)

# BiocManager::install(ask = FALSE, version = Sys.getenv('BIOCONDUCTOR_VERSION'))
# BiocManager::install(
#   pkgs = c('biomaRt', 'snpStats'),
#   quiet = TRUE, 
#   Ncpus = min(parallel::detectCores(), 5),
#   ask = FALSE
# )

remotes::install_github(repo = "gabraham/flashpca/flashpcaR", quiet = TRUE)
remotes::install_github(repo = "dreamRs/prefixer", quiet = TRUE)
remotes::install_github(repo = "thomasp85/tweenr", quiet = TRUE)
remotes::install_github(repo = "thomasp85/transformr", quiet = TRUE)
remotes::install_github(repo = "thomasp85/gganimate", quiet = TRUE)
