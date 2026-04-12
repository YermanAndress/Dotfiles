#!/bin/bash

# --- Configuración VM ---
PACKAGES="linux-headers zsh bat eza ripgrep sddm thunar ttf-firacode-nerd ttf-nerd-fonts-symbols nwg-look"
AUR_PACKAGES="pokeget visual-studio-code-bin quickshell-git"

echo "🖥️ Iniciando instalación en Máquina Virtual..."

WORK_DIR=$(mktemp -d)

# 0. Instalar CachyOs Mirros
curl https://mirror.cachyos.org/cachyos-repo.tar.xz -o cachyos-repo.tar.xz
tar xvf cachyos-repo.tar.xz
cd cachyos-repo
sudo ./cachyos-repo.sh
cd "$WORK_DIR"

# 1. Actualizar sistema e instalar dependencias básicas
sudo pacman -Syu --noconfirm
sudo pacman -S --needed base-devel git --noconfirm
sudo pacman -S --needed --noconfirm $PACKAGES

# Activar servicios de VM inmediatamente
#sudo systemctl enable --now vboxservice.service
#sudo systemctl --user enable --now dbus-broker.service
sudo usermod -aG video $USER

# 2. Instalar Paru
echo "📦 Instalando Paru..."
cargo install --git https://github.com/Morganamilo/paru.git

curl -fsSL https://install.danklinux.com | sh

# 3. Instalar aplicaciones de AUR
echo "🚀 Instalando paquetes de AUR..."
$HOME/.cargo/bin/paru -S --noconfirm $AUR_PACKAGES

# 4. Configurar Starship y ZSH
echo "🚀 Instalando Starship..."
curl -sS https://starship.rs/install.sh | sh -s -- -y
chsh -s $(which zsh)

#  Instalar sddm-theme-tokyo-night
git clone https://github.com/rototrash/tokyo-night-sddm.git "$WORK_DIR/sddm-theme"
sudo mv "$WORK_DIR/sddm-theme" /usr/share/sddm/themes/tokyo-night-sddm
echo -e "[Theme]\nCurrent=tokyo-night-sddm" | sudo tee /etc/sddm.conf

# 8. Restaurar archivos de sistema (Adaptado a VM)
echo "🔧 Restaurando configuraciones..."
SYSTEM_BACKUP_PATH="$HOME/Dotfiles/Documentos/Backup/SystemBackups/etc"
CONFIG_BACKUP_PATH="$HOME/Dotfiles/"

git clone --bare "$DOTFILES_REPO" "$HOME/.cfg"
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
config checkout -f


if [ -d "$SYSTEM_BACKUP_PATH" ]; then
    sudo cp -f "$SYSTEM_BACKUP_PATH/mkinitcpio.conf" /etc/mkinitcpio.conf
    sudo cp -f "$SYSTEM_BACKUP_PATH/pacman.conf" /etc/pacman.conf

    sudo mkinitcpio -P
    echo "✅ Restauración parcial completada."
else
    echo "⚠️ No se encontró SystemBackups."
fi


rm -rf "$WORK_DIR"

# Alias permanente
echo "alias config='/usr/bin/git --git-dir=\$HOME/.cfg/ --work-tree=\$HOME'" >> ~/.zshrc

echo "config config --local status.showUntrackedFiles no"

echo "✨ ¡Hecho! VM lista. Reinicia para activar los drivers de invitado."
