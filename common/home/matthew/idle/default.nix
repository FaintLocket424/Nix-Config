{pkgs, ...}: {
  imports = [
    ./hyprlock
  ];

  services.hypridle = {
    enable = true;
    settings = {
      general = {
        lock_cmd = "${pkgs.playerctl}/bin/playerctl -a pause; hyprlock";
        before_sleep_cmd = "loginctl lock-session";
        after_sleep_cmd = "~/.config/hypr/switch.sh";
        ignore_dbus_inhibit = false;
      };

      listener = [
        {
          timeout = 500;
          on-timeout = "systemctl suspend";
        }
      ];
    };
  };
}
