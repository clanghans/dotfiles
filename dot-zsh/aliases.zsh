# GIT
alias gwa='git worktree add'
alias gwl='git worktree list'
alias gwr='git worktree remove'

# MISC
alias x="exit"
alias xo="xdg-open"
alias more="less"
alias ag="ag --pager 'less'"
alias -g G="| grep -i"
alias -g L="| less"
alias -g TL="| tail -20"
alias -g NUL="|& /dev/null"
alias -g ERRNUL="2>/dev/null"
alias -g Z='| fzf'

## k is the new ls
alias l='exa'
alias ls='exa'
alias ll='exa --long --time-style=long-iso --git'
alias lla='exa --long --all --time-style=long-iso'
alias la='exa --all --time-style=long-iso'
alias lr='exa --recurse'
alias lt='exa --tree'

alias cat="bat"
# alias bd="batdiff"

alias chmodx='chmod u+x'

# WEB DEV
alias serve='python2 -m SimpleHTTPServer 8000'

alias cd..="cd .." # I often make this mistake

# personal shortcuts
# alias clPassFile='revelation /home/chris/Documents/Accounts/passwords &'
# alias clPassPrivate='truecrypt /home/chris/Documents/private &'
