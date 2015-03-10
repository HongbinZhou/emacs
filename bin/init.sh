#!/bin/sh

# install cask
curl -fsSL https://raw.githubusercontent.com/cask/cask/master/go | python

whereAmI=$(dirname $(readlink -f $0))
# link .emacs
ln -s $whereAmI/../lisp/dotemacs ~/.emacs

[[ ! -d ~/.emacs.d ]] && echo "Error: ~/.emacs.d not exist! Please rename the cloned repo to .emacs.d"
