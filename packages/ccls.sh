#!/usr/bin/env bash
set -euxo pipefail

PROCESSORS=$(grep -c processor /proc/cpuinfo)

# $1 repo source
# $2 directory
function git_check_clone {
    if [ ! -d "$2" ]; then
        git clone --recursive --depth 1 $1 $2
    else
        cd $2
        git pull $1
        cd ..
    fi
}

REPO=https://github.com/MaskRay/ccls
REPO_DIR=ccls
STOW_DIR=/home/raziel/pkg/ccls

git_check_clone $REPO $REPO_DIR

function compile {

    sudo echo "# LLVM 11 \
deb http://apt.llvm.org/bionic/ llvm-toolchain-bionic-11 main \
deb-src http://apt.llvm.org/bionic/ llvm-toolchain-bionic-11 main" > /etc/apt/sources.list.d/llvm.list
    wget -O - https://apt.llvm.org/llvm-snapshot.gpg.key | sudo apt-key add - # Fingerprint: 6084 F3CF 814B 57C1 CF12 EFD5 15CF 4D18 AF4F 7421

    sudo apt update
    sudo apt-get install -y libllvm11 llvm-11 llvm-11-dev llvm-11-doc llvm-11-examples llvm-11-runtime
    sudo apt-get install -y clang-11 clang-tools-11 clang-11-doc libclang-common-11-dev libclang-11-dev libclang1-11 clang-format-11 clangd-11

    pushd ${REPO_DIR}

    cmake -H. -BRelease -DCMAKE_BUILD_TYPE=Release -DCMAKE_PREFIX_PATH=/usr/lib/llvm-11 -DLLVM_INCLUDE_DIR=/usr/lib/llvm-11/include -DCMAKE_INSTALL_PREFIX=${STOW_DIR}
    cmake --build Release
    popd
}

function install {
    pushd ${REPO_DIR}/Release
    make install
    popd

    pushd ${STOW_DIR}/..
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
