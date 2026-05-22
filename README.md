# HyprDots

Hyprland dotfiles by JuicyGoose007.

## Installation

```bash
git clone https://github.com/JuicyGoose007-coder/HyprDots.git
cd HyprDots
bash scripts/install.sh
```

This clones the repo, deploys configs to `~/.config`, applies the SDDM theme, and installs all packages via `paru`.

### Optional — Games drive

```bash
bash scripts/fstab.sh
```

Mounts a dedicated ext4 drive to `/mnt/storage` for Steam game libraries.
