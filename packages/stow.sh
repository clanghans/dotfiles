#!/usr/bin/env bash

set -x
# download, compile and install the newest stow package

STOW_VERSION=stow-2.3.1
STOW_TAR=${STOW_VERSION}.tar.gz

#
# PREREQUISITES
sudo cpan -i Test::Output Test::More

# cleanup on exit
function cleanup {
    if [ -d "${STOW_VERSION}" ]; then
        rm -rf ${STOW_VERSION}
    fi

    if [ -f "${STOW_TAR}" ]; then
        rm ${STOW_TAR}
    fi
}
trap cleanup EXIT

function main {

    wget https://ftp.gnu.org/gnu/stow/${STOW_TAR}
    tar -xvpzf ${STOW_TAR}

    pushd ${STOW_VERSION}

    ./configure --prefix=/home/$(whoami)/package/${STOW_VERSION}
    make
    make install

    popd

    pushd ~/package
    sudo stow -v -S ${STOW_VERSION} -t /usr/local

    popd
}

main $*
