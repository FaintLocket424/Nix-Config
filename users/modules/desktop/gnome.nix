{ pkgs, lib, osConfig, ... }:

{
  config = lib.mkIf osConfig.myFeatures.desktop.gnome.enable {

    # 1. GNOME Browser Connector (User side)
    programs.chromium.nativeMessagingHosts = [
      pkgs.gnome-browser-connector
    ];

    # 2. Dconf Settings (Kitty as default, shortcuts)
    dconf.settings = {
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

    # 3. Required packages for extensions
    home.packages = with pkgs; [
      nautilus-open-any-terminal
    ];
  };
}