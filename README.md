# HyprDots

Hyprland dotfiles by JuicyGoose007.

## Prerequisites

- Arch Linux (or Arch-based distro)
- `paru` installed (AUR helper)

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

## Step 4: Mount games drive (Optional)

```bash
./scripts/fstab.sh
```

Mounts a dedicated ext4 drive to `/mnt/storage` for Steam game libraries.
