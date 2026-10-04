#!/bin/bash

# --- Configuración ---
DOTFILES_REPO="https://github.com/YermanAndress/Dotfiles.git"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
BACKUP_PATH="$SCRIPT_DIR/SystemBackups/etc"
REFIND_BACKUP="$SCRIPT_DIR/SystemBackups/refind"
PACKAGES="linux-headers linux-firmware xf86-video-amdgpu mesa libva-mesa-driver amd-ucode zsh bat eza ripgrep thunar ttf-firacode-nerd ttf-nerd-fonts-symbols nwg-look code wireless-regdb gnome-keyring libsecret zed zram-generator unzip qt6-graphicaleffects qt6-quickcontrols qt6-quickcontrols2 qt6-declarative fastfetch micro hyprpolkitagent pacman-contrib refind"
AUR_PACKAGES="pear-desktop pokeget auto-cpufreq memavaild brave-origin-bin helium-browser-bin"

echo "🎨 Iniciando instalación estilo.."

# Crear carpeta temporal única para todo el script
WORK_DIR=$(mktemp -d)
trap 'rm -rf "$WORK_DIR"' EXIT

# 0. Instalar CachyOS Mirrors
cd "$WORK_DIR"
curl https://mirror.cachyos.org/cachyos-repo.tar.xz -o cachyos-repo.tar.xz
tar xvf cachyos-repo.tar.xz && cd cachyos-repo
sudo ./cachyos-repo.sh
cd "$WORK_DIR"

# 1. Actualizar sistema e instalar dependencias básicas
sudo pacman -Syu --noconfirm
sudo pacman -S --needed base-devel git --noconfirm
for pkg in $PACKAGES; do
    sudo pacman -S --needed --noconfirm "$pkg" || echo "⚠️ Falló: $pkg, continuando..."
done

# 2. Instalar Yay (vía makepkg)
echo "📦 Instalando Yay..."
git clone https://aur.archlinux.org/yay.git "$WORK_DIR/yay"
cd "$WORK_DIR/yay" && makepkg -si --noconfirm
cd "$WORK_DIR"

echo "📦 Instalando danklinux..."
curl -fsSL https://install.danklinux.com | sh

# 3. Instalar aplicaciones de AUR (yay también resuelve repos)
echo "🚀 Instalando paquetes de AUR..."
for pkg in $AUR_PACKAGES; do
    yay -S --needed --noconfirm "$pkg" || echo "⚠️ Falló AUR: $pkg, continuando..."
done

# 4. Configurar Starship y ZSH
echo "🚀 Instalando Starship..."
curl -sS https://starship.rs/install.sh | sh -s -- -y
chsh -s "$(which zsh)" "$USER"

# 5. rEFInd (único bootloader)
echo "🖥️ Instalando rEFInd..."
sudo refind-install || echo "⚠️ refind-install falló, revisa tu ESP en /boot"
if [ -f "$REFIND_BACKUP/refind.conf" ]; then
    sudo mkdir -p /boot/EFI/refind
    sudo cp -f "$REFIND_BACKUP/refind.conf" /boot/EFI/refind/refind.conf
    if [ -d "$REFIND_BACKUP/themes" ]; then
        sudo mkdir -p /boot/EFI/refind/themes
        sudo cp -rf "$REFIND_BACKUP/themes/." /boot/EFI/refind/themes/
    fi
    # UUIDs de ESTA máquina (nunca hardcodear los del backup)
    ROOT_UUID="$(findmnt -no UUID / 2>/dev/null)"
    ESP_PARTUUID="$(findmnt -no PARTUUID /boot 2>/dev/null)"
    [ -n "$ESP_PARTUUID" ] && sudo sed -i -E "s|^([[:space:]]*volume[[:space:]]+).*|\1\"$ESP_PARTUUID\"|" /boot/EFI/refind/refind.conf
    [ -n "$ROOT_UUID" ] && sudo sed -i -E "s|root=UUID=[^[:space:]\"]+|root=UUID=$ROOT_UUID|" /boot/EFI/refind/refind.conf
    sudo sed -i -E "s/^timeout .*/timeout 5/" /boot/EFI/refind/refind.conf
    echo "✅ rEFInd desplegado."
else
    echo "⚠️ No se encontró $REFIND_BACKUP/refind.conf. Saltando config."
fi

# 6. Instalar Tema SDDM
git clone https://github.com/rototrash/tokyo-night-sddm.git "$WORK_DIR/sddm-theme"
sudo mkdir -p /usr/share/sddm/themes
sudo rm -rf /usr/share/sddm/themes/tokyo-night-sddm
sudo mv "$WORK_DIR/sddm-theme" /usr/share/sddm/themes/tokyo-night-sddm

# 7. Clonar dotfiles ANTES de restaurar (el backup vive en el repo)
echo "🔧 Clonando dotfiles..."
git clone --bare "$DOTFILES_REPO" "$HOME/.cfg"
/usr/bin/git --git-dir="$HOME/.cfg/" --work-tree="$HOME" checkout -f
/usr/bin/git --git-dir="$HOME/.cfg/" --work-tree="$HOME" config --local status.showUntrackedFiles no
grep -q "alias config=" ~/.zshrc || echo "alias config='/usr/bin/git --git-dir=\$HOME/.cfg/ --work-tree=\$HOME'" >> ~/.zshrc

# 8. Restaurar archivos de sistema (SystemBackups)
echo "🔧 Restaurando configuraciones de sistema (/etc)..."

if [ -d "$BACKUP_PATH" ]; then
    # 1. Archivos base en /etc
    sudo cp -f "$BACKUP_PATH/mkinitcpio.conf" /etc/mkinitcpio.conf
    sudo cp -f "$BACKUP_PATH/pacman.conf" /etc/pacman.conf
    sudo cp -f "$BACKUP_PATH/fstab" /etc/fstab

    # 2. mkinitcpio presets + SDDM
    if [ -d "$BACKUP_PATH/mkinitcpio.d" ]; then
        sudo mkdir -p /etc/mkinitcpio.d
        sudo cp -f "$BACKUP_PATH/mkinitcpio.d/"* /etc/mkinitcpio.d/
    fi
    sudo cp -f "$BACKUP_PATH/sddm.conf" /etc/sddm.conf
    if [ -d "$BACKUP_PATH/sddm.conf.d" ]; then
        sudo mkdir -p /etc/sddm.conf.d
        sudo cp -f "$BACKUP_PATH/sddm.conf.d/"* /etc/sddm.conf.d/
    fi

    # 3. Polkit (Reglas de montaje)
    if [ -f "$BACKUP_PATH/polkit-1/rules.d/99-udisks2.rules" ]; then
        sudo mkdir -p /etc/polkit-1/rules.d
        sudo cp -f "$BACKUP_PATH/polkit-1/rules.d/99-udisks2.rules" /etc/polkit-1/rules.d/
    fi

    # 4. Systemd (Network y Resolved + logind + journald)
    if [ -d "$BACKUP_PATH/systemd" ]; then
        sudo mkdir -p /etc/systemd/network
        sudo cp -f "$BACKUP_PATH/systemd/network/20-wlan.network" /etc/systemd/network/
        sudo cp -f "$BACKUP_PATH/systemd/network/20-ethernet.network" /etc/systemd/network/
        sudo cp -f "$BACKUP_PATH/systemd/network/20-wwan.network" /etc/systemd/network/
        sudo cp -f "$BACKUP_PATH/systemd/resolved.conf" /etc/systemd/resolved.conf
        sudo cp -f "$BACKUP_PATH/systemd/logind.conf" /etc/systemd/logind.conf
        sudo systemctl enable --now systemd-networkd systemd-resolved
    fi
    if [ -d "$BACKUP_PATH/systemd/journald.conf.d" ]; then
        sudo mkdir -p /etc/systemd/journald.conf.d
        sudo cp -f "$BACKUP_PATH/systemd/journald.conf.d/"* /etc/systemd/journald.conf.d/
        sudo systemctl restart systemd-journald
    fi

    # 5. Blacklist + wireless-regdom
    if [ -d "$BACKUP_PATH/modprobe.d" ]; then
        sudo mkdir -p /etc/modprobe.d
        sudo cp -f "$BACKUP_PATH/modprobe.d/"* /etc/modprobe.d/
    fi
    if [ -f "$BACKUP_PATH/conf.d/wireless-regdom" ]; then
        sudo mkdir -p /etc/conf.d
        sudo cp -f "$BACKUP_PATH/conf.d/wireless-regdom" /etc/conf.d/
    fi

    # 6. sysctl (pro-zram 100/75/125/10/5 + BBR, desde el backup)
    if [ -d "$BACKUP_PATH/sysctl.d/" ]; then
        sudo mkdir -p /etc/sysctl.d
        sudo cp -f "$BACKUP_PATH/sysctl.d/"* /etc/sysctl.d/
        sudo sysctl --system
    fi

    # 7. udev + auto-cpufreq (desde el backup, ya no heredoc)
    if [ -d "$BACKUP_PATH/udev/rules.d" ]; then
        sudo mkdir -p /etc/udev/rules.d
        sudo cp -f "$BACKUP_PATH/udev/rules.d/"* /etc/udev/rules.d/
        sudo udevadm control --reload-rules
    fi
    sudo cp -f "$BACKUP_PATH/auto-cpufreq.conf" /etc/auto-cpufreq.conf
    sudo systemctl enable --now auto-cpufreq

    # Crear punto de montaje para el HDD y regenerar initramfs
    sudo mkdir -p /mnt/HDD
    sudo mkinitcpio -P
    echo "✅ Restauración de /etc completada."
else
    echo "⚠️  No se encontró la carpeta $BACKUP_PATH. Saltando paso."
fi

# 9. Servicios (solo memavaild + paccache por decisión; sin ananicy/irqbalance)
sudo systemctl enable --now memavaild
sudo systemctl enable --now paccache.timer
sudo systemctl enable --now fstrim.timer
sudo systemctl disable cachyos-rate-mirrors.service 2>/dev/null || true
sudo systemctl disable systemd-networkd-wait-online.service 2>/dev/null || true
systemctl --user enable gnome-keyring-daemon.socket 2>/dev/null || true
systemctl --user enable hyprpolkitagent.service 2>/dev/null || true

echo "✨ ¡Hecho! Tu sistema Arch está listo. Reinicia para aplicar todos los cambios."
