#!/usr/bin/env bash
set -euxo pipefail

STOW_ROOT_DIR=/home/raziel/pkg/
STOW_DIR=/home/raziel

pushd ${STOW_ROOT_DIR}
# fonts
stow -v --dotfiles -S dot-fonts -t ${STOW_DIR}

# git
stow -v --dotfiles -S dot-gitconfig -t ${STOW_DIR}

# spacemacs
stow -v --dotfiles -S dot-spacemacs -t ${STOW_DIR}

# xmodmap
stow -v --dotfiles -S dot-Xmodmap -t ${STOW_DIR}

# zsh
stow -x --dotfiles -S dot-zsh -S dot-zshenv -S dot-zshrc -t ${STOW_DIR}

popd
