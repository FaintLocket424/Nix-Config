#!/usr/bin/env fish

cd /home/"$(whoami)"/programming/Production/nixos-config || exit
nix fmt;
nix flake update --flake .;
git add ./* || true;
git commit -a -m "Automatic commit from update script" || true;
git pull || true;
git push || true;
sudo nixos-rebuild switch --flake .#"$(hostname)";
