#!/usr/bin/env bash
set -euxo pipefail

# STOW
# stow 2.3.1 provides --dotfile option
#  $>stow -v -S stow-2.3.1/ -t /usr/local
# dotfiles
#  $>stow --dotfiles -v -S dotfiles -t /home/raziel
# emacs
#  $>sudo stow  -v -S emacs26/ -t /usr/local --defer=share/info/dir

# download, compile and install the newest stow package

PROCESSORS=$(grep -c processor /proc/cpuinfo)

if [ ! -f "linux-x64" ]; then
    # bootstrap
    ./boostrap
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

REPO=https://github.com/aspiers/stow.git
REPO_DIR=stow-2.3.1
STOW_DIR=/home/raziel/pkg/stow-2.3.1

git_check_clone $REPO $REPO_DIR

function compile {
    pushd ${REPO_DIR}
    autoreconf -iv
    ./configure --prefix=/home/raziel/pkg/${REPO_DIR}
    make
    popd
}

function install {
    pushd $REPO_DIR
    make install
    popd

    pushd ~/pkg
    sudo stow -v -S ${REPODIR} -t /usr/local
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
