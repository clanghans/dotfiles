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
  echo "  --fonts            Install fonts"
  echo "  --alacritty        Install alacritty config"
  echo "  --ghostty          Install ghostty config"
  echo "  --nix              Install nix config"
  echo "  --hyprland         Install hyprland config"
  echo "  --herdr            Install herdr config"
  echo "  --yazi             Install yazi config"
  echo "  --claude           Install claude config"
  echo "  --vibecockpit      Install vibecockpit config"
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
  if ! command -v curl &>/dev/null; then
    echo "curl not available"
    exit 1
  fi

  if ! command -v git &>/dev/null; then
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

  if ! command -v tmux-snaglord &>/dev/null; then
    if command -v cargo &>/dev/null; then
      echo "Installing tmux-snaglord..."
      cargo install tmux-snaglord
    else
      echo "Skipping tmux-snaglord: cargo not found" >&2
    fi
  fi
}

install_vibecockpit() {
  local vc_conf_dir="${XDG_CONFIG_HOME}/vibecockpit"
  mkdir -p "${vc_conf_dir}"
  create_symlink "vibecockpit/config.yaml" "${vc_conf_dir}/config.yaml"
}

install_herdr() {
  local herdr_conf_dir="${XDG_CONFIG_HOME}/herdr"

  mkdir -p "${herdr_conf_dir}"
  create_symlink "herdr/config.toml" "${herdr_conf_dir}/config.toml"
  herdr integration install claude
  herdr plugin install third774/herdr-last-workspace --yes
  herdr plugin install beyondlex/herdr-recent-navigator --yes
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

install_yazi() {
  mkdir -p "${XDG_CONFIG_HOME}/yazi"
  create_symlink "yazi/yazi.toml" "${XDG_CONFIG_HOME}/yazi/yazi.toml"
}

install_hyprland() {
  create_symlink "hyprland" "${XDG_CONFIG_HOME}/hypr"
}

install_claude() {
  mkdir -p "${HOME}/.claude/hooks" "${HOME}/bin"
  create_symlink "claude/CLAUDE.md" "${HOME}/.claude/CLAUDE.md"
  create_symlink "claude/RTK.md" "${HOME}/.claude/RTK.md"
  create_symlink "claude/settings.json" "${HOME}/.claude/settings.json"
  create_symlink "claude/statusline.sh" "${HOME}/.claude/statusline.sh"
  create_symlink "claude/hooks/rtk-rewrite.sh" "${HOME}/.claude/hooks/rtk-rewrite.sh"
  create_symlink "claude/skills" "${HOME}/.claude/skills"
  create_symlink "claude/claude-bwrapped" "${HOME}/.local/bin/claude-bwrapped"

  if ! command -v headroom &>/dev/null; then
    echo "Installing headroom..."
    uv tool install "headroom-ai[all]"
  fi
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
    --herdr)
      install_specific+=("herdr")
      shift
      ;;
    --shell)
      install_specific+=("shell")
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
    --yazi)
      install_specific+=("yazi")
      shift
      ;;
    --claude)
      install_specific+=("claude")
      shift
      ;;
    --vibecockpit)
      install_specific+=("vibecockpit")
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

  # Install all dotfiles if --all is specified
  if [ "$install_all" = true ]; then
    install_alacritty
    install_claude
    install_vibecockpit
    install_fonts
    install_ghostty
    install_herdr
    install_hyprland
    install_nix
    install_shell
    install_tmux
    install_yazi
  else
    # Install only the specified dotfiles
    for section in "${install_specific[@]}"; do
      case "$section" in
      alacritty) install_alacritty ;;
      claude) install_claude ;;
      vibecockpit) install_vibecockpit ;;
      fonts) install_fonts ;;
      ghostty) install_ghostty ;;
      herdr) install_herdr ;;
      hyprland) install_hyprland ;;
      nix) install_nix ;;
      shell) install_shell ;;
      tmux) install_tmux ;;
      yazi) install_yazi ;;
      esac
    done
  fi

  echo "Installation complete!"
}

main "$@"
