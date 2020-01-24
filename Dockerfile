FROM library/debian:stretch


ENV BUILD_DATE=2020-01-24
ENV START_RSTUDIO=true
ENV START_SHINY=false
ENV START_SSH=false


## Set locales to en_US
RUN apt-get update \
  && apt-get install -y --no-install-recommends locales \
  && sed -i '/^#.* en_US.* /s/^#//' /etc/locale.gen \
  && sed -i '/^#.* en_GB.* /s/^#//' /etc/locale.gen \
  && locale-gen \
  && export LANG="en_US.UTF-8" \
  && export LANGUAGE="en_US.UTF-8" \
  && export LC_CTYPE="en_US.UTF-8" \
  && export LC_NUMERIC="en_US.UTF-8" \
  && export LC_TIME="en_US.UTF-8" \
  && export LC_COLLATE="en_US.UTF-8" \
  && export LC_MONETARY="en_US.UTF-8" \
  && export LC_MESSAGES="en_US.UTF-8" \
  && export LC_PAPER="en_US.UTF-8" \
  && export LC_NAME="en_US.UTF-8" \
  && export LC_ADDRESS="en_US.UTF-8" \
  && export LC_TELEPHONE="en_US.UTF-8" \
  && export LC_MEASUREMENT="en_US.UTF-8" \
  && export LC_IDENTIFICATION="en_US.UTF-8" \
  && export LC_ALL="en_US.UTF-8"


## Set environment variable for version and locales
ENV R_VERSION=3.6.2
ENV BIOCONDUCTOR_VERSION=3.10
ENV SHINY_VERSION=1.5.12.933
ENV RSTUDIO_VERSION=1.2.5019
ENV GCTA_VERSION=gcta_1.92.3beta3
ENV PANDOC_TEMPLATES_VERSION=2.6
ENV S6_VERSION=v1.21.7.0
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2

ENV PATH=/usr/lib/rstudio-server/bin:$PATH

ENV LC_ALL=en_US.UTF-8
ENV LANGUAGE=en_US.UTF-8
ENV LANG=en_US.UTF-8


## Install libraries
RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    autoconf \ 
    automake \ 
    bash-completion \ 
    build-essential \ 
    ca-certificates \ 
    cargo \ 
    curl \ 
    default-jdk \ 
    fastqtl \ 
    ffmpeg \ 
    file \ 
    fonts-texgyre \ 
    g++ \ 
    gdebi \
    gfortran \ 
    git \ 
    gsfonts \ 
    htop \ 
    libapparmor1 \ 
    libavfilter-dev \ 
    libblas-dev \ 
    libbz2-1.0 \ 
    libbz2-dev \ 
    libcairo2-dev \ 
    libclang-3.8-dev \ 
    libclang-common-3.8-dev \ 
    libclang-dev \ 
    libclang1-3.8 \ 
    libcurl4-openssl-dev \ 
    libedit2 \ 
    libgc1c2 \ 
    libgdal-dev \ 
    libgsl-dev \ 
    libicu-dev \ 
    libio-socket-ssl-perl \ 
    libjpeg-dev \ 
    libjpeg62-turbo \ 
    libllvm3.8 \ 
    liblzma-dev \ 
    liblzma5 \ 
    libmagick++-dev \ 
    libobjc-6-dev \ 
    libobjc4 \ 
    libopenblas-dev \ 
    libpango1.0-dev \ 
    libpangocairo-1.0-0 \ 
    libpcre3 \ 
    libpcre3-dev \ 
    libpng-dev \ 
    libpng16-16 \ 
    libreadline-dev \ 
    libreadline7 \ 
    librsvg2-dev \ 
    libsasl2-dev \ 
    libssl-dev \ 
    libtiff5 \ 
    libtiff5-dev \ 
    libudunits2-dev \ 
    libv8-dev \ 
    libx11-dev \ 
    libxml2-dev \ 
    libxt-dev \ 
    lmodern \ 
    lsb-release \ 
    make \ 
    man-db \ 
    multiarch-support \ 
    nano \
    openssh-client \ 
    pandoc \ 
    pandoc-citeproc \ 
    perl \ 
    phantomjs \ 
    plink1.9 \ 
    procps \ 
    psmisc \ 
    python-setuptools \ 
    qpdf \ 
    sudo \ 
    tar \ 
    tcl8.6-dev \ 
    texinfo \ 
    texlive-base \ 
    texlive-bibtex-extra \ 
    texlive-font-utils \ 
    texlive-fonts-extra \ 
    texlive-fonts-recommended \ 
    texlive-formats-extra \ 
    texlive-generic-extra \ 
    texlive-generic-recommended \ 
    texlive-lang-english \ 
    texlive-lang-french \ 
    texlive-latex-base \ 
    texlive-latex-extra \ 
    texlive-latex-recommended \ 
    texlive-plain-extra \ 
    tk8.6-dev \ 
    unzip \ 
    vcftools \ 
    wget \ 
    x11proto-core-dev \ 
    xauth \ 
    xclip \ 
    xfonts-base \ 
    xtail \
    xvfb \ 
    zip \ 
    zlib1g \ 
    zlib1g-dev


## Install libraries for databases
RUN apt-get update \
  && apt-get install -y --install-suggests \
    tdsodbc \
    odbc-postgresql \
    libsqliteodbc \
    unixodbc \
    unixodbc-dev \
  && cd /tmp \
  && wget https://dev.mysql.com/get/Downloads/Connector-ODBC/8.0/mysql-connector-odbc-8.0.13-linux-debian9-x86-64bit.tar.gz \
  && tar -xvf mysql-connector-odbc-8.0.13-linux-debian9-x86-64bit.tar.gz \
  && cd mysql-connector-odbc-8.0.13-linux-debian9-x86-64bit \
  && cp bin/* /usr/local/bin \
  && cp lib/* /usr/local/lib \
  && myodbc-installer -a -d -n "MySQL ODBC 8.0 Driver" -t "Driver=/usr/local/lib/libmyodbc8w.so" \
  && cd /tmp \
  && rm -Rf mysql-connector-odbc-8.0.13-linux-debian9-x86-64bit*
  
  
## Install BCFTOOLS
RUN cd /tmp \
  && git clone git://github.com/samtools/htslib.git \
  && cd /tmp/htslib \
  && autoheader \
  && autoconf \
  && ./configure --prefix=/usr \
  && make \
  && make install \
  && cd /tmp \
  && git clone git://github.com/samtools/bcftools.git \
  && cd /tmp/bcftools \
  && autoheader \
  && autoconf \
  && ./configure --prefix=/usr \
  && make \
  && make install \
  && cd /tmp \
  && rm -rf htslib bcftools 


## Install gcta
RUN cd /tmp \
  && wget http://cnsgenomics.com/software/gcta/bin/${GCTA_VERSION}.zip \
  && unzip ${GCTA_VERSION}.zip \
  && cp ${GCTA_VERSION}/gcta64 /usr/bin/ \
  && rm -rf gcta_*


## Configure git
RUN git config --system core.sharedRepository 0775 \
  && git config --system credential.helper "cache --timeout=3600" \
  && git config --system push.default simple \
  && git config --system core.editor "nano -w" \
  && git config --system color.ui auto 
  

## Install R
RUN cd /tmp \
  && curl -O https://cran.r-project.org/src/base/R-3/R-${R_VERSION}.tar.gz \
  ## Extract source code
  && tar -zxvf R-${R_VERSION}.tar.gz \
  && cd R-${R_VERSION} \
  ## Set compiler flags
  && R_PAPERSIZE=a4 \
    R_BATCHSAVE="--no-save --no-restore" \
    R_BROWSER=xdg-open \
    PAGER=/usr/bin/pager \
    PERL=/usr/bin/perl \
    R_UNZIPCMD=/usr/bin/unzip \
    R_ZIPCMD=/usr/bin/zip \
    R_PRINTCMD=/usr/bin/lpr \
    LIBnn=lib \
    AWK=/usr/bin/awk \
    CFLAGS="-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -D_FORTIFY_SOURCE=2 -g" \
    CXXFLAGS="-g -O2 -fstack-protector-strong -Wformat -Werror=format-security -Wdate-time -D_FORTIFY_SOURCE=2 -g" \
  ## Configure options
  ./configure --enable-R-shlib \
              --enable-memory-profiling \
              --with-readline \
              --with-blas \
              --with-tcltk \
              --disable-nls \
              --with-recommended-packages \
  ## Build and install
  && make \
  && make install \
  ## Add a default CRAN mirror
  && [ -z "$BUILD_DATE" ] && BUILD_DATE=$(TZ="America/Los_Angeles" date -I) || true \
  && MRAN=https://mran.microsoft.com/snapshot/${BUILD_DATE} \
  && echo MRAN=$MRAN >> /etc/environment \
  && export MRAN=$MRAN \
  && echo "options(repos = c(CRAN='$MRAN'), download.file.method = 'libcurl')" >> /usr/local/lib/R/etc/Rprofile.site \
  # && echo "options(repos = c(CRAN = 'https://cran.rstudio.com/'), download.file.method = 'libcurl')" >> /usr/local/lib/R/etc/Rprofile.site \
  ## Add a library directory (for user-installed packages)
  && mkdir -p /usr/local/lib/R/site-library \
  && chown root:staff /usr/local/lib/R/site-library \
  && chmod g+wx /usr/local/lib/R/site-library \
  ## Fix library path
  && echo "R_LIBS_USER='/usr/local/lib/R/site-library'" >> /usr/local/lib/R/etc/Renviron \
  && echo "R_LIBS=\${R_LIBS-'/usr/local/lib/R/site-library:/usr/local/lib/R/library:/usr/lib/R/library'}" >> /usr/local/lib/R/etc/Renviron
  
  
## Install R packages
COPY packages.R /tmp/packages.R
RUN Rscript /tmp/packages.R 


## Install Rstudio server
RUN if [ -z "$RSTUDIO_VERSION" ]; then RSTUDIO_URL="https://www.rstudio.org/download/latest/stable/server/debian9_64/rstudio-server-latest-amd64.deb"; else RSTUDIO_URL="http://download2.rstudio.org/server/debian9/x86_64/rstudio-server-${RSTUDIO_VERSION}-amd64.deb"; fi \
  && wget -q $RSTUDIO_URL \
  && dpkg -i rstudio-server-*-amd64.deb \
  && rm rstudio-server-*-amd64.deb \
  ## Symlink pandoc & standard pandoc templates for use system-wide
  && ln -s /usr/lib/rstudio-server/bin/pandoc/pandoc /usr/local/bin \
  && ln -s /usr/lib/rstudio-server/bin/pandoc/pandoc-citeproc /usr/local/bin \
  && git clone --recursive --branch ${PANDOC_TEMPLATES_VERSION} https://github.com/jgm/pandoc-templates \
  && mkdir -p /opt/pandoc/templates \
  && cp -r pandoc-templates*/* /opt/pandoc/templates && rm -rf pandoc-templates* \
  && mkdir /root/.pandoc && ln -s /opt/pandoc/templates /root/.pandoc/templates \
  ## RStudio wants an /etc/R, will populate from $R_HOME/etc
  && mkdir -p /etc/R \
  ## Write config files in $R_HOME/etc
  && echo '\n\
    \n# Configure httr to perform out-of-band authentication if HTTR_LOCALHOST \
    \n# is not set since a redirect to localhost may not work depending upon \
    \n# where this Docker container is running. \
    \nif(is.na(Sys.getenv("HTTR_LOCALHOST", unset=NA))) { \
    \n  options(httr_oob_default = TRUE) \
    \n}' >> /usr/local/lib/R/etc/Rprofile.site \
  && echo "PATH=${PATH}" >> /usr/local/lib/R/etc/Renviron \
  ## Prevent rstudio from deciding to use /usr/bin/R if a user apt-get installs a package
  &&  echo 'rsession-which-r=/usr/local/bin/R' >> /etc/rstudio/rserver.conf \
  ## use more robust file locking to avoid errors when using shared volumes:
  && echo 'lock-type=advisory' >> /etc/rstudio/file-locks \
  ## Set up S6 init system
  && wget -P /tmp/ https://github.com/just-containers/s6-overlay/releases/download/${S6_VERSION}/s6-overlay-amd64.tar.gz \
  && tar xzf /tmp/s6-overlay-amd64.tar.gz -C / \
  && mkdir -p /etc/services.d/rstudio \
  && echo '#!/usr/bin/with-contenv bash \
          \n## load /etc/environment vars first: \
  		  \n for line in $( cat /etc/environment ) ; do export $line ; done \
          \n exec /usr/lib/rstudio-server/bin/rserver --server-daemonize 0' \
          > /etc/services.d/rstudio/run \
  && echo '#!/bin/bash \
          \n rstudio-server stop' \
          > /etc/services.d/rstudio/finish \
  && usermod -g staff rstudio-server \
  && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers


## Copy UMR logo and custom rstudio homepage
COPY login_page/login.html /etc/rstudio/login.html
COPY login_page/wallpaper.png /usr/lib/rstudio-server/www/images/wallpaper.png
COPY login_page/logo.png /usr/lib/rstudio-server/www/images/logo.png


## Instal Shiny server
RUN wget --no-verbose "https://download3.rstudio.org/ubuntu-14.04/x86_64/shiny-server-$SHINY_VERSION-amd64.deb" -O ss-latest.deb \
  && gdebi -n ss-latest.deb \
  && rm -f version.txt ss-latest.deb \
  && . /etc/environment \
  && cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/ \
  && usermod -g staff shiny \
  && usermod -a -G shiny shiny \
  && chown shiny:staff /var/lib/shiny-server  \
  && echo '### set locales \
    \nexport LANG="en_US.UTF-8" \
    \nexport LANGUAGE="en_US.UTF-8" \
    \nexport LC_CTYPE="en_US.UTF-8" \
    \nexport LC_NUMERIC="en_US.UTF-8" \
    \nexport LC_TIME="en_US.UTF-8" \
    \nexport LC_COLLATE="en_US.UTF-8" \
    \nexport LC_MONETARY="en_US.UTF-8" \
    \nexport LC_MESSAGES="en_US.UTF-8" \
    \nexport LC_PAPER="en_US.UTF-8" \
    \nexport LC_NAME="en_US.UTF-8" \
    \nexport LC_ADDRESS="en_US.UTF-8" \
    \nexport LC_TELEPHONE="en_US.UTF-8" \
    \nexport LC_MEASUREMENT="en_US.UTF-8" \
    \nexport LC_IDENTIFICATION="en_US.UTF-8" \
    \nexport LC_ALL="en_US.UTF-8"' > /home/shiny/.bashrc \
  && mkdir -p /var/log/shiny-server \
  && chown shiny:staff /var/log/shiny-server


## Add SSH server
RUN apt-get update \
  && apt-get install -y openssh-server \
  && mkdir -p /var/run/sshd


## Clean up install
RUN cd / \
  && rm -rf /tmp/* \
  && apt-get autoremove -y \
  && apt-get autoclean -y \
  && apt-get clean -y \
  && rm -rf /var/lib/apt/lists/


### Add xkcd
RUN git clone https://github.com/ipython/xkcd-font.git /usr/share/fonts/xkcd-font \
  && fc-cache -f -v \
  && Rscript -e 'utils::install.packages(pkgs = c("showtext", "xkcd"), quiet = TRUE)' \
  && Rscript -e 'sysfonts::font_add("xkcd", "xkcd.otf")' \
  && Rscript -e 'sysfonts::font_add("xkcd_regular", "xkcd-Regular.otf")' \
  && Rscript -e 'sysfonts::font_add("xkcd_script", "xkcd-script.ttf")'
  

### Add user 
ENV USER=Coeos

RUN useradd \
  --uid 2705 \
  --create-home \
  --home /home/${USER} \
  --no-user-group \
  --gid staff \
  --groups staff,root,sudo \
  ${USER} \
  && echo "${USER}:${USER}" | chpasswd \
  && mkdir -p /home/${USER}/.rstudio/monitored/user-settings

COPY home_config/.Rprofile /home/${USER}/.Rprofile
COPY home_config/.bash_profile /home/${USER}/.bash_profile
COPY home_config/.bashrc /home/${USER}/.bashrc
COPY home_config/user-settings /home/${USER}/.rstudio/monitored/user-settings/user-settings

RUN chown -R ${USER}:staff /home/${USER}


## Bash startup script
COPY boot.sh /home/boot.sh
RUN chmod 755 /home/boot.sh


EXPOSE 8787 3838 22


CMD ["/bin/bash", "/home/boot.sh"]
