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
  ];

  myHome = {
    desktop.environment = "gnome";
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
