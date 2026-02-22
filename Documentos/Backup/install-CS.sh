#!/bin/bash

# --- Configuración VM ---
PACKAGES="zsh bat eza ripgrep sddm thunar ttf-firacode-nerd ttf-nerd-fonts-symbols nwg-look firefox polybar picom feh rofi kitty  lxappearance lxqt-policykit scrot slop xclip jq ttf-iosevka-nerd"
AUR_PACKAGES="pokeget visual-studio-code-bin"

echo "🖥️ Iniciando instalación en Máquina Virtual..."

WORK_DIR=$(mktemp -d)

# 1. Actualizar e instalar base
sudo pacman -Syu --noconfirm
sudo pacman -Syu --needed base-devel --noconfirm
sudo pacman -S --needed --noconfirm $PACKAGES

# Activar servicios de VM inmediatamente
#sudo systemctl enable --now vboxservice.service
#sudo systemctl --user enable --now dbus-broker.service
sudo usermod -aG video $USER

# 2. Instalar Paru
echo "📦 Instalando Paru..."
git clone https://aur.archlinux.org/paru "$WORK_DIR/paru"
cd "$WORK_DIR/paru" && makepkg -si --noconfirm
cd -

# 3. AUR
paru -S --noconfirm $AUR_PACKAGES

# 4. Starship y Shell
curl -sS https://starship.rs/install.sh | sh
sudo chsh -s $(which zsh) $USER

#  Instalar sddm-theme-tokyo-night
git clone https://github.com/rototrash/tokyo-night-sddm.git "$WORK_DIR/sddm-theme"
sudo mv "$WORK_DIR/sddm-theme" /usr/share/sddm/themes/tokyo-night-sddm

echo -e "[Theme]\nCurrent=tokyo-night-sddm" | sudo tee /etc/sddm.conf

# 8. Restaurar archivos de sistema (Adaptado a VM)
echo "🔧 Restaurando configuraciones..."
SYSTEM_BACKUP_PATH="$HOME/Dotfiles/Documentos/Backup/SystemBackups/"
CONFIG_BACKUP_PATH="$HOME/Dotfiles/"

git clone --bare "$DOTFILES_REPO" "$HOME/.cfg"
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
config checkout -f

# if [ -d "$CONFIG_BACKUP_PATH" ]; then

#     cp -f "$CONFIG_BACKUP_PATH/.config" ~ -r
#     cp -f "$CONFIG_BACKUP_PATH/Documentos" ~ -r
#     cp -f "$CONFIG_BACKUP_PATH/Descargas" ~ -r
#     cp -f "$CONFIG_BACKUP_PATH/Pictures" ~ -r
#     cp -f "$CONFIG_BACKUP_PATH/Scripts" ~ -r
#     chmod +x $HOME/Scripts/*
#     cp -f "$CONFIG_BACKUP_PATH/.zshrc" ~ -r

# fi

if [ -d "$SYSTEM_BACKUP_PATH" ]; then
    sudo cp -f "$SYSTEM_BACKUP_PATH/etc/mkinitcpio.conf" /etc/mkinitcpio.conf
    sudo cp -f "$SYSTEM_BACKUP_PATH/etc/pacman.conf" /etc/pacman.conf

    sudo cp -ar "$SYSTEM_BACKUP_PATH/usr/." /usr/

    # if [ -f "$SYSTEM_BACKUP_PATH/polkit-1/rules.d/99-udisks2.rules" ]; then
    #     sudo mkdir -p /etc/polkit-1/rules.d
    #     sudo cp -f "$SYSTEM_BACKUP_PATH/polkit-1/rules.d/99-udisks2.rules" /etc/polkit-1/rules.d/
    # fi

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
