{
  pkgs,
  lib,
  ...
}:
{
  programs.waybar = {
    enable = true;
    systemd = {
      enable = true;
      target = "graphical-session.target";
    };
    style = lib.mkAfter ''
      * {
        font-family: "Symbols Nerd Font";
      }
    '';
    settings = {
      mainBar = {
        layer = "top";
        modules-center = [ "clock" ];
        modules-right = [
          "pulseaudio"
          "backlight"
          "battery"
        ];
        modules-left = [
          "custom/space"
          "tray"
        ];
        spacing = 2;
        "custom/space" = {
          format = " ";
          tooltip = false;
        };
        tray = {
          spacing = 4;
        };
        backlight = {
          format = "{icon}";
          format-icons = [
            "󰃞 "
            "󰃟 "
            "󰃝 "
            "󰃠 "
          ];
          tooltip-format = "{percent}%";
        };
        battery = {
          format = "{icon}";
          format-icons = {
            charging = [
              "󰢟 "
              "󰢜 "
              "󰂆 "
              "󰂇 "
              "󰂈 "
              "󰢝 "
              "󰂉 "
              "󰢞 "
              "󰂊 "
              "󰂋 "
              "󰂅 "
            ];
            default = [
              "󰂎 "
              "󰁺 "
              "󰁻 "
              "󰁼 "
              "󰁽 "
              "󰁾 "
              "󰁿 "
              "󰂀 "
              "󰂁 "
              "󰂂 "
              "󰁹 "
            ];
          };
          tooltip-format = "{capacity}%\n{timeTo}";
        };
        clock = {
          tooltip-format = "{:%a, %d %b %Y}";
        };
        pulseaudio = {
          format = "{icon}";
          format-muted = "󰝟 ";
          format-icons = [
            "󰕿 "
            "󰖀 "
            "󰕾 "
          ];
          on-click = "${pkgs.pwvucontrol}/bin/pwvucontrol";
          tooltip-format = "{volume}%";
        };
      };
    };
  };
}
