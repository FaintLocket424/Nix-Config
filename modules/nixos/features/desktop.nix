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
      epiphany
      evince
      geary
      gedit
      gnome-music
      gnome-photos
      gnome-tour
      gnome-font-viewer
      gnome-maps
      gnome-weather
      gnome-characters
      gnome-calendar
      gnome-notes
      gnome-contacts
      gnome-text-editor
      simple-scan
      totem
      yelp
      cheese
      papers
    ];

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
      #      gnomeExtensions.user-themes
      #      gnomeExtensions.lockscreen-extension
    ];

    fonts.packages = with pkgs; [
      nerd-fonts.symbols-only
      corefonts
      vista-fonts
      google-fonts
    ];
  };
}
