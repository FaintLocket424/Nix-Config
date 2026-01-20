{
  config,
  pkgs,
  lib,
  inputs,
  hostname,
  pkgs-unstable,
  ...
}:
{

  imports = [
    ./stylix.nix
    ./git.nix
    ./shell.nix
    ./syncthing.nix
  ];

  myHome = {
    gaming.enable = true;
    desktop.enable = true;
  };

  home = {
    username = "fran";
    homeDirectory = "/home/fran";

    packages = with pkgs; [

    ];
  };

  services = {

  };

  programs = {

  };
}
