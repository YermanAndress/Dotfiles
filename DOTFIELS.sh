#!/bin/bash

# --- Configuración ---
DOTFILES_REPO="https://github.com/YermanAndress/TU_REPO.git"
PACKAGES="linux-headers zsh bat eza ripgrep thunar base-devel git ttf-firacode-nerd ttf-nerd-fonts-symbols-common nwg-look rsync"
AUR_PACKAGES="paru-bin zen-browser-bin dank-material-shell plymouth-theme-cuts-alt-git pear-desktop pokeget rtl8821ce-dkms-git sddm-theme-tokyo-night visual-studio-code-bin"

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
# Usamos el punto para asegurar que rsync mueva archivos ocultos (.config, .zshrc, etc)
rsync --recursive -vhP $HOME/tmp_dotfiles/ $HOME/
rm -rf $HOME/tmp_dotfiles

# 7. Configurar Plymouth
echo "🎬 Configurando tema de Plymouth..."
sudo plymouth-set-default-theme -R cuts-alt



# Limpieza final de temporales
rm -rf "$WORK_DIR"

# Configurar el alias de forma permanente para esta sesión
alias config='/usr/bin/git --git-dir=$HOME/.cfg/ --work-tree=$HOME'
config config --local status.showUntrackedFiles no

echo "✨ ¡Hecho! Tu sistema Arch está listo. Reinicia para aplicar los cambios de Grub y Shell."
