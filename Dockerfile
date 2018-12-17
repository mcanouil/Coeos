FROM library/debian

ENV R_BASE_VERSION=3.5.1
ENV BIOCONDUCTOR_VERSION=3.8
ENV RSTUDIO_VERSION=1.1.463
ENV SHINY_VERSION=1.5.9.923


COPY login.html /etc/rstudio/login.html
COPY logo.png /usr/lib/rstudio-server/www/images/logo.png
COPY bashrc /etc/bash.bashrc


### Install linux libraries
RUN echo "deb http://http.debian.net/debian sid main" > /etc/apt/sources.list.d/debian-unstable.list \
  && apt-get update \
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
    texlive-base \
    texlive-lang-french \
    texlive-lang-english \
    texlive-latex-base \
    texlive-latex-recommended \
    texlive-latex-extra \
    # texlive-font-utils \
    # texlive-fonts-recommended \
    # texlive-fonts-extra \
    # texlive-fonts-extra-links \
    # texlive-generic-recommended \
    # texlive-generic-extra \
    # texlive-plain-generic \
    # texlive-plain-extra \
    # texlive-binaries \
    # texlive-luatex \
    # texlive-metapost \
    # texlive-omega \
    # texlive-htmlxml \
    # texlive-pictures \
    # texlive-xetex \
    # texlive-extra-utils \
    # texlive-games \
    # texlive-humanities \
    # texlive-music \
    # texlive-pstricks \
    # texlive-publishers \
    # texlive-science \
    # texlive-bibtex-extra \
    # texlive-formats-extra \
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
  \n# start rsyslog server \
  \n/usr/sbin/rsyslogd \
  \n \
  \n# start rstudio server \
  \nrstudio-server start ' > /home/boot.sh


### Install shiny-server
# RUN apt-get install -y --no-install-recommends gdebi \
  ## && wget --no-verbose https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-14.04/x86_64/VERSION -O "version.txt" \
  ## && VERSION=$(cat version.txt) \
  # && wget --no-verbose "https://s3.amazonaws.com/rstudio-shiny-server-os-build/ubuntu-14.04/x86_64/shiny-server-$SHINY_VERSION-amd64.deb" -O ss-latest.deb \
  # && gdebi -n ss-latest.deb \
  # && rm -f version.txt ss-latest.deb \
  # && cp -R /usr/local/lib/R/site-library/shiny/examples/* /srv/shiny-server/ \
  # && echo '#!/bin/sh \
  # \n \
  # \n# Make sure the directory for individual app logs exists \
  # \nmkdir -p /var/log/shiny-server \
  # \nchown shiny.shiny /var/log/shiny-server \
  # \n \
  # \nexec shiny-server >> /var/log/shiny-server.log 2>&1' > /usr/bin/shiny-server.sh \
  # && chmod 777 /usr/bin/shiny-server.sh \
  # && echo '### set locales \
  # \nexport LANG="en_GB.UTF-8" \
  # \nexport LANGUAGE="en_GB.UTF-8" \
  # \nexport LC_CTYPE="en_GB.UTF-8" \
  # \nexport LC_NUMERIC="en_GB.UTF-8" \
  # \nexport LC_TIME="en_GB.UTF-8" \
  # \nexport LC_COLLATE="en_GB.UTF-8" \
  # \nexport LC_MONETARY="en_GB.UTF-8" \
  # \nexport LC_MESSAGES="en_GB.UTF-8" \
  # \nexport LC_PAPER="en_GB.UTF-8" \
  # \nexport LC_NAME="en_GB.UTF-8" \
  # \nexport LC_ADDRESS="en_GB.UTF-8" \
  # \nexport LC_TELEPHONE="en_GB.UTF-8" \
  # \nexport LC_MEASUREMENT="en_GB.UTF-8" \
  # \nexport LC_IDENTIFICATION="en_GB.UTF-8" \
  # \nexport LC_ALL="en_GB.UTF-8"' > /home/shiny/.bashrc \
  # && echo '\n \
  # \n# Make sure the directory for individual app logs exists \
  # \nmkdir -p /var/log/shiny-server \
  # \nchown shiny.shiny /var/log/shiny-server \
  # \n \
  # \nexec shiny-server >> /var/log/shiny-server.log 2>&1'> /home/boot.sh


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
  && export LC_ALL="en_GB.UTF-8"


RUN echo '\n \
  \n# infinite loop for container never stop \
  \ntail -f /dev/null' >> /home/boot.sh \
  && chmod 777 /home/boot.sh
  
  
### Install R packages
COPY packages.R /tmp/packages.R

RUN Rscript /tmp/packages.R && rm -rf /tmp/*


### Add default user
COPY add_user.sh /home/add_user.sh

RUN sh /home/add_user.sh coeos coeos 2705


EXPOSE 8787


CMD ["/bin/sh", "/home/boot.sh"]
