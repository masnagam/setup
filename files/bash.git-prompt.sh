. {{SETUP_GIT_PROMPT_SCRIPT}}
GIT_PS1_SHOWDIRTYSTATE=1
GIT_PS1_SHOWSTASHSTATE=1
GIT_PS1_SHOWUNTRACKEDFILES=1
GIT_PS1_SHOWUPSTREAM=auto
GIT_PS1_STATUS='$(__git_ps1)'
PS1_STATUS="${PS1_STATUS}${GIT_PS1_STATUS}"
