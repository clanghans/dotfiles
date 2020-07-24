#!/usr/bin/env bash

set -x

# check command result, print message and exit
# $1: error code
# $2: error message
function checkResult {
    if [ "${1}" -ne "0" ]; then
        echo "Error[$1]: $2" >&2
        exit 1
    fi
}

# cleanup on exit
# function cleanup {

#     if [ -d emacs ]; then
#         rm -rf emacs
#     fi
# }
# trap cleanup EXIT

# download
git clone --depth 1 git://git.savannah.gnu.org/emacs.git
checkResult 0 "git clone failed. Abort."

pushd emacs
./autogen.sh

./configure --prefix=~/stow/emacs --with-x --with-xml2
checkResult $? "configure failed. Abort."

make -j8 all
checkResult $? "make failed. Abort."

make install
checkResult $? "installation failed. Abort."
popd

pushd ~/stow/
sudo stow -v -S emacs/ -t /usr/local --defer=share/info/dir
checkResult $? "stow failed. Abort."

popd
