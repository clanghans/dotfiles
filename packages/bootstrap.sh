#!/usr/bin/env bash
set -euxo pipefail

###
# git clone dockcross
###
# git clone https://github.com/dockcross/dockcross.git --depth 1

###
# build dockcross container
###
docker build -t boostrap-image .
docker run boostrap-image > linux-x64
chmod +x linux-x64
