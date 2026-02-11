{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.myFeatures.desktop.gnome.enable = lib.mkEnableOption "GNOME Desktop Environment";

  config = lib.mkIf config.myFeatures.desktop.gnome.enable {
    # 1. Enable Common Desktop features automatically
    myFeatures.desktop.common.enable = true;

    # 2. Display Manager & Desktop Manager
    services.xserver = {
      displayManager.gdm.enable = true;
      desktopManager.gnome.enable = true;
    };

    services.gnome.gnome-browser-connector.enable = true;

    # 3. Cleanup / Debloat
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
      baobab
      gnome-logs
      gnome-font-viewer
      gnome-characters
      yelp
      gnome-software
      gnome-terminal
      gnome-console
      evince
      gedit
      gnome-notes
      gnome-text-editor
      cheese
      papers
    ];

    # 4. GNOME Specific Packages & Tweaks
    environment.systemPackages = with pkgs; [
      gnome-tweaks
    ];

    programs.nautilus-open-any-terminal.enable = true;

    # 5. GNOME Portals
    # Hyprland would use xdg-desktop-portal-hyprland instead
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
  };
}
