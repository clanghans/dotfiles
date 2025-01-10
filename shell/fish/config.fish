
alias n="nvim"
set -x EDITOR nvim

alias tm="tmux"

alias x='exit'
alias xo='xdg-open'
alias chmodx="chmod u+x"
alias cd..='cd ..'

alias rot13="tr 'A-Za-z' 'N-ZA-Mn-za-m'"

abbr G "| grep -i"
abbr L "| less"
abbr TL "| tail -20"
abbr Z "| fzf"
abbr PIPE "|& >"
abbr NUL "|& /dev/null"
abbr ERRNUL "2>/dev/null"

# Conan
if type -q conan
    alias ci="conan install"
    alias cb="conan build"
    alias ce="conan export"
    alias cep="conan export-pkg"
end

# Git
if type -q git
    # basics 
    alias gst="git status --show-stash"
    alias gd="git diff"
    alias gpr="git pull --rebase"
    alias gpu="git push"

    alias grt="cd (git rev-parse --show-toplevel)"

    alias gcl="git clone"

    # worktree/workflow
    alias gwa="git worktree add"
    alias gwl="git worktree list"
    alias gwr="git worktree remove"

else
    echo "git not available"
end

# Python uv
if type -q uv
    alias pip="uv pip"
else
    echo "python uv is not available"
end

# eza
if type -q eza
    set -l params '--git --group --group-directories-first --time-style=long-iso --color-scale=all --icons'

    alias l="eza $params --git-ignore"
    alias ls="eza $params"
    alias ll="eza --all --long $params"
    alias la="eza --all $params"
    alias lr="eza --recurse"
    alias t="eza --tree $params"
    alias td="eza --tree --only-dirs $params"
else
    echo "eza not available"
end

# bat
if type -q bat
    alias c="cat"
    alias cat="bat"
    alias catp="bat -p"
else
    echo "bat not available"
end

# disable fish greeting
set -g fish_greeting
# function fish_greeting
# fortune | boxes -d stone
# neofetch
# end

