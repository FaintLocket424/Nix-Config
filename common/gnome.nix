{
  pkgs,
  ...
}: {
  services.xserver = {
    # Enable the GNOME Desktop Environment
    desktopManager.gnome.enable = true;
  };

  services.gnome.games.enable = true;

#  services.gnome = {
#    games.enable = false;
#    core-apps.enable = false;
#    core-developer-tools.enable = false;
#  };

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
    simple-scan
    totem
    yelp
    cheese
  ];

  xdg.terminal-exec = {
    enable = true;
    settings = {
      default = [
        "kitty.desktop"
      ];
    };
  };

  environment.systemPackages = with pkgs; [
    gnome-tweaks
    gnomeExtensions.user-themes
  ];
}