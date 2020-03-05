# .bash_profile


### ================================================================================================
### Set locales
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


### ================================================================================================
### Set prompt
export PS1="________________________________________________________________________________\n| \w @ \h (\u) \n| > "
export PS2="| > "
export EDITOR=/usr/bin/nano
export BLOCKSIZE=1k


### ================================================================================================
### Set aliases
alias R="R --no-save --no-restore-data"

alias gaa="git add --all"
alias gam="git commit -am"
alias gm="git commit -m"
alias gp="git push"
alias gss="git status"

alias cp="cp -iv"                           # Nouvelle copie
alias mv="mv -iv"                           # Nouveau move
alias mkdir="mkdir -pv"                     # Nouvelle création de dossier
alias ll="ls -FlAhp --color=auto"           # Affiche fichier, dossier, et fichiers cachés
alias l="ls -Flhp --color=auto"             # Affiche fichier et dossier
alias ls="ls --color=auto" 
cd() { builtin cd "$@"; ll; }               # Changement de dossier
alias cd..="cd ../"                         # Retour en arrière rapide
alias ..="cd ../"                           # Retour rapide 1 niveau
alias ...="cd ../../"                       # Retour rapide 2 niveaux
alias .3="cd ../../../"                     # Retour rapide 3 niveaux
alias .4="cd ../../../../"                  # Retour rapide 4 niveaux
alias .5="cd ../../../../../"               # Retour rapide 5 niveaux
alias .6="cd ../../../../../../"            # Retour rapide 6 niveaux

