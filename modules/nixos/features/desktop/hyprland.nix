{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.myFeatures.desktop.hyprland.enable = lib.mkEnableOption "Hyprland Desktop Environment";

  config = lib.mkIf config.myFeatures.desktop.hyprland.enable {
    myFeatures.desktop.common.enable = true;

    programs.hyprland.enable = true;

    environment.systemPackages = with pkgs; [

    ];

  };
}
