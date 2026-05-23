#!/bin/bash
set -euo pipefail

UUID="0ca9f5bb-3aa4-4050-8e12-5b69d3296659"
echo "$UUID /mnt/storage ext4 defaults,nofail 0 0" | sudo tee -a /etc/fstab
sudo mkdir -p /mnt/storage
sudo mount /mnt/storage
