HISTFILE=~/.cache/zsh/histfile
HISTSIZE=10000
SAVEHIST=10000
HISTCONTROL=ignoredups:erasedups
bindkey -e
setopt share_history

export PATH="$HOME/bin:$PATH"
eval "$(starship init zsh)"
eval "$(zoxide init zsh)"

# FZF
# Ubuntu/Debian/openSUSE
if [[ -f "/usr/share/fzf/shell/key-bindings.zsh" ]]; then
    source /usr/share/fzf/shell/key-bindings.zsh
    source /usr/share/fzf/shell/completion.zsh
# Alpine Linux
elif [[ -f "/usr/share/zsh/plugins/fzf/fzf.plugin.zsh" ]]; then
    source /usr/share/zsh/plugins/fzf/fzf.plugin.zsh
else
    echo "FZF not configured!"
fi

export FZF_CTRL_T_OPTS=$FZF_CTRL_T_OPTS'
    --preview="bat --theme=Dracula --color=always --style=plain {}"'

export FZF_DEFAULT_OPTS=$FZF_DEFAULT_OPTS'
    --color=fg:-1,fg+:#d0d0d0,bg:-1,bg+:#262626
    --color=hl:#5f87af,hl+:#5fd7ff,info:#afaf87,marker:#87ff00
    --color=prompt:#d7005f,spinner:#af5fff,pointer:#af5fff,header:#87afaf
    --color=border:#262626,label:#aeaeae,query:#d9d9d9
    --border="rounded" --border-label="" --preview-window="border-rounded" --prompt="> "
    --marker=">" --pointer="◆" --separator="─" --scrollbar="│"'

source ~/.apps/zsh/zsh-autosuggestions/zsh-autosuggestions.zsh
source ~/.apps/zsh/zsh-history-substring-search/zsh-history-substring-search.zsh
source ~/.apps/zsh/zsh-syntax-highlighting/zsh-syntax-highlighting.zsh

alias ls='eza --icons'
alias ll='eza --icons -l'
