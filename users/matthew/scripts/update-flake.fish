# Determine the configuration directory
if set -q FLAKE; and test -d "$FLAKE"
  set CONFIG_DIR "$FLAKE"
else if test -f "$PWD/flake.nix"
  set CONFIG_DIR "$PWD"
else
  echo "❌ Error: Could not locate your NixOS configuration."
  echo "Please either navigate to your config folder or set the \$FLAKE environment variable."
  exit 1
end

if not cd $CONFIG_DIR
  echo "❌ Error: Could not navigate to $CONFIG_DIR"
  exit 1
end

echo "🎨 Formatting flake..."
nix fmt

echo "⬆️ Updating flake inputs (fetching latest packages)..."
nix flake update

# Stage changes (specifically catching the updated flake.lock and formatted files)
git add -A

# Only commit and push if there are changes to avoid "nothing to commit" errors
if not git diff --cached --quiet
  echo "📦 Changes detected in flake.lock, committing..."

  # Using a conventional commit message for clean git logs
  git commit -m "chore: update flake inputs"

  echo "🔄 Syncing with remote..."
  # pull/push logic with "or" to ensure the script doesn't crash on network issues
  git pull --rebase; or echo "⚠️ Warning: git pull failed"
  git push; or echo "⚠️ Warning: git push failed"

  echo "✅ Update complete! Run 'rebuild-system' to apply the new packages."
else
  echo "✅ Flake is already up to date. No changes to commit."
end
