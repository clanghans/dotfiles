#!/usr/bin/env bash
set -euxo pipefail

# options
CMAKE_VERSION="3.18.4"

REPO="https://gitlab.kitware.com/cmake/cmake.git"
REPO_OPTIONS="-b v$CMAKE_VERSION"
REPO_DIR="CMake"
INSTALL_DIR=/usr/local

PROCESSORS=$(grep -c processor /proc/cpuinfo)

if [ ! -f "linux-x64" ]; then
    # bootstrap
    ./boostrap.sh
fi

# $1 repo source
# $2 directory
# $3 git options
function git_check_clone {
    if [ ! -d "$2" ]; then
        git clone --depth 1 $@
    else
        cd $2
        git pull $1
        cd ..
    fi
}

function compile {
    git_check_clone $REPO $REPO_DIR ${REPO_OPTIONS}
    pushd $REPO_DIR

    ./bootstrap --prefix=${INSTALL_DIR}
    make -j${PROCESSORS}
    checkinstall -D -y --install=no --pkgversion=${CMAKE_VERSION} --backup=no

    popd
}

function install {
    pushd ${REPO_DIR}
    sudo dpkg -i cmake_${CMAKE_VERSION}*deb
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
