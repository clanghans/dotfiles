#!/bin/bash

XDG_CONFIG_HOME=${XDG_CONFIG_HOME:-$HOME/.config}
LOCAL_BIN=${HOME}/.local/bin

# Usage function to display script usage
usage() {
  echo "Usage: $0 [OPTIONS]"
  echo "Install dotfiles by linking them to files in the current directory."
  echo
  echo "Options:"
  echo "  --all              Install all dotfiles"
  echo "  --shell            Install shell environment"
  echo "  --tmux             Install tmux config"
  echo "  --i3               Install i3 config"
  echo "  --fonts            Install fonts"
  echo "  --alacritty        Install alacritty config"
  echo "  --ghostty          Install ghostty config"
  echo "  --nix              Install nix config"
  echo "  --hyprland         Install hyprland config"
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
    if [ -e "$target_file" ] && [ ! -L "$target_file" ]; then
      echo "Backing up existing $target_file to $target_file.bak"
      mv "$target_file" "$target_file.bak"
    fi

    # Create the symlink
    echo "Linking $(pwd)/$source_file to $target_file"
    ln -sf "$(pwd)/$source_file" "$target_file"
  fi
}

git_clone_or_update() {
  # Check if directory already exists
  if [ -d "$2/.git" ]; then
    echo "Repository already exists. Pulling latest changes in $2..."
    git -C "$2" pull
  else
    echo "Cloning repository into $2..."
    git clone -q "$1" "$2"
  fi
}

check_prerequisits() {
  if ! command -v curl --version &>/dev/null; then
    echo "curl not available"
    exit 1
  fi

  if ! command -v git --version &>/dev/null; then
    echo "git not available"
    exit 1
  fi
}

install_nix() {

  if ! command -v nix --version &>/dev/null; then
    curl -L https://nixos.org/nix/install | sh
  fi

  local nix_conf_dir="${XDG_CONFIG_HOME}/nix"
  mkdir -p "${nix_conf_dir}/"
  create_symlink "nix/nix.conf" "${nix_conf_dir}/nix.conf"
}

install_tmux() {
  local tmux_conf_dir="${XDG_CONFIG_HOME}/tmux"

  mkdir -p "${tmux_conf_dir}/plugins"
  create_symlink "tmux/tmux.conf" "${tmux_conf_dir}/tmux.conf"
  git_clone_or_update "https://github.com/tmux-plugins/tpm" "${tmux_conf_dir}/plugins/tpm"
}

install_shell() {

  create_symlink "zsh/zshrc" "${HOME}/.zshrc"
  create_symlink "zsh/zshenv" "${HOME}/.zshenv"
  create_symlink "zsh/zsh" "${HOME}/.zsh"

  mkdir -p "${XDG_CONFIG_HOME}/ripgrep"
  create_symlink "ripgrep/config" "${XDG_CONFIG_HOME}/ripgrep/config"

  mkdir -p "${XDG_CONFIG_HOME}/git"
  create_symlink "git/config" "${XDG_CONFIG_HOME}/git/config"

  create_symlink "lazyvim" "${XDG_CONFIG_HOME}/nvim"

  echo "run 'chsh -s /bin/zsh' to change default shell to zsh"
}

install_i3() {
  mkdir -p "${XDG_CONFIG_HOME}/i3"

  create_symlink "i3/config" "${XDG_CONFIG_HOME}/i3/config"
  create_symlink "i3/chrome" "${LOCAL_BIN}/chrome"
  create_symlink "i3/i3-display-swap.sh" "${LOCAL_BIN}/i3-display-swap.sh"

  # rofi
  mkdir -p "${XDG_CONFIG_HOME}/rofi"
  create_symlink "i3/rofi-launcher" "${LOCAL_BIN}/rofi-launcher"
  create_symlink "i3/rofi.config" "${XDG_CONFIG_HOME}/rofi/config.rasi"

  # polybar
  mkdir -p "${XDG_CONFIG_HOME}/polybar"
  create_symlink "i3/polybar.config" "${XDG_CONFIG_HOME}/polybar/config.ini"
  create_symlink "i3/polybar-launcher" "${LOCAL_BIN}/polybar-launcher"
}

install_fonts() {
  local font_dir="${HOME}/.local/share/fonts"
  mkdir -p "${font_dir}"

  # List of font names to download and extract
  fonts=(
    "JetBrainsMono"
    "FiraCode"
    "FiraMono"
    "Hack"
    "RobotoMono"
    "SourceCodePro"
    "SpaceMono"
  )

  # Loop through each font and download + extract it
  for font in "${fonts[@]}"; do
    echo "Downloading and extracting $font..."
    curl -L "https://github.com/ryanoasis/nerd-fonts/releases/latest/download/${font}.tar.xz" | tar -xJf - -C "${font_dir}"
  done

  fc-cache -f -v

  # XModmap
  create_symlink "Xmodmap" "${HOME}/.Xmodmap"
}

install_alacritty() {
  mkdir -p "${XDG_CONFIG_HOME}/alacritty"
  create_symlink "alacritty/alacritty.toml" "${XDG_CONFIG_HOME}/alacritty/alacritty.toml"
}

install_ghostty() {
  mkdir -p "${XDG_CONFIG_HOME}/ghostty"
  create_symlink "ghostty/config" "${XDG_CONFIG_HOME}/ghostty/config"
}

install_hyprland() {
  create_symlink "hyprland" "${XDG_CONFIG_HOME}/hypr"
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
    --tmux)
      install_specific+=("tmux")
      shift
      ;;
    --shell)
      install_specific+=("shell")
      shift
      ;;
    --i3)
      install_specific+=("i3")
      shift
      ;;
    --fonts)
      install_specific+=("fonts")
      shift
      ;;
    --alacritty)
      install_specific+=("alacritty")
      shift
      ;;
    --ghostty)
      install_specific+=("ghostty")
      shift
      ;;
    --nix)
      install_specific+=("nix")
      shift
      ;;
    --hyprland)
      install_specific+=("hyprland")
      shift
      ;;
    *)
      echo "Unknown option: ${1}"
      usage
      exit 1
      ;;
    esac
  done

  check_prerequisits

  # prepare
  # install_pkgx

  # Install all dotfiles if --all is specified
  if [ "$install_all" = true ]; then
    install_alacritty
    install_fonts
    install_ghostty
    install_hyprland
    install_i3
    install_nix
    install_shell
    install_tmux
  else
    # Install only the specified dotfiles
    for section in "${install_specific[@]}"; do
      case "$section" in
      alacritty) install_alacritty ;;
      fonts) install_fonts ;;
      ghostty) install_ghostty ;;
      hyprland) install_hyprland ;;
      i3) install_i3 ;;
      nix) install_nix ;;
      shell) install_shell ;;
      tmux) install_tmux ;;
      esac
    done
  fi

  echo "Installation complete!"
}

main "$@"
