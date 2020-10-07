#!/usr/bin/env bash

docker build -t emacsbuild:latest -f- . <<EOF
FROM ubuntu:latest
WORKDIR /tmp
SHELL ["/usr/bin/env", "bash", "-c"]
ENV TZ=Europe/Berlin
ARG DEBIAN_FRONTEND=noninteractive
RUN apt-get update && apt-get install -y \
    apt-utils \
    autoconf \
    build-essential \
    git \
    libc6-dev \
    libgif-dev \
    libgnutls28-dev \
    libice-dev \
    libjpeg-dev \
    libncurses-dev \
    libpng-dev \
    libsm-dev \
    libtiff-dev \
    libx11-dev \
    libxext-dev \
    libxi-dev \
    libxml2-dev \
    libxmu-dev \
    libxmuu-dev \
    libxpm-dev \
    libxrandr-dev \
    libxt-dev \
    libxtst-dev \
    libxv-dev \
    pkg-config \
    texinfo \
    xaw3dg-dev \
    zlib1g-dev

CMD ./emacs.sh $(pwd)
EOF

docker run -it -v $(pwd):/tmp emacsbuild:latest

## TODO check if stow is available in PATH and use it
# pushd ~/package/
# sudo stow -v -S emacs/ -t /usr/local --defer=share/info/dir

# popd
