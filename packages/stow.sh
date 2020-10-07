#!/usr/bin/env bash
# STOW
# stow 2.3.1 provides --dotfile option
#  $>stow -v -S stow-2.3.1/ -t /usr/local
# dotfiles
#  $>stow --dotfiles -v -S dotfiles -t /home/raziel
# emacs
#  $>sudo stow  -v -S emacs26/ -t /usr/local --defer=share/info/dir

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
