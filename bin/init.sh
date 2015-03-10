#!/bin/sh

# install cask
if ! type cask > /dev/null
then
    curl -fsSL https://raw.githubusercontent.com/cask/cask/master/go | python2
fi

whereAmI=$(dirname $(readlink -f $0))

# link .emacs
[[ ! -s ~/.emacs ]] && ln -s $whereAmI/../lisp/dotemacs ~/.emacs

[[ ! -d ~/.emacs.d ]] && echo "Error: ~/.emacs.d not exist! Please rename the cloned repo to .emacs.d"

(
    cd ~/.emacs.d
    git submodule init
    git submodule update
)
