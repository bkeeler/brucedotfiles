export PATH=$HOME/bin:$PATH
eval "$(lesspipe)"

if [ -e ~/.zshenv."$OSTYPE" ] ; then
        source ~/.zshenv."$OSTYPE"
fi
if [ -e ~/.zshenv."$HOST" ] ; then
        source ~/.zshenv."$HOST"
fi

