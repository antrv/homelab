#!/bin/bash

zypper ref
zypper update -y
zypper in -y docker docker-buildx docker-compose btop bat zsh fzf mc eza tmux starship git zoxide
systemctl enable docker
systemctl start docker

username=$(id -nu 1000)
usermod -aG docker -s /bin/zsh $username
