{ lib, config, pkgs, ... }:

let
  cfg = config.myHome.desktop;
in
{
  imports = [
    ./gnome.nix
    ./hyprland.nix
  ];

  options.myHome.desktop = {
    environment = lib.mkOption {
      type = lib.types.enum [ "gnome" "hyprland" "none" ];
      default = "none";
      description = "The desktop environment to enable for this user.";
    };
  };

  config = lib.mkIf (cfg.environment != "none") {
    # --- SHARED GUI SETTINGS (Brave, Kitty, etc) ---
    programs.chromium = {
      enable = true;
      package = pkgs.brave;
    };

    programs.kitty.enable = true;

    home.packages = with pkgs; [
      celluloid
      xviewer
    ];
  };
}