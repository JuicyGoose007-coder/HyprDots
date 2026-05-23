#!/bin/bash
set -euo pipefail

REPO="https://github.com/JuicyGoose007-coder/HyprDots.git"
DEST="${DEST:-$HOME/HyprDots}"

mkdir -p ~/.config ~/Pictures

if [ -d "$DEST" ]; then
  echo ">> $DEST already exists, pulling latest..."
  git -C "$DEST" pull
else
  echo ">> Cloning dotfiles..."
  git clone "$REPO" "$DEST"
fi

echo ">> Unpacking dotfiles..."
cp "$DEST/zshrc" ~/.zshrc

for dir in starship fastfetch ghostty nvim yazi waybar tmux rofi wlogout hypr swaync lazygit wallust; do
    if [ -d "$DEST/$dir" ]; then
        cp -rfT "$DEST/$dir" ~/.config/$dir
    else 
        echo ">> Warning: $DEST/$dir not found, skipping..."
    fi
done

if [ -d "$DEST/wallpapers" ]; then
    cp -rfT "$DEST/wallpapers" ~/Pictures/wallpapers
fi
    
cp -rfT "$DEST/scripts" ~/scripts

echo ">> Applying SDDM theme and config..."
bash "$DEST/scripts/sddm.sh"

echo ">> Installing packages..."
bash "$DEST/scripts/pkgs.sh" || echo ">> Warning: some packages failed to install, continuing..."

sed -i "s|/var/cache/hyprpm/juicygoose007|/var/cache/hyprpm/$USER|g" ~/.config/hypr/hyprland.lua
hyprpm add https://github.com/hyprland-community/hymission || true
hyprpm enable hymission || true

echo ">> Done! Dotfiles installed."
