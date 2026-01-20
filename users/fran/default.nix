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
