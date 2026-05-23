#!/bin/bash
set -euo pipefail

SCRIPT_DIR="$(dirname "$(readlink -f "$0")")"
REPO_ROOT="$(dirname "$SCRIPT_DIR")"

DEST="$REPO_ROOT" exec bash "$SCRIPT_DIR/install.sh"
