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

HISTSIZE=100
READNULLCMD=less
me=`whoami`
PROMPT="%m.%n"'|%~ %# '

bindkey -e
# The following lines were added by compinstall

zstyle :compinstall filename '/home/bruce/.zshrc'

autoload -U compinit
compinit
# End of lines added by compinstall
