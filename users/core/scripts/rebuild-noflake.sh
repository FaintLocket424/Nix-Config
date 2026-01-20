#!/usr/bin/env fish

cd /home/"$(whoami)"/programming/Production/nixos-config || exit
#nix flake update --flake .;
git add ./*;
git commit -a -m "Automatic commit from update script";
git pull;
git push;
sudo nixos-rebuild switch --flake .#"$(hostname)";
