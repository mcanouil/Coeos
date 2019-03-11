FROM library/debian


ENV R_BASE_VERSION=3.5.3
ENV RSTUDIO_VERSION=1.1.463


### Install linux libraries
RUN echo "deb http://http.debian.net/debian sid main" > /etc/apt/sources.list.d/debian-unstable.list \
  && apt-get update \
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
  && export LC_ALL="en_GB.UTF-8"


ENV LC_ALL=en_GB.UTF-8
ENV LANGUAGE=en_GB.UTF-8
ENV LANG=en_GB.UTF-8


RUN apt-get update \
  && apt-get install -y --no-install-recommends \
    apt-utils \
    sudo \
    wget \
    curl \
    htop \
    nano \
    file \
    git \
    make \
    automake \
    autoconf \
    libxml2-dev \
    libcurl4-openssl-dev \
    libssl-dev \
    libcairo2-dev \
    libudunits2-dev \
    libgdal-dev \
    cargo \
    libv8-3.14-dev \
    libgit2-dev \
    libssh2-1-dev \
    default-jdk \
    libsasl2-dev \
    libapparmor1 \
    libedit2 \
    lsb-release \
    psmisc \
    python-setuptools \
    multiarch-support \
    ffmpeg \
    libavfilter-dev \
    libmagick++-dev \
    librsvg2-dev \
    libgsl-dev \
    build-essential \
  && apt-get install -y \
    texlive-base \
    texlive-lang-french \
    texlive-lang-english \
    texlive-latex-base \
    texlive-latex-recommended \
    texlive-latex-extra \
    texlive-font-utils \
    texlive-fonts-recommended \
    texlive-fonts-extra \
    texlive-fonts-extra-links \
    texlive-generic-recommended \
    texlive-generic-extra \
    texlive-plain-generic \
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
  && apt-get install -t unstable -y --no-install-recommends \
    r-base=${R_BASE_VERSION}* \
    r-base-dev=${R_BASE_VERSION}* \
    r-recommended=${R_BASE_VERSION}* \
  && rm -rf /var/lib/apt/lists/*


### Install rstudio-server
ENV PATH=/usr/lib/rstudio-server/bin:$PATH


RUN echo 'options(repos = c(CRAN = "https://cloud.r-project.org/"))' >> /etc/R/Rprofile.site \
  && wget -O libssl1.0.0.deb http://ftp.debian.org/debian/pool/main/o/openssl/libssl1.0.0_1.0.1t-1+deb8u8_amd64.deb \
  && dpkg -i libssl1.0.0.deb \
  && rm libssl1.0.0.deb \
  && RSTUDIO_LATEST=$(wget --no-check-certificate -qO- https://s3.amazonaws.com/rstudio-server/current.ver) \
  && [ -z "$RSTUDIO_VERSION" ] && RSTUDIO_VERSION=$RSTUDIO_LATEST || true \
  && wget -q http://download2.rstudio.org/rstudio-server-${RSTUDIO_VERSION}-amd64.deb \
  && dpkg -i rstudio-server-${RSTUDIO_VERSION}-amd64.deb \
  && rm rstudio-server-*-amd64.deb \
  && apt-get clean \
  && ln -s /usr/lib/rstudio-server/bin/pandoc/pandoc /usr/local/bin \
  && ln -s /usr/lib/rstudio-server/bin/pandoc/pandoc-citeproc /usr/local/bin \
  && git clone https://github.com/jgm/pandoc-templates \
  && mkdir -p /opt/pandoc/templates \
  && cp -r pandoc-templates*/* /opt/pandoc/templates && rm -rf pandoc-templates* \
  && mkdir /root/.pandoc && ln -s /opt/pandoc/templates /root/.pandoc/templates \
  && mkdir -p /etc/R \
  && echo 'lock-type=advisory' >> /etc/rstudio/file-locks \
  && git config --system credential.helper 'cache --timeout=3600' \
  && git config --system push.default simple \
  && wget -P /tmp/ https://github.com/just-containers/s6-overlay/releases/download/v1.11.0.1/s6-overlay-amd64.tar.gz \
  && tar xzf /tmp/s6-overlay-amd64.tar.gz -C / \
  && mkdir -p /etc/services.d/rstudio \
  && echo '#!/usr/bin/with-contenv bash \
  \nexec /usr/lib/rstudio-server/bin/rserver --server-daemonize 0' > /etc/services.d/rstudio/run \
  && echo '#!/bin/bash \
  \nrstudio-server stop' > /etc/services.d/rstudio/finish \
  && echo 'auth-login-page-html=/etc/rstudio/login.html' >> /etc/rstudio/rserver.conf \
  && addgroup rstudio-server staff \
  && usermod -g staff rstudio-server \
  && echo '%sudo ALL=(ALL) NOPASSWD:ALL' >> /etc/sudoers \
  && echo '#!/bin/bash \
  \n \
  \n# start rstudio server \
  \nrstudio-server start ' > /home/boot.sh


RUN echo '\n \
  \n# infinite loop for container never stop \
  \ntail -f /dev/null' >> /home/boot.sh
  
  
### Install R packages
COPY packages.R /tmp/packages.R

RUN Rscript /tmp/packages.R && rm -rf /tmp/*


### Copy files
COPY login.html /etc/rstudio/login.html
COPY logo.png /usr/lib/rstudio-server/www/images/logo.png
COPY wallpaper.png /usr/lib/rstudio-server/www/images/wallpaper.png
COPY bashrc /etc/bash.bashrc
COPY add_user.sh /home/add_user.sh


RUN git config --system core.sharedRepository 0755
RUN git config --system credential.helper 'cache --timeout=3600'
RUN git config --system core.editor "nano -w"
RUN git config --system color.ui auto

### Add default user
RUN sh /home/add_user.sh coeos coeos 2705


### Add xkcd
RUN git clone https://github.com/ipython/xkcd-font.git /usr/share/fonts/xkcd-font \
  && fc-cache -f -v \
  && Rscript -e 'utils::install.packages(pkgs = c("showtext", "xkcd"), quiet = TRUE)' \
  && Rscript -e 'sysfonts::font_add("xkcd", "xkcd.otf")' \
  && Rscript -e 'sysfonts::font_add("xkcd_regular", "xkcd-Regular.otf")' \
  && Rscript -e 'sysfonts::font_add("xkcd_script", "xkcd-script.ttf")'


EXPOSE 8787


CMD ["/bin/sh", "/home/boot.sh"]
