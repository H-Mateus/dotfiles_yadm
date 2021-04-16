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

# neofetch

# >>> conda initialize >>>
# !! Contents within this block are managed by 'conda init' !!
__conda_setup="$('/home/mateus/miniconda3/bin/conda' 'shell.bash' 'hook' 2> /dev/null)"
if [ $? -eq 0 ]; then
    eval "$__conda_setup"
else
    if [ -f "/home/mateus/miniconda3/etc/profile.d/conda.sh" ]; then
        . "/home/mateus/miniconda3/etc/profile.d/conda.sh"
    else
        export PATH="/home/mateus/miniconda3/bin:$PATH"
    fi
fi
unset __conda_setup
# <<< conda initialize <<<
