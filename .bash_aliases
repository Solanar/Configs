# some more ls aliases
alias ll='ls -alF'
alias la='ls -A'
alias l='ls -CF'

# Add an "alert" alias for long running commands.  Use like so:
#   sleep 10; alert
alias alert='notify-send --urgency=low -i "$([ $? = 0 ] && echo terminal || echo error)" "$(history|tail -n1|sed -e '\''s/^\s*[0-9]\+\s*//;s/[;&|]\s*alert$//'\'')"'

# git
function gs() { git status "$@"; }
function gl() {
    if [[ "$@" == *"-p"* ]]; then
        args="$@"
    else
        args="$@ --name-only"
    fi
    git log $args
}
function gd() { git diff "$@"; }
#alias gc="git status -s | awk '\$1 != \"??\" { print \$2; exit; }' | xargs git commit -m"
function gc() {
    git status -s | awk '$1 != "??" { print $2; exit; }' | xargs git commit -m "$1"
    git log -n 1 --name-only --pretty=format:
    gs
}
