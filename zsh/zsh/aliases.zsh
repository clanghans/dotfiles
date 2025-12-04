# Conan
if command -v conan &>/dev/null; then
  alias ci='conan install'
  alias cb='conan build'
  alias ce='conan export'
  alias cep='conan export-pkg'
fi

# tree
alias t='tree'
alias td='tree -d'

# Conan
if command -v conan &>/dev/null; then
  alias ci='conan install'
  alias cb='conan build'
  alias ce='conan export'
  alias cep='conan export-pkg'
fi

# tree
alias t='tree'
alias td='tree -d'

# Neovim
if command -v nvim &>/dev/null; then
  # clear the terminal after closing nvim
  alias n='nvim_open_file'
  alias nf='nvim_open_file $(fzf)'
fi

# GIT
alias gwa='git worktree add'
alias gwl='git worktree list'
alias gwr='git worktree remove'

# PIP
alias gpip='global_pip'
if command -v uv &>/dev/null; then
  alias pip='uv pip'
fi

# UV
alias pip='uv pip'

# MISC
alias x='exit'
alias xo='xdg-open'
alias more='less'
alias ag='ag --pager '"'less'"''
alias -g G='| grep -i'
alias -g L='| less'
alias -g PIPE='|& >'
alias -g TL='| tail -20'
alias -g NUL='|& /dev/null'
alias -g ERRNUL='2>/dev/null'
alias -g Z='| fzf'

## rg
if command -v rg &>/dev/null; then
  alias rga='rg --no-ignore --hidden --follow'
fi

## fdfind
if command -v eza &>/dev/null; then
  alias fd='fdfind'
  alias fda='fdfind -IH'
fi

## eza is the new ls
if command -v eza &>/dev/null; then
  alias l='eza'
  alias ls='eza'
  alias ll='eza --long --time-style=long-iso --git'
  alias lla='eza --long --all --time-style=long-iso'
  alias la='eza --all --time-style=long-iso'
  alias lr='eza --recurse'
  alias lt='eza --tree'
fi

# git tools
alias gwc='git_branch_worktree_create'

if command -v bat &>/dev/null; then
  alias c='cat'
  alias cat='bat'
  alias catp='bat -p'
fi

alias chmodx='chmod u+x'

# Hackxertools
alias rot13="tr 'A-Za-z' 'N-ZA-Mn-za-m'"

alias cd..='cd ..'

# PODMAN
if command -v podman &>/dev/null; then
  alias docker='podman'
fi

# personal shortcuts
# alias clPassFile='revelation /home/chris/Documents/Accounts/passwords &'
# alias clPassPrivate='truecrypt /home/chris/Documents/private &'

# XDG-Ninjas
alias wget='wget --hsts-file="$XDG_DATA_HOME/wget-hsts"'
