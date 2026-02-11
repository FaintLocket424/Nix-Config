{
  config,
  pkgs,
  lib,
  inputs,
  hostname,
  ...
}:
{
  imports = [
    ./cli_utils.nix
  ];

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

      xviewer # Image Viewer
      celluloid # Media Player
      notepad-next # Text Editor
      vesktop # Lightweight linux discord client
      geteduroam # Software for getting on eduroam
      parsec-bin # Remote Desktop
      qalculate # Calculator
      btop # Process Monitor

      # QT Fixes/packages
      kdePackages.qtwayland
      kdePackages.kwayland
      kdePackages.kservice
      libsForQt5.qtwayland

      # LibreOffice and Dictionaries
      #      libreoffice-qt6-fresh
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
    };

    blueman-applet.enable = true;
  };

  programs = {
    home-manager.enable = true;
  };

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  home.stateVersion = "25.05";
}
