{ lib, config, pkgs, ... }:

{
  config = lib.mkIf (config.myHome.desktop.environment == "hyprland") {
    wayland.windowManager.hyprland.enable = true;

    # Shared Hyprland environment variables
    home.sessionVariables = {
      QT_QPA_PLATFORM = "wayland";
      SDL_VIDEODRIVER = "wayland";
      XDG_CURRENT_DESKTOP = "Hyprland";
    };

    home.packages = with pkgs; [
      waybar
      rofi-wayland
      swww # Wallpaper daemon
      grimblast # Screenshots
    ];
  };
}