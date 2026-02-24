# Conan
if (( $+commands[conan] )); then
  alias ci='conan install'
  alias cb='conan build'
  alias ce='conan export'
  alias cep='conan export-pkg'
fi

# bazel
if (( $+commands[bazelisk] )); then
  alias bazel='bazelisk'
fi


# Neovim
if (( $+commands[nvim] )); then
  # clear the terminal after closing nvim
  alias n='nvim'
  # alias nf to open a file search with fzf-lua
  alias nf='nvim -c "lua require('"'fzf-lua'"').files()"'
  # alias ng to open neovim with a neogit buffer open
  alias ng='nvim -c "lua require('"'neogit'"').open()"'
fi

# GIT
alias gwa='git worktree add'
alias gwl='git worktree list'
alias gwr='git worktree remove'

# PIP
alias gpip='global_pip'
# if command -v uv &>/dev/null; then
#   alias pip='uv pip'
# fi
#
# # UV
# alias pip='uv pip'

# MISC
alias x='exit'
alias xo='xdg-open'
alias more='less'
alias -g G='| rg -i'
alias -g L='| less'
alias -g PIPE='|& >'
alias -g TL='| tail -20'
alias -g NUL='|& /dev/null'
alias -g ERRNUL='2>/dev/null'
alias -g Z='| fzf'

#proxyconnect tcp: EOF# rg
if (( $+commands[rg] )); then
  alias grep='rg --no-ignore --hidden --follow'
  alias rga='rg --no-ignore --hidden --follow'
fi

## fd
if (( $+commands[fd] )); then
  alias fda='fd -IH'
elif (( $+commands[fdfind] )); then
  alias fd='fdfind'
  alias fda='fdfind -IH'
fi

## eza is the new ls
if (( $+commands[eza] )); then
  alias l='eza'
  alias ls='eza'
  alias ll='eza --long --time-style=long-iso --git'
  alias lla='eza --long --all --time-style=long-iso'
  alias la='eza --all --time-style=long-iso'
  alias lr='eza --recurse'
  alias lt='eza --tree'
  alias t='eza --tree'
  alias td='eza --tree --only-dirs'
fi

# git tools
alias gwc='git_branch_worktree_create'

if (( $+commands[bat] )); then
  alias c='cat'
  alias cat='bat'
  alias catp='bat -p'
fi

alias chmodx='chmod u+x'

# Hackxertools
alias rot13="tr 'A-Za-z' 'N-ZA-Mn-za-m'"

alias cd..='cd ..'

# zoxide
if (( $+commands[zoxide] )); then
  alias cd='z'
  alias cdi='zi'
fi

# PODMAN
if (( $+commands[podman] )); then
  alias docker='podman'
fi

if (( $+commands[firefox] )); then
  alias ff='firefox'
fi

# XDG-Ninjas
alias wget='wget --hsts-file="$XDG_DATA_HOME/wget-hsts"'
