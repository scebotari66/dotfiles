#NAVIGATION
alias ..="cd .."
alias ...="cd ../.."
alias ....="cd ../../.."
alias .....="cd ../../../.."
alias ......="cd ../../../../.."
alias ~="cd ~"
alias -- -="cd -"

#SHORTCUTS
alias g="git"
alias d="docker"
alias dc="docker-compose"
alias sa="sencha"
alias yt="youtube-dl"
alias ytmp3="youtube-dl --extract-audio --audio-format mp3"

#FILE LISTING
#Long form no user group, color
alias l="ls -oG"
#Order by last modified, long form no user group, color
alias lt="ls -toG"
#List all except . and ..., color, mark file types, long form no user group, file size
alias la="ls -AGFoh"
#List all except . and ..., color, mark file types, long form no use group, order by last modified, file size
alias lat="ls -AGFoth"

#TRICKS
#Hide/show all desktop icons (useful when presenting)
alias showdeskicons="defaults write com.apple.finder CreateDesktop -bool true && killall Finder"
alias hidedeskicons="defaults write com.apple.finder CreateDesktop -bool false && killall Finder"
#Simulate macOS's "pbcopy" and "pbpaste" commands on other platforms
if [ ! $(uname -s) = "Darwin" ]; then
    alias pbcopy='xclip -selection clipboard'
    alias pbpaste='xclip -selection clipboard -o'
fi

#Add system specific aliases
if [ -f ~/.bash_aliases_local ] ; then
    . ~/.bash_aliases_local
fi
