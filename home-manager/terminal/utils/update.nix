{ pkgs }:
pkgs.writeShellApplication {
  name = "update";
  runtimeInputs = with pkgs; [
    git
    nh
  ];
  text = ''
    sudo test
    cd /home/matthew/development/nixos/ || exit
    nix flake update --flake .;
    git add ./*;
    git commit -a -m "Automatic commit from update script";
    git push;
    nh os switch /home/matthew/development/nixos;
  '';
}

