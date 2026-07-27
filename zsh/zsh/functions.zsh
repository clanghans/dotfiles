# create directory [if necessary] and jump into it
function mcd() {
  if [[ "$#" -gt 1 ]]; then
    echo "$0: too many arguments"
    return 1
  fi
  mkdir -p "$1"
  cd "$1" || return 1
}

# Jump to workspace directory
function w() {
  mcd ~/ws
}

function nvim_open_file() {
  nvim "$@"
}
function vrun() {
  local name="${1:-.venv}"
  local venvpath="${name:P}"

  if [[ ! -d "$venvpath" ]]; then
    echo >&2 "Error: no such venv in current directory: $name"
    return 1
  fi

  if [[ ! -f "${venvpath}/bin/activate" ]]; then
    echo >&2 "Error: '${name}' is not a proper virtual environment"
    return 1
  fi

  . "${venvpath}/bin/activate" || return $?
  echo "Activated virtual environment ${name}"
}

# Create a new virtual environment, with default name 'venv'.
function mkv() {
  # Define the virtual environment directory as ".venv" in the current directory
  local venv_dir=".venv"

  # Check if the .venv directory already exists
  if [[ -d "${venv_dir}" ]]; then
    echo "Virtual environment already exists"
    echo "Sourcing $venv_dir/bin/activate"
    source "${venv_dir}/bin/activate"
    return 0
  fi

  # Check if a Python version is specified as a parameter
  # Default to 'python3' if no parameter is provided
  local python_version="${1:-3.12}"

  # Create the virtual environment using the specified Python version
  if uv venv "${venv_dir}" -p "${python_version}"; then
    source "${venv_dir}/bin/activate"

    # Ensure pip is installed and install necessary packages
    python3 -m ensurepip --upgrade
    uv pip install pynvim
  else
    echo "Failed to create virtual environment with Python version: ${python_version}"
    return 1
  fi
}

# Fuzzy searches all git branches and checkouts selected branch in new worktree.
# Usage: search_and_checkout_branch - Prompts to select a branch, then to enter worktree path (default: sanitized branch name).
# Requires: Git, fzf. Assumes execution within a git repository. Outputs new worktree or error message.
function git_branch_worktree_create() {
  # command line arguments
  local create_branch=false

  while [[ "$#" -gt 0 ]]; do
    case $1 in
    -c | --create)
      create_branch=true
      ;;
    *)
      echo "Unknown parameter passed: $1"
      return 1
      ;;
    esac
    shift
  done

  # Check if we are inside a git repository
  git rev-parse --is-inside-work-tree &>/dev/null || {
    echo "Not in a Git worktree"
    return
  }

  local branch_name
  local selected_ref
  local is_tag=false

  # Build combined list of branches and tags for fzf
  local refs
  refs=$( (
    git branch -a --format="%(refname:short)" | sed 's/^/branch: /'
    git tag --sort=-creatordate --format="%(refname:short)" | sed 's/^/tag: /'
  ) | fzf --height 80% --border --prompt="Select branch or tag: ")

  # Abort if nothing was selected
  if [[ -z "$refs" ]]; then
    echo "No selection."
    return
  fi

  # Parse the selected ref: strip prefix and detect type
  local ref_type=${refs%%:*}
  selected_ref=${refs#*: }
  # Trim any lingering whitespace
  selected_ref=${selected_ref## }

  if [[ "$ref_type" == "tag" ]]; then
    is_tag=true
  fi

  if [[ "$create_branch" = true ]]; then
    # Prompt for the new branch name
    read -r branch_name?"Enter new branch name: "
  else
    if [[ "$is_tag" = true ]]; then
      # Default branch name from tag, replacing / with -
      branch_name=$(echo "$selected_ref" | sed 's/\//-/g')
    else
      # Clean up branch name: strip origin/ prefix and leading whitespace/asterisk
      branch_name=$(echo "$selected_ref" | sed -r 's/^.*origin\///;s/^\*?\s+//g')
    fi
  fi

  # Use the branch name as the default worktree path
  local worktree_path="../$branch_name"

  # Prompt for the new worktree path, showing the default
  read -r user_path?"Enter the path for the new worktree [$worktree_path]: "
  worktree_path=${user_path:-$worktree_path}

  # Check if the directory already exists
  if [[ -d "$worktree_path" ]]; then
    echo "Error: Directory '$worktree_path' already exists."
    return
  fi

  # Create a new worktree
  git worktree add -b "$branch_name" "$worktree_path" "$selected_ref" || return

  cd "$worktree_path" || return
}

# Read secret token and store it in the environment
function read_secret_token() {
  local SECRET_TOKEN="${1:-API_KEY}"
  local secret

  # Read secret token without echoing
  echo "Enter your secret token:"
  read -s secret

  # Export as environment variable
  export "${SECRET_TOKEN}"="${secret}"
  echo "Stored secret token in environment variable ${SECRET_TOKEN}"
}

function describe() {
  # Check for argument
  if [[ $# -eq 0 ]]; then
    echo "Usage: describe <command>"
    echo "Describe a command, alias, or function."
    return
  fi

  local cmd="$1"

  # Check for alias
  if alias "$cmd" &>/dev/null; then
    echo "$cmd is an alias:"
    alias "$cmd"
    return
  fi

  # Check for function
  if declare -F "$cmd" &>/dev/null; then
    echo "$cmd is a function:"
    declare -f "$cmd" | bat --language=sh --plain
    return
  fi

  # Check for binary
  if (( $+commands[$cmd] )); then
    echo "$cmd is a binary located at:"
    echo "$commands[$cmd]"
    return
  fi

  # If none of the above
  echo "$cmd not found as alias, function, or binary."
}

function batdiff() {
  git diff --name-only --diff-filter=d | xargs bat --diff
}

# calc hashsums of the most common hashalgorithms
function hashsum() {
  for file in "$@"; do
    if [ -f "${file}" ]; then
      echo "${file}"
      echo "MD5: $(md5sum "$file")"
      echo "SHA1: $(sha1sum "$file")"
      echo "SHA256: $(sha256sum "$file")"
      echo "SHA512: $(sha512sum "$file")"
      echo ""
    fi
  done
}

# PIP
function global_pip() {
  PIP_REQUIRE_VIRTUALENV=false pip "$@"
}

# Compress pdf files with ghostscript
pdfcompress() {
  # this function uses 2 arguments:
  #     $1 input file name
  #     $2 output file name
  gs -sDEVICE=pdfwrite -dCompatibilityLevel=1.4 -dPDFSETTINGS=/screen \
    -dNOPAUSE -dQUIET -dBATCH -sOutputFile="${2}" "${1}"
}

# Extract ranged pdf pages with ghostscript
pdfpextr() {
  # this function uses 3 arguments:
  #     $1 is the first page of the range to extract
  #     $2 is the last page of the range to extract
  #     $3 is the input file
  #     output file will be named "inputfile_pXX-pYY.pdf"
  gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER \
    -dFirstPage="${1}" \
    -dLastPage="${2}" \
    -sOutputFile="${3%.pdf}"_p"${1}"-p"${2}".pdf \
    "${3}"
}

# Regenerate ~/.config/git/credentials from ~/.secrets.
# Pulled in as git config via [include] in ~/.config/git/work, so this file
# must be git-config syntax ([url] insteadOf blocks). See git/credentials.example.
secrets-apply() {
  local secrets="${HOME}/.secrets"
  local creds="${XDG_CONFIG_HOME:-$HOME/.config}/git/credentials"

  if [[ ! -f "$secrets" ]]; then
    echo "secrets-apply: $secrets not found" >&2
    return 1
  fi
  source "$secrets"

  if [[ -z "$AZURE_DEVOPS_EXT_USER" || -z "$AZURE_DEVOPS_EXT_PAT" || -z "$AZURE_DEVOPS_ORGS" ]]; then
    echo "secrets-apply: AZURE_DEVOPS_EXT_USER / AZURE_DEVOPS_EXT_PAT / AZURE_DEVOPS_ORGS unset in $secrets" >&2
    return 1
  fi

  mkdir -p "${creds:h}"
  local user="$AZURE_DEVOPS_EXT_USER" pat="$AZURE_DEVOPS_EXT_PAT"
  {
    echo "# GENERATED by secrets-apply from ~/.secrets — do not edit"
    local org
    for org in ${=AZURE_DEVOPS_ORGS}; do
      printf '[url "https://%s:%s@dev.azure.com/%s"]\n' "$user" "$pat" "$org"
      printf '\tinsteadOf = https://%s@dev.azure.com/%s\n' "$user" "$org"
    done
  } > "$creds"
  chmod 600 "$creds"
  echo "secrets-apply: wrote $creds"
}
