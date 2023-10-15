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
[ -f ~/.zshrc.local ] && source ~/.zshrc.local

# Load aliases
[ -f ~/.aliases ] && source ~/.aliases

[ -f ~/.fzf.zsh ] && source ~/.fzf.zsh

export XDG_CONFIG_HOME="$HOME/.config"

export FZF_DEFAULT_COMMAND="fd --type f --hidden --follow --exclude .git"
export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
export DROPBOX=`cat $HOME/.dropbox/info.json | jq -r .personal.path`
export TIGRC_USER="~/.config/tig/tigrc"
