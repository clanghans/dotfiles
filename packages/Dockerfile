FROM dockcross/linux-x64

ENV DEFAULT_DOCKCROSS_IMAGE boostrap-image

RUN apt-get update \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y apt-utils \
 && DEBIAN_FRONTEND=noninteractive dpkg-reconfigure apt-utils \
 && DEBIAN_FRONTEND=noninteractive apt-get install -y \
	libssl-dev \
	patch \
    apt-utils \
    autoconf \
    build-essential \
    bzip2 \
    checkinstall \
    cpanminus \
    gawk \
    git \
    libc6-dev \
    libgif-dev \
    libgnutls28-dev \
    libice-dev \
    libjansson-dev \
    libjpeg-dev \
    libncurses-dev \
    libpng-dev \
    libsm-dev \
    libssl-dev \
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
    make \
    perlbrew \
    pkg-config \
    texi2html \
    texinfo \
    texlive \
    xaw3dg-dev \
    zlib1g-dev \
    && apt-get clean --yes \
    && rm -rf /var/lib/apt/lists/*