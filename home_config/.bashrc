# User specific aliases and functions
### set locales
export LANG="en_GB.UTF-8"
export LANGUAGE="en_GB.UTF-8"
export LC_CTYPE="en_GB.UTF-8"
export LC_NUMERIC="en_GB.UTF-8"
export LC_TIME="en_GB.UTF-8"
export LC_COLLATE="en_GB.UTF-8"
export LC_MONETARY="en_GB.UTF-8"
export LC_MESSAGES="en_GB.UTF-8"
export LC_PAPER="en_GB.UTF-8"
export LC_NAME="en_GB.UTF-8"
export LC_ADDRESS="en_GB.UTF-8"
export LC_TELEPHONE="en_GB.UTF-8"
export LC_MEASUREMENT="en_GB.UTF-8"
export LC_IDENTIFICATION="en_GB.UTF-8"
export LC_ALL="en_GB.UTF-8"

alias R="R --no-save --no-restore-data"

alias gaa="git add --all"
alias gam="git commit -am"
alias gm="git commit -m"
alias gp="git push"
alias gss="git status"

cd() { builtin cd "$@"; ll; }               # Changement de dossier
alias cd..="cd ../"                         # Retour en arrière rapide
alias ..="cd ../"                           # Retour rapide 1 niveau
alias ...="cd ../../"                       # Retour rapide 2 niveaux
alias .3="cd ../../../"                     # Retour rapide 3 niveaux
alias .4="cd ../../../../"                  # Retour rapide 4 niveaux
alias .5="cd ../../../../../"               # Retour rapide 5 niveaux
alias .6="cd ../../../../../../"

alias ll="ls -alF --color=auto"

export EDITOR=/usr/bin/nano
export BLOCKSIZE=1k
