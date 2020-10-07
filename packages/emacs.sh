#!/usr/bin/env bash
set -euxo pipefail

# cleanup on exit
function cleanup {
    if [ -d emacs ]; then
        rm -rf emacs
    fi
}
trap cleanup EXIT

# download
git clone --depth 1 git://git.savannah.gnu.org/emacs.git

pushd emacs
./autogen.sh

./configure --prefix=/home/$1/package/emacs --with-x --with-xml2

make -j8 all

make install
popd
