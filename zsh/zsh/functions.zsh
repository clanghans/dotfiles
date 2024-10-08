# load redo functions
source "$(redo alias-file)"

# reload zsh/shell configuration
function reload() {
	source ~/.zshrc
	source ~/.zshenv
	source "$(redo alias-file)"
}

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
	local name="${1:-.venv}"
	local venvpath="${name:P}"

	python3 -m venv "${name}" || return
	echo >&2 "Created venv in '${venvpath}'"
	vrun "${name}"
}

# Fuzzy searches all git branches and checkouts selected branch in new worktree.
# Usage: search_and_checkout_branch - Prompts to select a branch, then to enter worktree path (default: sanitized branch name).
# Requires: Git, fzf. Assumes execution within a git repository. Outputs new worktree or error message.
function git_branch_worktree_create() {
	# Check if we are inside a git repository
	git rev-parse --is-inside-work-tree &>/dev/null || {
		echo "Not in a Git worktree"
		return
	}

	# Use fzf to select a branch from the list (local and remote)
	local branch
	branch=$(git branch -a --format="%(refname:short)" | fzf --height 80% --border)

	# Abort if no branch was selected
	if [[ -z "$branch" ]]; then
		echo "No branch selected."
		return
	fi

	# Parse the selected branch name for the worktree add command
	local branch_name
	# Clean up branch name and replace slashes
	# branch_name=$(echo "$branch" | sed -r 's/^.*origin\///;s/^\*?\s+//;s/\/+/-/g')
	branch_name=$(echo "$branch" | sed -r 's/^.*origin\///;s/^\*?\s+//g')

	# Use the branch name as the default worktree path
	local worktree_path="../$branch_name" # Set default path to the branch name

	# Prompt for the new worktree path, showing the default
	read -r user_path?"Enter the path for the new worktree [$worktree_path]: "
	worktree_path=${user_path:-$worktree_path} # Use the user provided path, or default if none provided

	# Check if the directory already exists
	if [[ -d "$worktree_path" ]]; then
		echo "Error: Directory '$worktree_path' already exists."
		return
	fi

	# Create a new worktree with the selected branch
	git worktree add -b "$branch_name" "$worktree_path" "$branch" || return

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
	export ${SECRET_TOKEN}=${secret}
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
		declare -f "$cmd"
		return
	fi

	# Check for binary
	if command -v "$cmd" &>/dev/null; then
		echo "$cmd is a binary located at:"
		command -v "$cmd"
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
		if [ -f $file ]; then
			echo "$file"
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
		-dNOPAUSE -dQUIET -dBATCH -sOutputFile=${2} ${1}
}

# Extract ranged pdf pages with ghostscript
pdfpextr() {
	# this function uses 3 arguments:
	#     $1 is the first page of the range to extract
	#     $2 is the last page of the range to extract
	#     $3 is the input file
	#     output file will be named "inputfile_pXX-pYY.pdf"
	gs -sDEVICE=pdfwrite -dNOPAUSE -dBATCH -dSAFER \
		-dFirstPage=${1} \
		-dLastPage=${2} \
		-sOutputFile=${3%.pdf}_p${1}-p${2}.pdf \
		${3}
}
