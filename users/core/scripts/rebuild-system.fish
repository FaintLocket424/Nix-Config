#!/usr/bin/env fish

set CONFIG_DIR "$HOME/programming/Production/nixos-config"
cd $CONFIG_DIR || exit 1

# Handle arguments
set MODE "switch"
set OFFLINE_FLAG ""
set HOST (hostname)
set OFFLINE 0

for arg in $argv
    switch $arg
        case -c --check
            echo "Running in CHECK mode (dry-build)..."
            set MODE "dry-build"
            set OFFLINE_FLAG "--offline"
        case -o --offline
            echo "Running in OFFLINE mode"
            set OFFLINE_FLAG "--offline"
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

set REBUILD_CMD "sudo nixos-rebuild $MODE --flake .#$HOST $OFFLINE_FLAG"

echo --------------------------------------------------
echo "COMMAND: $REBUILD_CMD"
echo --------------------------------------------------

# Execute the command
eval $REBUILD_CMD
