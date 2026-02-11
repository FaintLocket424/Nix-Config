{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.myFeatures.desktop.enable = lib.mkEnableOption "Desktop Environment and Audio";

  config = lib.mkIf config.myFeatures.desktop.enable {
    services = {
      xserver = {
        enable = true;
        xkb.layout = "gb";
        excludePackages = [ pkgs.xterm ];
      };

      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
      flatpak.enable = true;
      udisks2.enable = true;
      automatic-timezoned.enable = true;

      # Audio
      pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
        jack.enable = true;
      };

      gnome = {
        gnome-browser-connector.enable = true;
      };
    };

    environment.gnome.excludePackages = with pkgs; [
      gnome-tour
      gnome-connections

      epiphany
      geary
      gnome-contacts
      gnome-maps
      gnome-weather

      totem
      gnome-music
      gnome-photos
      loupe
      snapshot

      gnome-calculator
      gnome-calendar
      gnome-clocks
      simple-scan

      gnome-system-monitor
      gnome-disk-utility
      baebab
      gnome-logs
      gnome-font-viewer
      gnome-characters
      yelp

      gnome-software

      gnome-temrinal
      gnome-console

      evince
      gedit
      gnome-notes
      gnome-text-editor
      cheese
      papers
    ];

    programs.nautilus-open-any-terminal.enable = true;

    xdg.terminal-exec = {
      enable = true;
      settings.default = [ "kitty.desktop" ];
    };

    xdg.portal = {
      enable = true;
      xdgOpenUsePortal = true;

      extraPortals = with pkgs; [
        xdg-desktop-portal-gnome
        xdg-desktop-portal-gtk
      ];

      config = {
        common.default = [
          "gnome"
          "gtk"
        ];
        gnome.default = [
          "gnome"
          "gtk"
        ];
      };
    };

    environment.systemPackages = with pkgs; [
      gnome-tweaks
    ];

    fonts.packages = with pkgs; [
      nerd-fonts.symbols-only
      corefonts
      vista-fonts
      google-fonts
    ];
  };
}
