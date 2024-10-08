#!/bin/bash

XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}

# Usage function to display script usage
usage() {
  echo "Usage: $0 [OPTIONS]"
  echo "Install dotfiles by linking them to files in the current directory."
  echo
  echo "Options:"
  echo "  --all               Install all dotfiles"
  echo "  --zshrc             Install .zshrc"
  echo "  --tmux_conf         Install .tmux.conf"
  echo
}

# Helper function to create symlinks
create_symlink() {
  local source_file="$1"
  local target_file="$2"

  # Expand ~ to the full home directory path
  target_file="${target_file/#\~/$HOME}"

  # Check if the symlink already exists and points to the correct file
  if [ -L "$target_file" ] && [ "$(readlink "$target_file")" == "$(pwd)/$source_file" ]; then
    echo "Symlink for $source_file already exists, skipping."
  else
    # Backup existing file if necessary
    if [ -f "$target_file" ] && [ ! -L "$target_file" ]; then
      echo "Backing up existing $target_file to $target_file.bak"
      mv "$target_file" "$target_file.bak"
    fi

    # Create the symlink
    echo "Linking $(pwd)/$source_file to $target_file"
    ln -sf "$(pwd)/$source_file" "$target_file"
  fi
}

install_pkgx() {
  if ! command -v pkgx --version &>/dev/null; then
    curl -fsS https://pkgx.sh | sh
  fi

  export PATH="$HOME/.local/bin:$PATH"
}

install_zshrc() {
  create_symlink "zsh/zshrc" "${HOME}/.zshrc"
  create_symlink "zsh/zshenv" "${HOME}/.zshenv"
  create_symlink "zsh/zsh" "${HOME}/.zsh"
}

install_tmux() {
  local tmux_conf_dir="${XDG_CONFIG_HOME}/tmux"

  pkgx install tmux

  create_symlink "tmux/tmux_conf" "${tmux_conf_dir}/tmux.conf"
  mkdir -p "${tmux_conf_dir}/plugins"
  git clone https://github.com/tmux-plugins/tpm "${tmux_conf_dir}/plugins/tpm"
}

main() {
  # Parse arguments
  if [ "$#" -eq 0 ]; then
    usage
    exit 1
  fi

  install_all=false
  install_specific=()

  while [[ "$#" -gt 0 ]]; do
    case "$1" in
    --all)
      install_all=true
      shift
      ;;
    --gitconfig)
      install_specific+=("gitconfig")
      shift
      ;;
    --zshrc)
      install_specific+=("zshrc")
      shift
      ;;
    --tmux)
      install_specific+=("tmux")
      shift
      ;;
    *)
      echo "Unknown option: $1"
      usage
      exit 1
      ;;
    esac
  done

  # prepare
  install_pkgx

  # Install all dotfiles if --all is specified
  if [ "$install_all" = true ]; then
    install_bashrc
    install_vimrc
    install_gitconfig
    install_zshrc
    install_tmux_conf
  else
    # Install only the specified dotfiles
    for section in "${install_specific[@]}"; do
      case "$section" in
      bashrc) install_bashrc ;;
      vimrc) install_vimrc ;;
      gitconfig) install_gitconfig ;;
      zshrc) install_zshrc ;;
      tmux) install_tmux ;;
      esac
    done
  fi

  echo "Installation complete!"
}

main "$@"
