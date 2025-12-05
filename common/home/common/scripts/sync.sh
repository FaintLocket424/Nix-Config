#!/usr/bin/env fish

cd /home/"$(whoami)"/programming/Production/nixos-config || exit
git add ./*;
git commit -a -m "Automatic commit from update script";
git pull;
git push;
