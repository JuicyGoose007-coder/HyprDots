#!/bin/bash
# Strip hex colors:         #2B1512 → #COLOR
# Strip CSS rgba:           rgba(43, 21, 18, 0.9) → rgba(COLOR)
# Strip hex-style rgba:     rgba(dc3e07ff) → rgba(COLOR)
# Strip RGB triples:        43, 21, 18 → COLOR_RGB  (in --*-rgb context)

sed -E \
    -e 's/#[0-9a-fA-F]{6,8}/COLOR/g' \
    -e 's/rgba\([0-9]+, ?[0-9]+, ?[0-9]+, ?[0-9.]+\)/rgba(COLOR)/g' \
    -e 's/rgba\([0-9a-fA-F]+\)/rgba(COLOR)/g' \
    -e 's/(--[a-zA-Z0-9_-]+-rgb: )[0-9]+, ?[0-9]+, ?[0-9]+;/\1COLOR_RGB;/g'
