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
  echo "  --shell            Install shell"
  echo "  --zshrc            Install .zshrc"
  echo "  --gitconfig        Install .gitconfig"
  echo "  --i3               Install i3 config"
  echo "  --fonts            Install fonts"
  echo "  --tmux             Install .tmux.conf"
  echo "  --alacritty        Install alacritty config"
  echo "  --nix              Install nix config"
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

# install_pkgx() {
#   if ! command -v pkgx --version &>/dev/null; then
#     curl -fsS https://pkgx.sh | sh
#   fi
#
#   export PATH="$HOME/.local/bin:$PATH"
# }

install_nix() {
  # pkgx install jq
  # pkgx install fzf
  # pkgx install ripgrep
  # pkgx install bat
  # pkgx install fd
  # pkgx install eza
  # pkgx install dust
  # pkgx install htop
  #
  # pkgx install cmake
  # pkgx install shellcheck
  # pkgx install cargo
  # pkgx install podman
  #

  if ! command -v nix --version &>/dev/null; then
    curl -L https://nixos.org/nix/install | sh
  fi

  local nix_conf_dir="${XDG_CONFIG_HOME}/nix"
  mkdir -p "${nix_conf_dir}/"
  create_symlink "nix/nix.conf" "${nix_conf_dir}/nix.conf"
}

install_tmux() {
  local tmux_conf_dir="${XDG_CONFIG_HOME}/tmux"

  if ! command -v tmux -V &>/dev/null; then
    pkgx install tmux
  fi

  mkdir -p "${tmux_conf_dir}/plugins"
  create_symlink "tmux/tmux.conf" "${tmux_conf_dir}/tmux.conf"
  git_clone_or_update "https://github.com/tmux-plugins/tpm" "${tmux_conf_dir}/plugins/tpm"
}

install_shell() {
  if ! command -v fish -v &>/dev/null; then
    echo "fish shell not available -> apt install fish"

  else
    fish -c "
if not functions -q fisher
    curl -sL https://raw.githubusercontent.com/jorgebucaran/fisher/main/functions/fisher.fish | source && fisher install jorgebucaran/fisher
end
fisher install IlanCosman/tide@v6
fisher install kidonng/zoxide.fish
fisher install PatrickF1/fzf.fish

tide configure --auto --style=Lean --prompt_colors='True color' --show_time=No --lean_prompt_height='Two lines' --prompt_connection=Disconnected --prompt_spacing=Compact --icons='Many icons' --transient=Yes
"
  fi

  ./shell/xdg_setup

  create_symlink "shell/fish/config.fish" "${XDG_CONFIG_HOME}/fish/config.fish"

  for source_file in shell/fish/functions/*; do
    target_file="${XDG_CONFIG_HOME}/fish/functions/$(basename "$source_file")"
    create_symlink "$source_file" "$target_file"
  done
}

install_zsh() {
  # if ! command -v zsh --version &>/dev/null; then
  # TODO install zsh
  # pkgx install zsh
  # fi

  # install antigen
  mkdir -p "${XDG_CONFIG_HOME}/antigen"
  curl -L git.io/antigen >"${XDG_CONFIG_HOME}/antigen/antigen.zsh"

  create_symlink "zsh/zshrc" "${HOME}/.zshrc"
  create_symlink "zsh/zshenv" "${HOME}/.zshenv"
  create_symlink "zsh/zsh" "${HOME}/.zsh"

  echo "run 'chsh -s /bin/zsh' to change default shell to zsh"
}

install_git() {
  if ! command -v git --version &>/dev/null; then
    pkgx install git
  fi

  mkdir -p "${XDG_CONFIG_HOME}/git"
  create_symlink "git/config" "${XDG_CONFIG_HOME}/git/config"
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

install_neovim() {
  if ! command -v nvim --version &>/dev/null; then
    pkgx install neovim
  fi

  create_symlink "lazyvim" "${XDG_CONFIG_HOME}/nvim"
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

  pkgx install alacritty

  mkdir -p "${XDG_CONFIG_HOME}/alacritty"
  create_symlink "alacritty/alacritty.toml" "${XDG_CONFIG_HOME}/alacritty/alacritty.toml"
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
    --zsh)
      install_specific+=("zsh")
      shift
      ;;
    --git)
      install_specific+=("git")
      shift
      ;;
    --i3)
      install_specific+=("i3")
      shift
      ;;
    --neovim)
      install_specific+=("neovim")
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
    --nix)
      install_specific+=("nix")
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
    install_tmux
    install_zsh
    install_shell
    install_git
    install_i3
    install_neovim
    install_fonts
    install_alacritty
    install_nix
  else
    # Install only the specified dotfiles
    for section in "${install_specific[@]}"; do
      case "$section" in
      tmux) install_tmux ;;
      zsh) install_zsh ;;
      shell) install_shell ;;
      git) install_gitconfig ;;
      i3) install_i3 ;;
      neovim) install_neovim ;;
      fonts) install_fonts ;;
      alacritty) install_alacritty ;;
      nix) install_nix ;;
      esac
    done
  fi

  echo "Installation complete!"
}

main "$@"
