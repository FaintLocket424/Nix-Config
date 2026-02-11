{ lib, config, pkgs, ... }:

{
  config = lib.mkIf (config.myHome.desktop.environment == "gnome") {
    programs.chromium.nativeMessagingHosts = [
      pkgs.gnome-browser-connector
    ];

    dconf.settings = {
      "org/gnome/desktop/interface" = {
        color-scheme = "prefer-dark";
        enable-hot-corners = false;
      };
      "org/gnome/desktop/wm/preferences" = {
        button-layout = "appmenu:minimize,maximize,close";
      };

      "org/gnome/desktop/default-applications/terminal" = {
        exec = "kitty";
        exec-arg = "";
      };

      # Custom Keybindings
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

      # Nautilus Open in Terminal (User Preferences)
      "com/github/stunkymonkey/nautilus-open-any-terminal" = {
        terminal = "kitty";
        new-tab = true;
        flatpak = false;
      };
    };

    home.packages = with pkgs; [
      nautilus-open-any-terminal
      gnome-tweaks
      gnomeExtensions.appindicator
      gnomeExtensions.blur-my-shell
    ];
  };
}
