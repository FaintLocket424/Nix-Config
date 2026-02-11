{
  pkgs,
  lib,
  config,
  ...
}:

{
  options.myHome.desktop.common.enable = lib.mkEnableOption "Desktop User Config";

  # Only enable this if the SYSTEM has common desktop features enabled
  config = lib.mkIf config.myHome.desktop.common.enable {

    programs.chromium = {
      enable = true;
      package = pkgs.brave;
    };

    programs.kitty.enable = true;

    # You can move generic GUI tools from your 'core' module to here
    # if you only want them when a desktop is actually present.
    home.packages = with pkgs; [
      celluloid
      xviewer
    ];
  };
}
