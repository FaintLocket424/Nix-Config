# Determine the configuration directory
if set -q FLAKE; and test -d "$FLAKE"
    set CONFIG_DIR "$FLAKE"
else if test -f "$PWD/flake.nix"
    set CONFIG_DIR "$PWD"
else
    echo "❌ Error: Could not locate your NixOS configuration."
    echo "Please either navigate to your config folder (where flake.nix is) or set the \$FLAKE environment variable."
    exit 1
end

# Ensure the directory exists before proceeding
if not cd $CONFIG_DIR
    echo "❌ Error: Could not navigate to $CONFIG_DIR"
    exit 1
end

# Default states
set NH_CMD switch
set NH_ARGS
set SKIP_GIT 0

# Handle arguments
for arg in $argv
    switch $arg
        case -c --check
            echo "🔍 Running in CHECK mode (build only, no switch)..."
            set NH_CMD build
            set SKIP_GIT 1
        case -o --offline
            echo "🔌 Running in OFFLINE mode..."
            set -a NH_ARGS --offline
            set SKIP_GIT 1
        case "*"
            echo "❌ Unknown argument: $arg"
            exit 1
    end
end

# Stage files so `nix fmt` and the flake can see new files
git add .

echo "🎨 Formatting..."
nix fmt

# Check for changes and sync
if not git diff --cached --quiet
    echo "📦 Changes detected, committing..."
    git commit -m "Automatic commit from update script"

    if test $SKIP_GIT -eq 1
        echo "⏭️  Offline/Check mode: skipping git pull & push"
    else
        echo "🔄 Syncing with remote..."
        git pull; or echo "⚠️ Warning: git pull failed"
        git push; or echo "⚠️ Warning: git push failed"
    end
else
    echo "✅ No changes to commit."
end

# Execute the rebuild using Nix Helper (nh)
echo "🚀 Rebuilding NixOS with flakes..."
nh os $NH_CMD . $NH_ARGS

# Post-build actions
if test $status -eq 0
    echo "✅ Rebuild successful!"

    # Only clean and fetch if we actually switched the live system
    if test "$NH_CMD" = "switch"
        echo "🧹 Cleaning up old generations..."
        nh clean all --keep 5

        echo "🎉 System is up to date:"
        fastfetch
    end
else
    echo "❌ Rebuild failed. Check the logs above."
    exit 1
end
