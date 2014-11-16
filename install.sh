#!/bin/bash
DIR="$( cd "$( dirname "${BASH_SOURCE[0]}" )" && pwd )"
if [ "$1" == "optiver" -o "$1" == "macbook" ]; then
	echo "Installing '$1' dotfiles"
	ln -s $DIR/bashrc $HOME/.bashrc
	ln -s $DIR/bashrc_$1 $HOME/.bashrc_$1
	ln -s $DIR/inputrc $HOME/.inputrc
	ln -s $DIR/vim $HOME/.vim
	ln -s $DIR/vimrc $HOME/.vimrc
else
	echo "Usage: install.sh [optiver|macbook]"
fi
