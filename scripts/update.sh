#!/usr/bin/bash
#################
# JuicyGoose007 #
#################

set -euo pipefail

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  :: Updating system packages (paru -Syu)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
paru -Syu
echo "  :: done!"
echo ""

echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
echo "  :: Updating Hyprland plugins (hyprpm)"
echo "━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━━"
hyprpm update && hyprpm reload
echo "  :: done!"

#################
# End of Script #
#################
