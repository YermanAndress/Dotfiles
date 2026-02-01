#!/bin/bash

# --- Configuración ---
DOTFILES_REPO="https://github.com/YermanAndress/Dotfiels.git"
PACKAGES="linux-headers zsh bat eza ripgrep thunar base-devel git ttf-firacode-nerd ttf-nerd-fonts-symbols-common nwg-look rsync"
AUR_PACKAGES="paru-bin zen-browser-bin dank-material-shell pear-desktop pokeget rtl8821ce-dkms-git sddm-theme-tokyo-night visual-studio-code-bin"

echo "🎨 Iniciando instalación estilo 'Dank'..."

# Crear carpeta temporal única para todo el script
WORK_DIR=$(mktemp -d)

# 1. Actualizar sistema e instalar dependencias básicas
sudo pacman -Syu --noconfirm
sudo pacman -S --needed --noconfirm $PACKAGES

# 2. Instalar Paru (si no está instalado)
if ! command -v paru &> /dev/null; then
    echo "📦 Instalando Paru..."
    git clone https://aur.archlinux.org/paru-bin.git "$WORK_DIR/paru"
    cd "$WORK_DIR/paru" && makepkg -si --noconfirm
    cd -
fi

# 3. Instalar aplicaciones de AUR
echo "🚀 Instalando paquetes de AUR..."
paru -S --noconfirm $AUR_PACKAGES

# 4. Configurar Starship y ZSH
echo "🚀 Instalando Starship..."
curl -sS https://starship.rs/install.sh | sh -s -- -y

if [ "$SHELL" != "/usr/bin/zsh" ]; then
    echo "🐚 Cambiando a ZSH..."
    chsh -s $(which zsh)
fi

# 5. Instalar tema de Grub (Solara)
echo "🖼️ Instalando tema de Grub..."
git clone https://github.com/vinceliuice/Solara-grub2-theme.git "$WORK_DIR/solara"
cd "$WORK_DIR/solara" && sudo ./install.sh
cd -

# 6. Desplegar Dotfiles (Método Git Bare)
echo "📂 Clonando configuraciones..."
git clone --separate-git-dir=$HOME/.cfg "$DOTFILES_REPO" $HOME/tmp_dotfiles
rsync --recursive -vhP $HOME/tmp_dotfiles/ $HOME/
rm -rf $HOME/tmp_dotfiles

# 8. Restaurar archivos de sistema (SystemBackups)
# 8. Restaurar archivos de sistema (SystemBackups)
echo "🔧 Restaurando configuraciones de sistema (/etc)..."
BACKUP_PATH="$HOME/SystemBackups/etc"

if [ -d "$BACKUP_PATH" ]; then
    # 1. Archivos base en /etc
    sudo cp -f "$BACKUP_PATH/fstab" /etc/fstab
    sudo cp -f "$BACKUP_PATH/mkinitcpio.conf" /etc/mkinitcpio.conf
    sudo cp -f "$BACKUP_PATH/pacman.conf" /etc/pacman.conf

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