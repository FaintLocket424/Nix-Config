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

    services = {
      desktopManager.gnome.enable = true;

      gnome = {
        gnome-browser-connector.enable = true;
        core-apps.enable = false;
        core-developer-tools.enable = false;
        games.enable = false;
      };
    };

    environment.gnome.excludePackages = with pkgs; [
      gnome-tour
      gnome-user-docs
    ];

    environment.systemPackages = with pkgs; [
      gnome-tweaks
      nautilus
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
