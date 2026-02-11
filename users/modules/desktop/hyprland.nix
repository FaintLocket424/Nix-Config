{ config, lib, pkgs, ... }:

{
  options.myHome.desktop.hyprland.enable = lib.mkEnableOption "Hyprland User Config";

  config = lib.mkIf config.myHome.desktop.hyprland.enable {
    wayland.windowManager.hyprland = {
      enable = true;
      settings = {
        "$mod" = "SUPER";
        bind = [
          "$mod, Return, exec, kitty"
        ];
      };
    };

    home.packages = with pkgs; [
      waybar
      rofi-wayland
      dunst
    ];
  };
}