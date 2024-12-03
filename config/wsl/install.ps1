wsl --update
wsl --install openSUSE-Tumbleweed --web-download
wsl -d openSUSE-Tumbleweed -u root ./scripts/01-convert-to-slowroll.sh
wsl -d openSUSE-Tumbleweed -u root ./scripts/02-install-patterns.sh
wsl -t openSUSE-Tumbleweed
wsl -d openSUSE-Tumbleweed -u root ./scripts/03-install-packages.sh
wsl -d openSUSE-Tumbleweed ./scripts/04-configure-zsh.sh
