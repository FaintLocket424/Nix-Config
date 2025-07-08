{
  inputs,
  pkgs,
  lib,
  ...
}: {
  programs.hyprlock = {
    enable = true;

    settings = {
      # BACKGROUND
      background = {
        monitor = "";
        path = lib.mkForce "screenshot";
        blur_passes = 3;
        contrast = 1;
        brightness = 0.5;
        vibrancy = 0.2;
        vibrancy_darkness = 0.2;
      };

      # GENERAL
      general = {
        no_fade_in = true;
        no_fade_out = true;
        hide_cursor = false;
        grace = 0;
        disable_loading_bar = true;
      };

      # INPUT FIELD
      input-field = {
        monitor = "";
        size = "250, 60";
        outline_thickness = 2;
        dots_size = 0.2;
        dots_spacing = 0.35;
        dots_center = true;
#        outer_color = "rgba(0, 0, 0, 0)";
#        inner_color = "rgba(0, 0, 0, 0.2)";
#        font_color = "$foregound";
        fade_on_empty = true;
        rounding = -1;
#        check_color = "rgb(204, 136, 34)";
        placeholder_text = "<i><span foreground=\"##cdd6f4\">Input Password...</span></i>";
        hide_input = false;
        position = "0, -200";
        halign = "center";
        valign = "center";
      };

      label = [
        # DATE
        {
          monitor = "";
          text = "cmd[update:1000] date + %A, %B %d";
          color = "rgba(242, 243, 244, 0.75";
          font_size = 22;
          font_family = "JetBrains Mono";
          position = "0, 300";
          halign = "center";
          valign = "center";
        }

        # TIME
        {
          monitor = "";
          text = "cmd[update:1000] date +\"%-I:%M%p\"";
          color = "rgba(242, 243, 244, 0.75";
          font_size = 95;
          font_family = "JetBrains Mono Extrabold";
          position = "0, 200";
          halign = "center";
          valign = "center";
        }

        {
          monitor = "";
          text = "Matthew";
          color = "$foreground";
          font_size = 14;
          font_family = "JetBrains Mono";
          position = "0, -10";
          halign = "center";
          valign = "top";
        }

        {
          monitor = "";
          text = "cmd[update:1000] echo \"$(~/.config/hypr/battery.sh)\"";
          color = "$foreground";
          font_size = 14;
          font_family = "JetBrains Mono";
          position = "-10, -10";
          halign = "right";
          valign = "top";
        }
      ];
    };
  };
}
