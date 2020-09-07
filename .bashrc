#
# ~/.bashrc
#

# If not running interactively, don't do anything
[[ $- != *i* ]] && return

# set link to alias file
if [ -f ~/.aliases ]; then
    . ~/.aliases
fi

export PATH=$PATH:/home/mateus/.local/bin

neofetch
