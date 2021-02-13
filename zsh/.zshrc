# Load completion
autoload -Uz compinit; compinit
autoload -Uz promptinit; promptinit

# Case insensitive completion
zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'

# Key bindings
bindkey "^P" up-line-or-search
bindkey "^N" down-line-or-search

# Customize prompt
PROMPT='%F{red}%n%f@%F{green}%m%f %F{blue}%B%~%b%f %# '
RPROMPT='[%F{yellow}%?%f]'

# Load device specific configs
if [ -f ~/.zshrc.local ]; then
    source ~/.zshrc.local
fi
