#!/usr/bin/env bash
set -euxo pipefail

PROCESSORS=$(grep -c processor /proc/cpuinfo)

if [ ! -f "linux-x64" ]; then
    # bootstrap
    ./boostrap.sh
fi

# $1 repo source
# $2 directory
function git_check_clone {
    if [ ! -d "$2" ]; then
        git clone --depth 1 $1 $2
    else
        cd $2
        git pull $1
        cd ..
    fi
}

# download
REPO="git://git.savannah.gnu.org/emacs.git"
REPO_DIR="emacs-latest"
STOW_DIR=/home/raziel/pkg/emacs

git_check_clone $REPO $REPO_DIR


function compile {
    pushd $REPO_DIR
    ./autogen.sh

    ./configure --with-x --with-xml2 --with-json --without-sound --with-gnutls --prefix=${STOW_DIR}

    make -j${PROCESSORS} all

    popd
}

function install {
    pushd $REPO_DIR
    make install-arch-dep install-arch-indep prefix=${STOW_DIR}
    popd

    pushd ~/pkg
    sudo stow -v -S emacs/ -t /usr/local --defer=share/info/dir
    popd
}

function main {
    #------------------------------------------------------------------------------
    # Option processing
    #
    while [[ $# != 0 ]]; do
        case $1 in

            --compile)
                compile
                shift 1
                ;;

            --install)
                install
                shift 1
                ;;

            -*)
                echo Unknown option \"$1\"
                exit
                ;;

            *)
                echo Unknown option \"$1\"
                break
                ;;

        esac
    done
}
main $@
