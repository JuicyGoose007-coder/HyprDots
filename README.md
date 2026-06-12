# HyprDots

Hyprland dotfiles by JuicyGoose007.

## Prerequisites

- CachyOS (or Arch-based distro)

## Step 1: Clone the repository

```bash
git clone https://github.com/JuicyGoose007-coder/HyprDots.git
cd HyprDots
```

## Step 2: Make scripts executable

```bash
chmod +x scripts/*.sh
```

## Step 3: Install dotfiles and packages

```bash
./scripts/install.sh
```

Deploys configs to `~/.config`, applies the SDDM theme, and installs all required packages via `paru`.

## Step 4: Set Zsh as default shell (Optional)

```bash
chsh -s /usr/bin/zsh
```

Log out and back in to apply. Only needed if you want the custom `.zshrc`.

## Step 5: Mount games drive (Optional)

```bash
./scripts/fstab.sh
```

Mounts a dedicated ext4 drive to `/mnt/storage` for Steam game libraries.

## Troubleshooting

### GTK theme not applied

If GTK apps don't match the dark theme, run:

```bash
gsettings set org.gnome.desktop.interface color-scheme 'prefer-dark'
```
