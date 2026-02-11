{ lib, config, pkgs, ... }:

let
  cfg = config.myHome.desktop;
in
{
  config = lib.mkIf (cfg.environment == "hyprland") {
    # Matthew's specific Hyprland Config
    wayland.windowManager.hyprland.settings = {
      "$mod" = "SUPER";
      bind = [
        "$mod, F, exec, firefox"
        "$mod, M, exit,"
      ];
      decoration = {
        rounding = 10;
      };
    };
  };
}