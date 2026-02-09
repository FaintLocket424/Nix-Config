#!/usr/bin/env fish

# Navigate to config directory
set CONFIG_DIR "$HOME/programming/Production/nixos-config"
cd $CONFIG_DIR || exit 1

echo "Formatting and updating flake..."
nix fmt
nix flake update --flake .

# Stage changes
git add -A

# Only commit and push if there are changes to avoid "nothing to commit" errors
if not git diff --cached --quiet
    echo "Changes detected, committing..."
    git commit -m "Automatic commit from update script"

    echo "Syncing with remote..."
    # pull/push logic with "or true" to ensure the script doesn't crash on network issues
    git pull --rebase; or echo "Warning: git pull failed"
    git push; or echo "Warning: git push failed"
else
    echo "No changes to commit."
end