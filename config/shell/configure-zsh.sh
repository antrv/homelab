#!/bin/sh

# This script configures zsh with plugins and starship prompt.
# It should be idempotent and safe to run multiple times.

# Check if zsh is already configured
if [ ! -f "$HOME/.config/zsh-configured" ]; then
    echo "Configuring zsh for the first time..."

    # Create necessary directories
    mkdir -p "$HOME/.config" "$HOME/.cache/zsh" "$HOME/bin" "$HOME/.apps/zsh"
    PATH="$HOME/bin:$PATH"
    export PATH

    # List of common packages
    pkgs="zsh zoxide eza fzf bat tmux git wget curl"

    # Decide whether to use sudo
    if [ "$(id -u)" -eq 0 ]; then
        SUDO=""
    else
        SUDO="sudo"
    fi

    # Check distribution and install packages
    if command -v zypper >/dev/null 2>&1; then
        echo "This is openSUSE."
        if ! $SUDO sh -c "zypper refresh && zypper install -y starship $pkgs"; then
            echo "Package installation failed on openSUSE, aborting."
            exit 1
        fi
    elif command -v apt >/dev/null 2>&1; then
        echo "This is Debian or Ubuntu."

        if ! $SUDO sh <<'EOF'
set -e
apt update
if apt-cache show starship >/dev/null 2>&1; then
    echo "Starship package found in APT repos."
    pkgs="starship zsh zoxide eza fzf bat tmux git wget curl"
else
    echo "Starship package not found in APT repos, will skip for now."
    pkgs="zsh zoxide eza fzf bat tmux git wget curl"
fi
apt install -y $pkgs
EOF
        then
            echo "Package installation failed on Debian/Ubuntu, aborting."
            exit 1
        fi
    elif command -v apk >/dev/null 2>&1; then
        echo "This is Alpine Linux."
        if ! $SUDO sh -c "apk update && apk add starship shadow $pkgs"; then
            echo "Package installation failed on Alpine, aborting."
            exit 1
        fi
    else
        echo "Unsupported distribution."
        exit 1
    fi

    # If starship not installed from repos, fetch binary
    if ! command -v starship >/dev/null 2>&1; then
        echo "Installing Starship from GitHub binary..."
        url="https://github.com/starship/starship/releases/latest/download/starship-$(uname -m)-unknown-linux-musl.tar.gz"

        tmpdir=$(mktemp -d 2>/dev/null || echo "/tmp/starship.$$")
        if curl -fsSL "$url" -o "$tmpdir/starship.tar.gz"; then
            tar -xzf "$tmpdir/starship.tar.gz" -C "$tmpdir" || exit 1
            mv "$tmpdir/starship" "$HOME/bin/" || exit 1
            chmod +x "$HOME/bin/starship"
            echo "Starship installed in $HOME/bin."
        else
            echo "Failed to download Starship binary from GitHub."
            exit 1
        fi
        rm -rf "$tmpdir"
    fi

    # Clone zsh plugins
    for repo in \
        "zsh-users/zsh-autosuggestions" \
        "zsh-users/zsh-history-substring-search" \
        "zsh-users/zsh-syntax-highlighting"
    do
        name=$(basename "$repo")
        if [ ! -d "$HOME/.apps/zsh/$name" ]; then
            git clone "https://github.com/$repo.git" "$HOME/.apps/zsh/$name" 2>/dev/null || true
        fi
    done
    
    # Set zsh as default shell if not already
    if [ "$SHELL" != "$(command -v zsh)" ]; then
        if command -v chsh >/dev/null 2>&1; then
            chsh -s "$(command -v zsh)" || true
        else
            echo "chsh command not found, please change your default shell to zsh manually."
        fi
    fi

    # Download .zshrc
    if [ ! -f "$HOME/.zshrc" ]; then
        echo "Downloading .zshrc..."
        if ! curl -fsSL "https://raw.githubusercontent.com/antrv/homelab/main/config/shell/.zshrc" -o "$HOME/.zshrc"; then
            echo "Failed to download .zshrc, aborting."
            exit 1
        fi
    fi

    # Download starship config
    if [ ! -f "$HOME/.config/starship.toml" ]; then
        echo "Downloading starship.toml..."
        mkdir -p "$HOME/.config"
        if ! curl -fsSL "https://raw.githubusercontent.com/antrv/homelab/main/config/shell/.config/starship.toml" -o "$HOME/.config/starship.toml"; then
            echo "Failed to download starship.toml, aborting."
            exit 1
        fi
    fi

    # Download tmux config
    if [ ! -f "$HOME/.tmux.conf" ]; then
        echo "Downloading .tmux.conf..."
        if ! curl -fsSL "https://raw.githubusercontent.com/antrv/homelab/main/config/shell/.tmux.conf" -o "$HOME/.tmux.conf"; then
            echo "Failed to download .tmux.conf, aborting."
            exit 1
        fi
    fi

    # Create a marker file to indicate zsh has been configured
    touch "$HOME/.config/zsh-configured"
    echo "Zsh configuration completed."
    exec zsh -l
else
    echo "zsh is already configured, skipping installation steps."
fi
