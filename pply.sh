#!/bin/zsh
if [[ "$(uname)" == "Linux" ]]; then
    cp -r .config/rofi $HOME/.config
fi

cp -r .config/ghostty $HOME/kitty/.config
cp -r .config/nvim $HOME/nvim/.config

cp -r .dir_colors $HOME/
cp .zshrc $HOME/
