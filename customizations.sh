set -o vi

export GIT_PS1_SHOWDIRTYSTATE=true
export GIT_PS1_SHOWSTASHSTATE=true
export GIT_PS1_SHOWCOLORHINTS=true

PS1='[\u@\h \W$(__git_ps1 " (%s)")]\$'