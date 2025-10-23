{ pkgs }:
pkgs.writeShellApplication {
  name = "update";
  runtimeInputs = with pkgs; [
    git
    nh
  ];
  text = ''
    cd /home/matthew/programming/Production/nixos-config || exit
    nix flake update --flake .;
    git add ./*;
    git commit -a -m "Automatic commit from update script";
    git push;
    nh os switch /home/matthew/programming/Production/nixos-config;
  '';
}

