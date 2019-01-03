export EDITOR="vim"
export LC_CTYPE=en_US.UTF-8
export LC_ALL=en_US.UTF-8

stty -ixon

#Add each completion script in the bash_completion.d directory
for file in ~/.bash_completion.d/*
do
  if [ \( -f $file -o -h $file \) -a -r $file ]; then
    # The file is a regular file or a symbolic link, and it is readable
    # by this script (for the user running the script).
    # That is good enough for us - source the file
    . $file
  fi
done

#Add bash aliases
if [ -f ~/.bash_aliases ]; then
    source ~/.bash_aliases
fi
#Add system specific customizations
if [ -f ~/.bash_profile_local ] ; then
    . ~/.bash_profile_local
fi

#Enable tab completion for "g" by marking it as an alias for "git"
if type __git_complete &> /dev/null; then
  __git_complete g __git_main
fi;

test -e "${HOME}/.iterm2_shell_integration.bash" && source "${HOME}/.iterm2_shell_integration.bash"
