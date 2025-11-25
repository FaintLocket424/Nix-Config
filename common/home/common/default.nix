{
  config,
  pkgs,
  lib,
  inputs,
  hostname,
  ...
}: let
  username = config.home.username;
in {
  imports = [
    ./cli_utils.nix
  ];

  nixpkgs.config = {
    allowUnfree = true;
    system = pkgs.system;
  };

  fonts.fontconfig.enable = true;

  home = {
    keyboard = "uk";

    packages = with pkgs; [
      # System Management
      selectdefaultapplication
      bleachbit
      via
      pwvucontrol
      networkmanagerapplet

      brave # Web Browser
      xviewer # Image Viewer
      celluloid # Media Player
#      nemo-with-extensions # File Browser
      notepad-next # Text Editor
      zapzap # Whatsapp desktop app
      vesktop # Lightweight linux discord client
      geteduroam # Software for getting on eduroam
      parsec-bin # Remote Desktop
      gnome-calculator # Calculator

      # QT Fixes/packages
      kdePackages.qtwayland
      kdePackages.kwayland
      kdePackages.kservice
      libsForQt5.qtwayland


      # LibreOffice and Dictionaries
      libreoffice-qt6-fresh
      hunspell
      hunspellDicts.en_GB-ise
      aspell
      aspellDicts.en
    ];
  };

  services = {
    polkit-gnome.enable = true;

    playerctld.enable = true;

    udiskie = {
      enable = true;
#      settings = {
#        program_options = {
#          file_manager = "${pkgs.nemo-with-extensions}/bin/nemo";
#        };
#      };
    };

    blueman-applet.enable = true;

    gnome-keyring = {
      enable = true;
      components = [
        "pkcs11"
        "secrets"
        "ssh"
      ];
    };
  };

  programs = {
    home-manager.enable = true;
#    btop.enable = true;

    kitty = {
      enable = true;
      settings = {
        font_features = "JetBrainsMono Nerd Font Mono +calt";
        window_padding_width = 0;
        "modify_font cell_height" = "120%";
      };
    };
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.stateVersion = "25.05";
}