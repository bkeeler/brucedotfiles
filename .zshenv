export VISUAL=vi
export EXINIT='set ai sw=4'
export NAME="Bruce J. Keeler"
export PAGER=less
export LESS=-Mids

export PATH=$HOME/bin:$PATH
eval "$(lesspipe)"

if [ -e ~/.zshenv."$OSTYPE" ] ; then
        source ~/.zshenv."$OSTYPE"
fi
if [ -e ~/.zshenv."$HOST" ] ; then
        source ~/.zshenv."$HOST"
fi

