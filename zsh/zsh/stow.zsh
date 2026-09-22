function stow_package() {
  local package_name="$1"

  if [[ $# -ne 1 ]]; then
    echo "You need to specify exactly one package name."
    return 1
  elif [[ ! -d "${STOW_SRC_DIR}/${package_name}" ]]; then
    echo "No package with name ${package_name} found."
    return 1
  fi

  stow -d "${STOW_SRC_DIR}" -S "${package_name}"
}

function unstow_package() {
  local package_name="$1"

  if [[ $# -ne 1 ]]; then
    echo "You need to specify exactly one package name."
    return 1
  elif [[ ! -d "${STOW_SRC_DIR}/${package_name}" ]]; then
    echo "No package with name ${package_name} found."
    return 1
  fi

  stow -d "${STOW_SRC_DIR}" -D "${package_name}"
}
