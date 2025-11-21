{
  pkgs,
  ...
}: {
  services.xserver = {
    # Enable the GNOME Desktop Environment
    desktopManager.gnome.enable = true;
  };

  services.gnome = {
    games.enable = false;
    core-apps.enable = false;
    core-developer-tools.enable = false;
  };

  environment.systemPackages = with pkgs; [
    gnome-tweaks
    gnomeExtensions.user-themes
  ];
}