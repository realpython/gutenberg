FROM ubuntu:18.04

# Prevent tzdata package from dropping into interactive mode,
# prevent mscorefonts EULA agreement from dropping into interactive
RUN ln -fs /usr/share/zoneinfo/America/New_York /etc/localtime && \
    echo ttf-mscorefonts-installer msttcorefonts/accepted-mscorefonts-eula select true | debconf-set-selections

RUN apt-get -y update \
    && apt-get install -y \
        curl \
        gpp=2.24* \
        texlive-xetex=2017.20180305* \
        default-jre \
        epubcheck=4.0.2* \
        ghostscript=9.22* \
        libgs9=9.22* \
        libgs9-common=9.22* \
        python3=3.6* \
        python3-pip \
    && apt-get clean -y

# Find the Pandoc releases here: https://github.com/jgm/pandoc/releases/
ENV PANDOC_URL "https://github.com/jgm/pandoc/releases/download/2.4/pandoc-2.4-1-amd64.deb"

# Need -L to follow initial GitHub redirect
RUN curl -L ${PANDOC_URL} > /tmp/pandoc.deb && \
    dpkg -i /tmp/pandoc.deb && \
    rm -rf /tmp/*

ENV KINDLEGEN_URL "http://kindlegen.s3.amazonaws.com/kindlegen_linux_2.6_i386_v2_9.tar.gz"

RUN curl -L ${KINDLEGEN_URL} > /tmp/kindlegen.tar.gz && \
    tar -xvzf /tmp/kindlegen.tar.gz -C /tmp && \
    mv /tmp/kindlegen /usr/bin && \
    rm -rf /tmp/*

RUN python3 -m pip install panflute==1.10.6

WORKDIR /data
