{ config, pkgs, inputs, ... }:
let
  pkgs-unstable = import inputs.nixpkgs-unstable {
    inherit (pkgs) system;
    config = config.nixpkgs.config;
  };
in
{
  home.packages = with pkgs; [
    # Minecraft
    prismlauncher # Minecraft Launcher
    modrinth-app # Modded Minecraft Launcher
    mcaselector # Tool for filtering chunks in Minecraft worlds
    worldpainter # Minecraft world creator

    # Utils
    evtest
    evtest-qt
    antimicrox
    jstest-gtk
    xwiimote
    mangohud
    goverlay
    heroic
  ]
  ++ (with pkgs-unstable; [
    lutris

    wineWow64Packages.stable

    (bottles.override { removeWarningPopup = true; })
  ]);
}
