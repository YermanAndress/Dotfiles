#!/bin/bash

# --- Configuración VM ---
DOTFILES_REPO="https://github.com/YermanAndress/Dotfiles.git"
PACKAGES="zsh bat eza ripgrep thunar base-devel git ttf-firacode-nerd ttf-nerd-fonts-symbols-common nwg-look rsync virtualbox-guest-utils"
AUR_PACKAGES="paru-bin zen-browser-bin pokeget sddm-theme-tokyo-night visual-studio-code-bin"

echo "🖥️ Iniciando instalación en Máquina Virtual..."

WORK_DIR=$(mktemp -d)

# 1. Actualizar e instalar base
sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm $PACKAGES

# Activar servicios de VM inmediatamente
sudo systemctl enable --now vboxservice.service

# 2. Instalar Paru
if ! command -v paru &> /dev/null; then
    echo "📦 Instalando Paru..."
    git clone https://aur.archlinux.org/paru-bin.git "$WORK_DIR/paru"
    cd "$WORK_DIR/paru" && makepkg -si --noconfirm
    cd -
fi

curl -fsSL https://install.danklinux.com | sh

# 3. AUR
paru -S --noconfirm $AUR_PACKAGES

# 4. Starship y Shell
curl -sS https://starship.rs/install.sh | sh -s -- -y
[ "$SHELL" != "/usr/bin/zsh" ] && chsh -s $(which zsh)

# 6. Desplegar Dotfiles (Git Bare)
echo "📂 Clonando configuraciones..."
git clone --separate-git-dir=$HOME/.cfg -b main "$DOTFILES_REPO" $HOME/tmp_dotfiles
rsync --recursive -vhP $HOME/tmp_dotfiles/ $HOME/
rm -rf $HOME/tmp_dotfiles

# 8. Restaurar archivos de sistema (Adaptado a VM)
echo "🔧 Restaurando configuraciones..."
BACKUP_PATH="$HOME/SystemBackups/etc"

if [ -d "$BACKUP_PATH" ]; then
    # Solo copiamos lo que tiene sentido en una VM (pacman, mkinitcpio)
    # NO copiamos fstab ni network si la VM usa NAT/Bridge estándar
    sudo cp -f "$BACKUP_PATH/mkinitcpio.conf" /etc/mkinitcpio.conf
    sudo cp -f "$BACKUP_PATH/pacman.conf" /etc/pacman.conf
    
    # El polkit sigue siendo útil si montas carpetas compartidas
    if [ -f "$BACKUP_PATH/polkit-1/rules.d/99-udisks2.rules" ]; then
        sudo mkdir -p /etc/polkit-1/rules.d
        sudo cp -f "$BACKUP_PATH/polkit-1/rules.d/99-udisks2.rules" /etc/polkit-1/rules.d/
    fi

    sudo mkinitcpio -P
    echo "✅ Restauración parcial completada."
else
    echo "⚠️ No se encontró SystemBackups."
fi

rm -rf "$WORK_DIR"

# Alias permanente
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
config config --local status.showUntrackedFiles no

echo "✨ ¡Hecho! VM lista. Reinicia para activar los drivers de invitado."