#!/usr/bin/env bash
set -euo pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"

usage() {
    echo "Usage: $(basename "$0") <target...>"
    echo ""
    echo "Symlinks the yerba theme into the config directory for each target."
    echo ""
    echo "Targets:"
    echo "  helix     ~/.config/helix/themes/yerba.toml"
    echo "  ghostty   ~/.config/ghostty/themes/yerba"
    echo "  vscode    ~/.vscode/extensions/yerba-theme"
    echo "  all       install all of the above"
}

install_helix() {
    local dest="$HOME/.config/helix/themes"
    mkdir -p "$dest"

    if [ -L "$dest/yerba.toml" ]; then
        echo "helix: already installed (symlink exists)"
    elif [ -e "$dest/yerba.toml" ]; then
        echo "helix: $dest/yerba.toml already exists (not a symlink), skipping"
        return 1
    else
        ln -s "$SCRIPT_DIR/helix/yerba.toml" "$dest/yerba.toml"
        echo "helix: installed -> $dest/yerba.toml"
    fi
}

install_ghostty() {
    local dest="$HOME/.config/ghostty/themes"
    mkdir -p "$dest"

    if [ -L "$dest/yerba" ]; then
        echo "ghostty: already installed (symlink exists)"
    elif [ -e "$dest/yerba" ]; then
        echo "ghostty: $dest/yerba already exists (not a symlink), skipping"
        return 1
    else
        ln -s "$SCRIPT_DIR/ghostty/yerba" "$dest/yerba"
        echo "ghostty: installed -> $dest/yerba"
    fi
}

install_vscode() {
    local dest="$HOME/.vscode/extensions/yerba-theme"

    if [ -L "$dest" ]; then
        echo "vscode: already installed (symlink exists)"
    elif [ -e "$dest" ]; then
        echo "vscode: $dest already exists (not a symlink), skipping"
        return 1
    else
        ln -s "$SCRIPT_DIR/vscode" "$dest"
        echo "vscode: installed -> $dest"
    fi
}

if [[ $# -eq 0 || "${1:-}" == "-h" || "${1:-}" == "--help" ]]; then
    usage
    exit 0
fi

targets=("$@")
if [[ " ${targets[*]} " == *" all "* ]]; then
    targets=(helix ghostty vscode)
fi

for target in "${targets[@]}"; do
    case "$target" in
        helix)   install_helix ;;
        ghostty) install_ghostty ;;
        vscode)  install_vscode ;;
        *)       echo "unknown target: $target"; usage; exit 1 ;;
    esac
done
