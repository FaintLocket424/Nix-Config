#!/usr/bin/env fish

cd /home/matthew/programming/Production/nixos-config || exit
git add ./*;
git commit -a -m "Automatic commit from update script";
git pull
git push;
nix flake update --flake .;
sudo nixos-rebuild switch --flake .#"$(hostname)";
