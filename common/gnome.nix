{
  pkgs,
  ...
}: {
  services.xserver = {
    # Enable the GNOME Desktop Environment
    desktopManager.gnome.enable = true;
  };

#  services.gnome = {
#    games.enable = false;
#    core-apps.enable = false;
#    core-developer-tools.enable = false;
#  };

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