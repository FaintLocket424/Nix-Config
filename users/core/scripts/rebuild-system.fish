#!/usr/bin/env fish

# Navigate to config directory
set CONFIG_DIR "$HOME/programming/Production/nixos-config"
cd $CONFIG_DIR || exit 1

# Handle arguments
set MODE switch
set EXTRA_FLAGS ""

for arg in $argv
    switch $arg
        case -c --check
            echo "Running in CHECK mode (dry-build)..."
            # dry-build: shows what would happen without applying
            # --offline: prevents downloading new binaries
            set MODE dry-build
            set EXTRA_FLAGS --offline
        case -o --offline
            echo "Running in OFFLINE mode"
            set EXTRA_FLAGS --offline
        case "*"
            echo "Unknown argument: $arg"
            exit 1
    end
end

echo "Formatting..."
nix fmt

# Essential: git add -A so Nix sees new/untracked files
git add -A

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

set REBUILD_CMD "sudo nixos-rebuild $MODE --flake .#$HOST $EXTRA_FLAGS"

echo --------------------------------------------------
echo "COMMAND: $REBUILD_CMD"
echo --------------------------------------------------

# Execute the command
eval $REBUILD_CMD
