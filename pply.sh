#!/bin/zsh

if [[ "$(uname)" == "Linux" ]]; then
    cp -r .config $HOME/
elif [[ "$(uname)" == "Darwin" ]]; then
    cp -r .config/kitty $HOME/kitty/
    cp -r .config/nvim $HOME/nvim/
fi

cp -r .dir_colors $HOME/
cp .zshrc $HOME/
