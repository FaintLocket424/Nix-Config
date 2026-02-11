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
    gaming.enable = true;
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
