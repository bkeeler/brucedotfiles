# The following lines were added by compinstall
setopt sunkeyboardhack
setopt extendedglob
setopt autopushd pushdminus pushdsilent pushdtohome pushdignoredups
setopt automenu
unsetopt bgnice
setopt autonamedirs
setopt rcexpandparam
#setopt chaselinks
setopt listtypes
setopt nullglob
setopt printexitvalue
setopt nohup
setopt auto_cd
setopt cdablevars
setopt correct correct_all
setopt histignoredups histignorespace hist_no_store
unsetopt notify
setopt numericglobsort

# The following lines were added by compinstall

zstyle ':completion:*' auto-description 'specify: %d'
zstyle ':completion:*' completer _expand _complete _correct _approximate
zstyle ':completion:*' format 'Completing %d'
zstyle ':completion:*' group-name ''
zstyle ':completion:*' insert-unambiguous true
zstyle ':completion:*' list-colors ''
zstyle ':completion:*' matcher-list '' 'm:{a-z}={A-Z}' 'r:|[._-]=** r:|=**' 'l:|=* r:|=*'
zstyle ':completion:*' menu select=long
zstyle ':completion:*' original true
zstyle ':completion:*' select-prompt %SScrolling active: current selection at %p%s
zstyle :compinstall filename '/home/keelerb/.zshrc'
autoload -Uz compinit
compinit
# End of lines added by compinstall
# Lines configured by zsh-newuser-install
HISTFILE=~/.histfile
HISTSIZE=1000
SAVEHIST=1000
bindkey -e

me=`whoami`
PROMPT="%m.%n"'|%~ %# '

insert-root-prefix () {
   local prefix
   case $(uname -s) in
      "SunOS")
         prefix="pfexec"
      ;;
      *) 
         prefix="sudo"
      ;;
   esac
   BUFFER="$prefix $BUFFER"
   CURSOR=$(($CURSOR + $#prefix + 1))
}

zle -N insert-root-prefix
bindkey "^[f" insert-root-prefix

source ~/.zaliases
