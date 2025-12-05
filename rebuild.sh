#!/usr/bin/env bash
set -e

NIXOS_CONFIG_DIR="/etc/nixos"
DATE=$(date +%Y-%m-%d-%H:%M)
HOSTNAME=$(hostname)

cd "$NIXOS_CONFIG_DIR" || exit

error_handler() {
    local error_message="$1"
    echo "Error: $error_message"
}
if [[ -n $(git status --porcelain) ]]; then
    echo "Commiting local changes first..."

    git add . || error_handler "Git probably broke somehow"
    
    if [[ -n "$1" ]]; then 
        COMMIT_MSG="$1: $DATE"
    else
        COMMIT_MSG="Rebuild $HOSTNAME: $DATE"
    fi

    git commit -m "$COMMIT_MSG" || error_handler "Git Commit failed"
else
    echo "No local changes to commit."
fi

echo "Pulling latest changes from GitHub"

git pull --rebase origin main || error_handler "Git pull failed (possible conflict)"

echo "Pushing to GitHub"
git push origin main || error_handler "Git Push Failed"

echo "Rebuilding for machine: $HOSTNAME"
sudo nixos-rebuild switch --flake ".#$HOSTNAME" || error_handler "NixOS rebuild failed"


