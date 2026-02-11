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
      ];
    };

    dconf.settings = {
      "org/gnome/desktop/default-applications/terminal" = {
        exec = "kitty";
        exec-arg = "";
      };

      "org/gnome/settings-daemon/plugins/media-keys" = {
        custom-keybindings = [
          "/org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0/"
        ];
      };

      "org/gnome/settings-daemon/plugins/media-keys/custom-keybindings/custom0" = {
        bindings = "<Super>Return";
        command = "kitty";
        name = "Kitty Terminal";
      };
    };

    home.packages = with pkgs; [
      nautilus-open-any-terminal
    ];

    dconf.settings."com/github/stunkymonkey/nautilus-open-any-terminal" = {
      terminal = "kitty";
      new-tab = true;
      flatpak = false;
    };
  };
}
