FROM library/debian


ENV R_VERSION=3.6.0
ENV RSTUDIO_VERSION=1.2.1335
ENV S6_VERSION=v1.21.7.0
ENV PANDOC_TEMPLATES_VERSION=2.6
ENV S6_BEHAVIOUR_IF_STAGE2_FAILS=2

ENV PATH=/usr/lib/rstudio-server/bin:$PATH

COPY login.html /etc/rstudio/login.html
COPY logo.png /usr/lib/rstudio-server/www/images/logo.png
COPY wallpaper.png /usr/lib/rstudio-server/www/images/wallpaper.png
COPY bashrc /etc/bash.bashrc
COPY add_user.sh /home/add_user.sh
COPY packages.R /tmp/packages.R

### Add default user
RUN sh /home/add_user.sh Coeos Coeos 2705


### Install linux libraries
RUN apt-get update \
  && apt-get install -y --no-install-recommends locales \
  && sed -i '/^#.* en_US.* /s/^#//' /etc/locale.gen \
  && sed -i '/^#.* en_GB.* /s/^#//' /etc/locale.gen \
  && locale-gen \
  && export LANG="en_GB.UTF-8" \
  && export LANGUAGE="en_GB.UTF-8" \
  && export LC_CTYPE="en_GB.UTF-8" \
  && export LC_NUMERIC="en_GB.UTF-8" \
  && export LC_TIME="en_GB.UTF-8" \
  && export LC_COLLATE="en_GB.UTF-8" \
  && export LC_MONETARY="en_GB.UTF-8" \
  && export LC_MESSAGES="en_GB.UTF-8" \
  && export LC_PAPER="en_GB.UTF-8" \
  && export LC_NAME="en_GB.UTF-8" \
  && export LC_ADDRESS="en_GB.UTF-8" \
  && export LC_TELEPHONE="en_GB.UTF-8" \
  && export LC_MEASUREMENT="en_GB.UTF-8" \
  && export LC_IDENTIFICATION="en_GB.UTF-8" \
  && export LC_ALL="en_GB.UTF-8" \
  && /usr/sbin/update-locale LANG=en_GB.UTF-8 \
  && apt-get install -y --no-install-recommends nano 

ENV LC_ALL=en_GB.UTF-8
ENV LANGUAGE=en_GB.UTF-8
ENV LANG=en_GB.UTF-8

RUN apt-get install -y --no-install-recommends \
    bash-completion \
    ca-certificates \
    file \
    fonts-texgyre \
    g++ \
    gfortran \
    gsfonts \
    libblas-dev \
    libbz2-1.0 \
    libcurl3 \
    libicu57 \
    libjpeg62-turbo \
    libopenblas-dev \
    libpangocairo-1.0-0 \
    libpcre3 \
    libpng16-16 \
    libreadline7 \
    libtiff5 \
    liblzma5 \
    locales \
    make \
    unzip \
    zip \
    zlib1g \
  ## R additional
  && BUILDDEPS="curl \
    default-jdk \
    libbz2-dev \
    libcairo2-dev \
    libcurl4-openssl-dev \
    libpango1.0-dev \
    libjpeg-dev \
    libicu-dev \
    libpcre3-dev \
    libpng-dev \
    libreadline-dev \
    libtiff5-dev \
    liblzma-dev \
    libx11-dev \
    libxt-dev \
    perl \
    tcl8.6-dev \
    tk8.6-dev \
    texinfo \
    x11proto-core-dev \
    xauth \
    xfonts-base \
    xvfb \
    zlib1g-dev \
    texlive-base \
    texlive-lang-french \
    texlive-lang-english \
    texlive-latex-base \
    texlive-latex-recommended \
    texlive-latex-extra \
    texlive-font-utils \
    texlive-fonts-recommended \
    texlive-fonts-extra \
    texlive-generic-recommended \
    texlive-generic-extra \
    texlive-plain-extra \
    texlive-binaries \
    texlive-luatex \
    texlive-metapost \
    texlive-omega \
    texlive-htmlxml \
    texlive-pictures \
    texlive-xetex \
    texlive-extra-utils \
    texlive-games \
    texlive-humanities \
    texlive-music \
    texlive-pstricks \
    texlive-publishers \
    texlive-science \
    texlive-bibtex-extra \
    texlive-formats-extra \
    lmodern" \
  && apt-get install -y --no-install-recommends $BUILDDEPS \
  ## Rstudio
  && apt-get install -y --no-install-recommends \
    file \
    git \
    libapparmor1 \
    curl \
    tar \
    libcurl4-openssl-dev \
    libedit2 \
    libssl-dev \
    lsb-release \
    psmisc \
    procps \
    python-setuptools \
    sudo \
    wget \
  ## R packages
  && apt-get install -y --no-install-recommends \
    libudunits2-dev \
    libxml2-dev \
    libgdal-dev \
    cargo \
    ffmpeg \
    libavfilter-dev \
    libmagick++-dev \
    pandoc \
    pandoc-citeproc \
    qpdf \
  ## git config
  && git config --system core.sharedRepository 0755 \
  && git config --system credential.helper "cache --timeout=3600" \
  && git config --system core.editor "nano -w" \
  && git config --system color.ui auto \
  && cd tmp/ \
  ## Download source code
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
  && echo "options(repos = c(CRAN = 'https://cran.rstudio.com/'), download.file.method = 'libcurl')" >> /usr/local/lib/R/etc/Rprofile.site \
  ## Add a library directory (for user-installed packages)
  && mkdir -p /usr/local/lib/R/site-library \
  && chown root:staff /usr/local/lib/R/site-library \
  && chmod g+wx /usr/local/lib/R/site-library \
  ## Fix library path
  && echo "R_LIBS_USER='/usr/local/lib/R/site-library'" >> /usr/local/lib/R/etc/Renviron \
  && echo "R_LIBS=\${R_LIBS-'/usr/local/lib/R/site-library:/usr/local/lib/R/library:/usr/lib/R/library'}" >> /usr/local/lib/R/etc/Renviron \
  ## install packages from date-locked MRAN snapshot of CRAN
  # && [ -z "$BUILD_DATE" ] && BUILD_DATE=$(TZ="America/Los_Angeles" date -I) || true \
  # && MRAN=https://mran.microsoft.com/snapshot/${BUILD_DATE} \
  # && echo MRAN=$MRAN >> /etc/environment \
  # && export MRAN=$MRAN \
  # && echo "options(repos = c(CRAN='$MRAN'), download.file.method = 'libcurl')" >> /usr/local/lib/R/etc/Rprofile.site \
  ## Use littler installation scripts
  # && Rscript -e "install.packages(c('littler', 'docopt'), repo = '$MRAN')" \
  # && ln -s /usr/local/lib/R/site-library/littler/examples/install2.r /usr/local/bin/install2.r \
  # && ln -s /usr/local/lib/R/site-library/littler/examples/installGithub.r /usr/local/bin/installGithub.r \
  # && ln -s /usr/local/lib/R/site-library/littler/bin/r /usr/local/bin/r \
  ## Install R packages
  && Rscript /tmp/packages.R 


## Install Rstudio
RUN apt-get update \
  && apt-get install -y --no-install-recommends libclang-dev \
  && wget -O libssl1.0.0.deb http://ftp.debian.org/debian/pool/main/o/openssl/libssl1.0.0_1.0.1t-1+deb8u8_amd64.deb \
  && dpkg -i libssl1.0.0.deb \
  && rm libssl1.0.0.deb \
  && RSTUDIO_LATEST=$(wget --no-check-certificate -qO- https://s3.amazonaws.com/rstudio-server/current.ver) \
  && [ -z "$RSTUDIO_VERSION" ] && RSTUDIO_VERSION=$RSTUDIO_LATEST || true \
  && wget -q http://download2.rstudio.org/server/debian9/x86_64/rstudio-server-${RSTUDIO_VERSION}-amd64.deb \
  && dpkg -i rstudio-server-${RSTUDIO_VERSION}-amd64.deb \
  && rm rstudio-server-*-amd64.deb \
  ## Symlink pandoc & standard pandoc templates for use system-wide
  && ln -s /usr/lib/rstudio-server/bin/pandoc/pandoc /usr/local/bin \
  && ln -s /usr/lib/rstudio-server/bin/pandoc/pandoc-citeproc /usr/local/bin \
  && git clone --recursive --branch ${PANDOC_TEMPLATES_VERSION} https://github.com/jgm/pandoc-templates \
  && mkdir -p /opt/pandoc/templates \
  && cp -r pandoc-templates*/* /opt/pandoc/templates && rm -rf pandoc-templates* \
  && mkdir /root/.pandoc && ln -s /opt/pandoc/templates /root/.pandoc/templates \
  && apt-get clean \
  && rm -rf /var/lib/apt/lists/ \
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
  #   ## Need to configure non-root user for RStudio
  #   && useradd rstudio \
  #   && echo "rstudio:rstudio" | chpasswd \
  # 	&& mkdir /home/rstudio \
  # 	&& chown rstudio:rstudio /home/rstudio \
  # 	&& addgroup rstudio staff \
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
  && addgroup rstudio-server staff \
  && usermod -g staff rstudio-server \
  && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
  ## Clean up from R source install
  && cd / \
  && rm -rf /tmp/* \
  && apt-get remove --purge -y $BUILDDEPS \
  && apt-get autoremove -y \
  && apt-get autoclean -y \
  && rm -rf /var/lib/apt/lists/* \ 
  && echo '#!/bin/bash \
          \n \
          \n# start rstudio server \
          \nrstudio-server start \
          \n \
          \n# infinite loop for container never stop \
          \ntail -f /dev/null' \
    > /home/boot.sh


### Add xkcd
RUN git clone https://github.com/ipython/xkcd-font.git /usr/share/fonts/xkcd-font \
  && fc-cache -f -v \
  && Rscript -e 'utils::install.packages(pkgs = c("showtext", "xkcd"), quiet = TRUE)' \
  && Rscript -e 'sysfonts::font_add("xkcd", "xkcd.otf")' \
  && Rscript -e 'sysfonts::font_add("xkcd_regular", "xkcd-Regular.otf")' \
  && Rscript -e 'sysfonts::font_add("xkcd_script", "xkcd-script.ttf")'
  

EXPOSE 8787


CMD ["/bin/sh", "/home/boot.sh"]
