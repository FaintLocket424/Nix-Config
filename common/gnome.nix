{
  pkgs,
  ...
}: {
  services.xserver = {
    # Enable the GNOME Desktop Environment
    desktopManager.gnome.enable = true;
  };

  # Optional: GNOME-specific packages/exclusions
  environment.gnome.excludePackages = [ pkgs.gnome-tour ];

  environment.systemPackages = with pkgs; [
    gnome-tweaks
    gnomeExtensions.user-themes
  ];
}