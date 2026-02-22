# ===============================================================
# 1. ENTORNO Y PATHS (Prioridad Máxima)
# ===============================================================
export FNM_DIR="$HOME/.local/share/fnm"
export BUN_INSTALL="$HOME/.bun"

export PATH="$FNM_DIR:$BUN_INSTALL/bin:$HOME/.cargo/bin:$HOME/.local/bin:$PATH"

export FILE_MANAGER="thunar"
export EDITOR="code --wait"
export TERMINAL="kitty"

# ===============================================================
# 2. GESTOR DE PLUGINS: ZINIT (Configuración Ultra-Turbo)
# ===============================================================
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33}Installing Zinit...%f"
    command mkdir -p "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"

# Optimización de compinit: Solo escanea si el dump tiene más de 24 horas
autoload -Uz compinit
if [[ -n ~/.zcompdump(#qN.m-1) ]]; then
    compinit -C
else
    compinit -i -d ~/.zcompdump
fi

# Estilos de autocompletado
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

zinit cdreplay -q

# CARGA ASÍNCRONA: No bloquean el inicio de la terminal
zinit wait"0" lucid for \
    atload'eval "$(fnm env --use-on-cd --shell zsh)"' \
    zdharma-continuum/fast-syntax-highlighting \
    atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
    blockf zsh-users/zsh-completions \
    zdharma-continuum/history-search-multi-word

# ===============================================================
# 3. ESTÉTICA Y PROMPT (Optimización de Starship)
# ===============================================================
# Cacheamos la inicialización para no ejecutar el binario cada vez

# if [[ ! -f ~/.starship_init.zsh ]]; then
#     starship init zsh > ~/.starship_init.zsh
# fi

eval "$(starship init zsh)"

# Pokefetch (Se ejecuta en segundo plano para no retrasar el prompt)
[[ -f ~/Scripts/pokefetch.sh ]] && source ~/Scripts/pokefetch.sh
#(~/scripts/pokefetch.sh &)

# ===============================================================
# 4. ALIAS Y MODERN TOOLS
# ===============================================================
alias proyectos="cd /mnt/HDD/Programacion/Proyectos"
alias uni="cd /mnt/HDD/Programacion/Universidad"
alias cursos="cd /mnt/HDD/Programacion/Cursos"
alias idea='uwsm app -- intellij-idea-ultimate-edition'
alias code='uwsm app -- code'
alias obsidian='uwsm app -- .local/bin/Obsidian-1.11.7.AppImage'

# eza (sustituto de ls)
alias ls='eza --icons --group-directories-first'
alias ll='eza -lh --icons --grid --group-directories-first'
alias la='eza -lah --icons --group-directories-first'
alias tree='eza --tree --icons'

# Reemplazos modernos
alias grep='rg'
alias cat='bat'
alias cls='clear'

alias pyvenv='python -m venv .venv'


echo "alias config='/usr/bin/git --git-dir=\$HOME/.cfg/ --work-tree=\$HOME'" >> ~/.zshrc

# ===============================================================
# 5. HISTORIAL Y BINDS (Fijados para Wayland)
# ===============================================================
HISTFILE=~/.zsh_history
HISTSIZE=10000
SAVEHIST=10000
setopt hist_ignore_all_dups share_history extended_history inc_append_history

# Asegurar widgets
zle -N forward-kill-word

bindkey -e
bindkey '^[[3~' delete-char                     # Supr
bindkey '^H' backward-kill-word                 # Ctrl + Backspace
bindkey '^[[3;5~' kill-word                     # Ctrl + Supr
bindkey '^[[1;5D' backward-word                 # Ctrl + Izquierda
bindkey '^[[1;5C' forward-word                  # Ctrl + Derecha
bindkey '^[[A' up-line-or-history               # Arriba
bindkey '^[[B' down-line-or-history             # Abajo
bindkey "^[[H" beginning-of-line                # Home
bindkey "^[[F" end-of-line                      # End
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
