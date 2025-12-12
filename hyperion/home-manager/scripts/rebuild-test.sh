#!/usr/bin/env fish

cd /home/matthew/programming/Production/nixos-config || exit
#nix flake update --flake .;
#git add ./*;
#git commit -a -m "Automatic commit from update script";
#git push;
sudo nixos-rebuild dry-run --flake .#hyperion;
