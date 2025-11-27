#!/usr/bin/env fish

cd /home/"$(whoami)"/programming/Production/nixos-config || exit
nix flake update --flake .;
sudo nixos-rebuild switch --flake .#"$(hostname)";
