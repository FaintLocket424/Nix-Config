{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.myHome.desktop.enable = lib.mkEnableOption "Desktop Environment";

  config = lib.mkIf config.myHome.desktop.enable {
    programs.chromium = {
      enable = true;
      package = pkgs.brave;
      nativeMessagingHosts = with pkgs; [
        gnome-browser-connector
        #        gnome-software
      ];
    };
  };
}
