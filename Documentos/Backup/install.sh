#!/bin/bash

# --- Configuración ---
DOTFILES_REPO="https://github.com/YermanAndress/Dotfiles.git"
PACKAGES="linux-headers linux-firmware xf86-video-amdgpu mesa libva-mesa-driver amd-ucode zsh bat eza ripgrep thunar ttf-firacode-nerd ttf-nerd-fonts-symbols nwg-look rsync brave-bin"
AUR_PACKAGES="pear-desktop pokeget rtl8821ce-dkms-git visual-studio-code-bin"

echo "🎨 Iniciando instalación estilo.."

# Crear carpeta temporal única para todo el script
WORK_DIR=$(mktemp -d)

# 1. Actualizar sistema e instalar dependencias básicas
sudo pacman -Syu --noconfirm
sudo pacman -Syu --needed base-devel --noconfirm
sudo pacman -S --needed --noconfirm $PACKAGES

# 2. Instalar Paru
echo "📦 Instalando Paru..."
git clone https://aur.archlinux.org/paru-bin "$WORK_DIR/paru"
cd "$WORK_DIR/paru" && makepkg -si --noconfirm
cd -


curl -fsSL https://install.danklinux.com | sh


# 3. Instalar aplicaciones de AUR
echo "🚀 Instalando paquetes de AUR..."
paru -S --noconfirm $AUR_PACKAGES

# 4. Configurar Starship y ZSH
echo "🚀 Instalando Starship..."
curl -sS https://starship.rs/install.sh | sh -s -- -y
chsh -s $(which zsh)


# 5. Instalar tema de Grub (Solara)
echo "🖼️ Instalando tema de Grub..."
git clone https://github.com/vinceliuice/Solara-grub2-theme.git "$WORK_DIR/solara"
cd "$WORK_DIR/solara" && sudo ./install.sh
cd -

git clone https://github.com/rototrash/tokyo-night-sddm.git "$WORK_DIR/sddm-theme"
sudo mv "$WORK_DIR/sddm-theme" /usr/share/sddm/themes/tokyo-night-sddm
echo -e "[Theme]\nCurrent=tokyo-night-sddm" | sudo tee /etc/sddm.conf

git clone https://github.com/AdnanHodzic/auto-cpufreq.git
cd auto-cpufreq && sudo ./auto-cpufreq-installer
sudo auto-cpufreq --install

# 8. Restaurar archivos de sistema (SystemBackups)
echo "🔧 Restaurando configuraciones de sistema (/etc)..."
BACKUP_PATH="$HOME/SystemBackups/etc"
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


if [ -d "$BACKUP_PATH" ]; then
    # 1. Archivos base en /etc
    sudo cp -f "$BACKUP_PATH/fstab" /etc/fstab
    sudo cp -f "$BACKUP_PATH/mkinitcpio.conf" /etc/mkinitcpio.conf
    sudo cp -f "$BACKUP_PATH/pacman.conf" /etc/pacman.conf
    sudo cp -f "$BACKUP_PATH/auto-cpufreq.conf" /etc/auto-cpufreq.conf

    # 2. Configuración de GRUB (si aplica)
    if [ -f "$BACKUP_PATH/default/grub" ]; then
        sudo cp -f "$BACKUP_PATH/default/grub" /etc/default/grub
        sudo grub-mkconfig -o /boot/grub/grub.cfg
    fi

    # 3. Kernel cmdline (systemd-boot)
    if [ -f "$BACKUP_PATH/kernel/cmdline" ]; then
        sudo mkdir -p /etc/kernel
        sudo cp -f "$BACKUP_PATH/kernel/cmdline" /etc/kernel/cmdline
    fi

    # 4. Polkit (Reglas de montaje)
    if [ -f "$BACKUP_PATH/polkit-1/rules.d/99-udisks2.rules" ]; then
        sudo mkdir -p /etc/polkit-1/rules.d
        sudo cp -f "$BACKUP_PATH/polkit-1/rules.d/99-udisks2.rules" /etc/polkit-1/rules.d/
    fi

    # 5. Systemd (Network y Resolved)
    if [ -d "$BACKUP_PATH/systemd" ]; then
        sudo mkdir -p /etc/systemd/network
        sudo cp -f "$BACKUP_PATH/systemd/network/20-wireless.network" /etc/systemd/network/
        sudo cp -f "$BACKUP_PATH/systemd/resolved.conf" /etc/systemd/resolved.conf
        sudo systemctl enable --now systemd-networkd systemd-resolved
    fi

    # Crear punto de montaje para el HDD y regenerar initramfs
    sudo mkdir -p /mnt/HDD
    sudo mkinitcpio -P
    echo "✅ Restauración de /etc completada."
else
    echo "⚠️  No se encontró la carpeta $BACKUP_PATH. Saltando paso."
fi



# Limpieza final de temporales
rm -rf "$WORK_DIR"

# Configurar el alias de forma permanente para esta sesión
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
config config --local status.showUntrackedFiles no

echo "✨ ¡Hecho! Tu sistema Arch está listo. Reinicia para aplicar todos los cambios."
