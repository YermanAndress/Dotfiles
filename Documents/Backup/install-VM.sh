#!/bin/bash

DOTFILES_REPO="https://github.com/YermanAndress/Dotfiles.git"
SCRIPT_DIR="$(cd -- "$(dirname -- "${BASH_SOURCE[0]}")" &>/dev/null && pwd)"
PACKAGES="linux-headers zsh bat eza ripgrep sddm thunar micro ttf-firacode-nerd ttf-nerd-fonts-symbols nwg-look code zram-generator pacman-contrib refind qemu-guest-agent virtualbox-guest-utils"
AUR_PACKAGES="pokeget helium-browser-bin"

echo "🖥️ Iniciando instalación en Máquina Virtual..."

WORK_DIR=$(mktemp -d)

# 0. Instalar CachyOs Mirros
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

#  Instalar sddm-theme-tokyo-night
git clone https://github.com/rototrash/tokyo-night-sddm.git "$WORK_DIR/sddm-theme"
sudo mkdir -p /usr/share/sddm/themes
sudo rm -rf /usr/share/sddm/themes/tokyo-night-sddm
sudo mv "$WORK_DIR/sddm-theme" /usr/share/sddm/themes/tokyo-night-sddm
echo -e "[Theme]\nCurrent=tokyo-night-sddm" | sudo tee /etc/sddm.conf

# 8. Restaurar archivos de sistema (Adaptado a VM)
# NOTA: no se restaura fstab (UUIDs distintos) ni el mkinitcpio del host
# (amdgpu/btrfs no aplican en VM); la VM usa su mkinitcpio stock.
echo "🔧 Restaurando configuraciones..."
SYSTEM_BACKUP_PATH="$SCRIPT_DIR/SystemBackups/etc"

git clone --bare "$DOTFILES_REPO" "$HOME/.cfg"
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME checkout -f

if [ -d "$SYSTEM_BACKUP_PATH" ]; then
    sudo cp -f "$SYSTEM_BACKUP_PATH/pacman.conf" /etc/pacman.conf

    sudo mkinitcpio -P
    echo "✅ Restauración parcial completada."
else
    echo "⚠️ No se encontró SystemBackups."
fi

# 9. Optimizaciones adaptadas del host
echo "⚡ Aplicando optimizaciones..."
sudo tee /etc/sysctl.d/99-vm.conf << 'EOF'
vm.swappiness=100
vm.vfs_cache_pressure=75
vm.watermark_scale_factor=125
vm.dirty_ratio=10
vm.dirty_background_ratio=5
EOF
sudo tee /etc/sysctl.d/99-network-bbr.conf << 'EOF'
net.core.default_qdisc = fq
net.ipv4.tcp_congestion_control = bbr
net.ipv4.tcp_fastopen = 3
net.ipv4.tcp_slow_start_after_idle = 0
net.core.netdev_max_backlog = 16384
EOF
sudo sysctl --system
sudo tee /etc/systemd/zram-generator.conf << 'EOF'
[zram0]
zram-size = ram / 2
compression-algorithm = lz4
EOF
sudo mkdir -p /etc/systemd/journald.conf.d
printf '[Journal]\nSystemMaxUse=200M\nSystemKeepFree=500M\n' | sudo tee /etc/systemd/journald.conf.d/00-limit.conf
sudo systemctl restart systemd-journald
sudo systemctl enable --now paccache.timer
sudo systemctl enable --now fstrim.timer
# cmdline para rEFInd auto-scan (sin mitigations=off: en VM prima la seguridad)
sudo mkdir -p /etc/kernel
echo "quiet zswap.enabled=0 transparent_hugepage=madvise" | sudo tee /etc/kernel/cmdline

# 10. rEFInd (único bootloader, auto-scan sin UUIDs hardcodeados)
echo "🖥️ Instalando rEFInd..."
sudo refind-install || echo "⚠️ refind-install falló, revisa tu ESP"
sudo sed -i -E "s/^timeout .*/timeout 5/" /boot/EFI/refind/refind.conf 2>/dev/null || true

# 11. Guest agents (QEMU + VirtualBox, se habilita el que detecte)
VIRT="$(systemd-detect-virt 2>/dev/null || echo none)"
if [ "$VIRT" = "kvm" ] || [ "$VIRT" = "qemu" ]; then
    sudo systemctl enable --now qemu-guest-agent
elif [ "$VIRT" = "oracle" ]; then
    sudo systemctl enable --now vboxservice
else
    echo "⚠️ Hipervisor no detectado ($VIRT), habilita el agent a mano."
fi

rm -rf "$WORK_DIR"

# Alias permanente (solo si falta)
/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME config --local status.showUntrackedFiles no
grep -q "alias config=" ~/.zshrc || echo "alias config='/usr/bin/git --git-dir=\$HOME/.cfg/ --work-tree=\$HOME'" >> ~/.zshrc

echo "✨ ¡Hecho! VM lista. Reinicia para activar los drivers de invitado."
