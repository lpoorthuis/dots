#!/bin/zsh

cp $HOME/.zshrc ./
cp -r $HOME/.dir_colors ./

cp -r $HOME/.config/ghostty ./.config/
cp -r $HOME/.config/nvim ./.config/

if [[ "$(uname)" == "Linux" ]]; then
    cp -r $HOME/.config/rofi ./.config/
fi
