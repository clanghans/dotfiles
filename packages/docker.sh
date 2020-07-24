#!/usr/bin/env bash

# install docker packages
sudo apt remove docker docker-engine docker.io
sudo apt install docker.io
sudo systemctl start docker
sudo systemctl enable docker
# check docker version
docker --version
# install root-less docker
curl -fsSL https://get.docker.com/rootless | sh

__env="
# Rootless Docker additions
export PATH=/home/raziel/bin:$PATH
export DOCKER_HOST=unix:///run/user/1000/docker.sock
"

__ZSHENV="~/.zshenv"

if [ -f "${__ZSHENV}" ]; then
    echo "${__env}" >> ${__ZSHENV}
else
    echo "WARNING: ${__ZSHENV} not found. Docker ENV not set."
fi
