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
    ./shell.nix
    ./syncthing.nix
    ./gnome.nix
    ./hyprland.nix
  ];

  myHome = {
    desktop.environment = "gnome";
    development.enable = true;
    gaming.enable = true;
  };

  home = {
    username = "matthew";
    homeDirectory = "/home/matthew";

    packages = with pkgs; [
      photoflare # Image Editor like Paint.NET
      popsicle # ISO Writer
      bambu-studio # 3D Printing Slicer for Bambu Labs Printers
      freecad # FOSS 3D Modelling Software
      obs-studio # FOSS for Screen Recording and Streaming
      obsidian # FOSS for Markdown Note-taking
      scrcpy # Android screen mirroring
      #      zotero # Research reference manager
    ];
  };

  programs = {
    git = {
      enable = true;
      settings.user = {
        name = "FaintLocket424";
        email = "github.grill135@passinbox.com";
      };
    };

    fuzzel = {
      enable = true;
      settings = {
        main = {
          terminal = "${pkgs.kitty}/bin/kitty";
          width = 60;
          horizontal-pad = 8;
          vertical-pad = 4;
          icon-theme = "Papirus-Dark";
        };
        border.radius = 2;
      };
    };
  };
}
