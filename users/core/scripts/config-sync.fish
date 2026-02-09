#!/usr/bin/env fish

set CONFIG_DIR "$HOME/programming/Production/nixos-config"
cd $CONFIG_DIR || exit 1

git add -A
git commit -m "Automatic commit from update script"
git pull --rebase
git push
