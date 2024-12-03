#!/bin/bash

git clone https://github.com/zsh-users/zsh-autosuggestions.git ~/.apps/zsh/zsh-autosuggestions
git clone https://github.com/zsh-users/zsh-history-substring-search.git ~/.apps/zsh/zsh-history-substring-search
git clone https://github.com/zsh-users/zsh-syntax-highlighting.git ~/.apps/zsh/zsh-syntax-highlighting

cp ./config/.tmux.conf ~/
cp ./config/.zshrc ~/
mkdir -p ~/.config
cp ./config/starship.toml ~/.config/
mkdir -p ~/.cache/zsh
