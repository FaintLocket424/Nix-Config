#!/usr/bin/env fish

# Navigate to config directory
set CONFIG_DIR "$HOME/programming/Production/nixos-config"
cd $CONFIG_DIR || exit 1

# Handle arguments
set MODE "switch"
set EXTRA_FLAGS ""
set HOST (hostname)
set OFFLINE 0

for arg in $argv
    switch $arg
        case -c --check
            echo "Running in CHECK mode (dry-build)..."
            set MODE "dry-build"
            set EXTRA_FLAGS "--offline"
        case -o --offline
            echo "Running in OFFLINE mode"
            set EXTRA_FLAGS "--offline"
            set OFFLINE 1
        case "*"
            echo "Unknown argument: $arg"
            exit 1
    end
end

git add -A

echo "Formatting..."
nix fmt

if not git diff --cached --quiet
    echo "Changes detected, committing..."
    git commit -m "Automatic commit from update script"

    if test $OFFLINE -eq 0
      echo "Offline mode, skipping git pull & push"
    else
      echo "Syncing with remote..."
      git pull --rebase; or echo "Warning: git pull failed"
      git push; or echo "Warning: git push failed"
    end

else
    echo "No changes to commit."
end

set REBUILD_CMD "sudo nixos-rebuild $MODE --flake .#$HOST $EXTRA_FLAGS"

echo --------------------------------------------------
echo "COMMAND: $REBUILD_CMD"
echo --------------------------------------------------

# Execute the command
eval $REBUILD_CMD
