# ===============================================================
# 1. ENTORNO Y PATHS (Prioridad Máxima)
# ===============================================================
typeset -U path PATH

# Variables de entorno
export ANDROID_HOME=/opt/android-sdk
export ANDROID_AVD_HOME="$HOME/.android/avd"
export LIBVIRT_DEFAULT_URI="qemu:///system"
export BROWSER="/usr/bin/helium-browser"
export FILE_MANAGER="thunar"
export EDITOR="code --wait"
export TERMINAL="footclient"

# Directorios a añadir al PATH (solo los que existen)
path_dirs=(
    "$HOME/.bun/bin"
    "$HOME/.cargo/bin"
    "$HOME/.local/bin"
    "$HOME/.opencode/bin"
    "$HOME/.pub-cache/bin"
    "$ANDROID_HOME/cmdline-tools/latest/bin"
    "$ANDROID_HOME/platform-tools"
    "$ANDROID_HOME/build-tools/37.0.0/")

# Añadir cada directorio al PATH solo si existe
for dir in $path_dirs; do
    [[ -d "$dir" ]] && path=("$dir" $path)
done
export PATH

# ===============================================================
# 2. GESTOR DE PLUGINS: ZINIT (Configuración Ultra-Turbo)
# ===============================================================
if [[ ! -f $HOME/.local/share/zinit/zinit.git/zinit.zsh ]]; then
    print -P "%F{33}Installing Zinit...%f"
    command mkdir -p "$HOME/.local/share/zinit"
    command git clone https://github.com/zdharma-continuum/zinit "$HOME/.local/share/zinit/zinit.git"
fi

source "$HOME/.local/share/zinit/zinit.git/zinit.zsh"

# Optimización de compinit con caché
autoload -Uz compinit
zstyle ':completion:*' use-cache true
zstyle ':completion:*' cache-path "$HOME/.cache/zsh/zcompcache"
compinit -u

# Estilos de autocompletado
zstyle ':completion:*' matcher-list 'm:{a-zA-Z}={A-Za-z}' 'r:|=*' 'l:|=*'
zstyle ':completion:*' list-colors "${(s.:.)LS_COLORS}"

# CARGA ASÍNCRONA: No bloquean el inicio de la terminal
zinit wait"0" lucid atinit"zinit cdreplay -q" for \
    zdharma-continuum/fast-syntax-highlighting \
    atload"!_zsh_autosuggest_start" \
    zsh-users/zsh-autosuggestions \
    blockf zsh-users/zsh-completions \
    zdharma-continuum/history-search-multi-word

# ===============================================================
# 3. ESTÉTICA Y PROMPT (Optimización de Starship)
# ===============================================================
# Cacheamos la inicialización para no ejecutar el binario cada vez
if [[ ! -f ~/.starship_init.zsh || ~/.config/starship.toml -nt ~/.starship_init.zsh ]]; then
    starship init zsh > ~/.starship_init.zsh
fi
source ~/.starship_init.zsh

# Pokefetch (Se ejecuta en segundo plano para no retrasar el prompt)
source ~/Scripts/pokefetch.sh

# ===============================================================
# 4. ALIAS Y MODERN TOOLS
# ===============================================================
# alias proyectos="cd /mnt/HDD/Programacion/Proyectos"
# alias uni="cd /mnt/HDD/Programacion/Universidad"
# alias cursos="cd /mnt/HDD/Programacion/Cursos"
alias uni="cd ~/Programacion/Uni"
alias proyectos="cd ~/Programacion/Proyectos"
alias code='uwsm-app code'
alias obsidian='uwsm-app .local/bin/Obsidian.AppImage'

# eza (sustituto de ls)
alias ls='eza --icons --group-directories-first'
alias ll='eza -lh --icons --grid --group-directories-first'
alias la='eza -lah --icons --group-directories-first'
alias tree='eza --tree --icons'

# Reemplazos modernos
alias grep='rg'
alias cat='bat'
alias cls='clear'

alias pyvenv='uv venv'
alias pyactivate='source .venv/bin/activate'

# Config (dotfiles con git)
alias config='git --git-dir="$HOME/.cfg/" --work-tree="$HOME"'

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

# bun completions
[ -s "/home/gery/.bun/_bun" ] && source "/home/gery/.bun/_bun"
