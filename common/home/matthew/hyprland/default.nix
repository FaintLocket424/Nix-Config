{
  pkgs,
  config,
  inputs,
  ...
}: {
  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = false;

    settings = {
	  layerrule = [
        "blur, launcher"
        "blur, notifications"
        "ignorezero, notifications"
      ];
	  
	  monitor = [
	    "eDP-1, 1920x1080@60, 0x0, 1.2"
	  ];
	  
	  exec-once = [
	    "~/.config/hypr/switch.sh"
      "xsetroot -cursor_name left_ptr"
      "uwsm app -- nm-applet"
	  ];
	  
	  env = [
      "PF_INFO, ascii title os kernel uptime memory palette"
      "PF_ASCII, linux"
      "XCURSOR_THEME, Bibata-Modern-Classic"
      "XCURSOR_SIZE, 32"
      "HYPRCURSOR_THEME,HyprBibataModernClassicSVG"
      "HYPRCURSOR_SIZE,20"
      "GDK_SCALE, 1.2"
      "NIXOS_OZONE_WL, 1"
      "DIRENV_LOG_FORMAT,"
      "XDG_DOWNLOAD_DIR, $HOME/downloads"
      "SSH_AUTH_SOCK, /run/user/1000/keyring/ssh"
    ];

	  xwayland.force_zero_scaling = true;

#	  render = {
#	    allow_early_buffer_release = 0;
#	  };

    input = {
      sensitivity = 0.5;
      kb_layout = "gb";
      follow_mouse = 1;
      accel_profile = "flat";
      force_no_accel = 1;
      scroll_factor = 0.9;

      touchpad = {
        scroll_factor = 0.2;
        natural_scroll = true;
        disable_while_typing = true;
      };
    };

	  general = {
      gaps_out = 4;
      gaps_in = 3;
      border_size = 1;
      layout = "dwindle";
    };

    decoration = {
      blur = {
        xray = false;
        size = 12;
        popups = true;
        passes = 3;
      };
      rounding = 2;
      shadow = {
        enabled = true;
      };
    };
	  
	  animations = {
      bezier = "mybezier, 0.05, 0.9, 0.1, 1.00";
      animation = [
        "windows, 1, 3, mybezier"
        "windowsOut, 1, 4, default, popin 80%"
        "border, 1, 10, default"
        "borderangle, 1, 8, default"
        "fade, 1, 4, default"
        "workspaces, 1, 2, default"
      ];
    };
	  
	  dwindle = {
      pseudotile = true;
      preserve_split = true;
    };
	  
	  gestures.workspace_swipe = true;

      "$mainmod" = "super";
	  
      bindl = [
        ",switch:Lid Switch, exec, ~/.config/hypr/switch.sh"

		# Next/Prev Track
        ", XF86AudioNext, exec, ${pkgs.playerctl}/bin/playerctl next"
        ", XF86AudioPause, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
		
		# Play/Pause Track
        ", XF86AudioPlay, exec, ${pkgs.playerctl}/bin/playerctl play-pause"
        ", XF86AudioPrev, exec, ${pkgs.playerctl}/bin/playerctl previous"
		
		# Audio Mute
        ",xf86audiomute, exec, wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"
      ];

      bind = [
	    # Keybinds
	    ## Exit Hyprland
	    "$mainmod CTRL SHIFT ALT, Delete, exec, hyprctl dispatch exit 0"
		
		## Close active (not kill)
		"$mainmod, Q, killactive, "
		
		## Power Menu
		"CTRL ALT, Delete, exec, uwsm-app -- wlogout -b 4 -c 10"

		## Lock Computer
		"$mainmod, l, exec, hyprlock"
		
		## Fullscreen
        "$mainmod, w, fullscreen"

		## Unblock Wifi 
		"$mainmod, p, exec, rfkill unblock all"
		
		## Open Terminal
        "$mainmod, Return, exec, uwsm-app -- kitty"
        
		## Open File Browser
        "$mainmod, e, exec, uwsm-app -- nemo"
		
		## Toggle Floating
        "$mainmod, v, togglefloating,"
		
		## Search
        "$mainmod, space, exec, fuzzel --launch-prefix=\"uwsm app -- \""
		
		## Brave
        "$mainmod, b, exec, uwsm-app -- brave"

        # Move Focus
        "$mainmod, left, movefocus, l"
        "$mainmod, right, movefocus, r"
        "$mainmod, down, movefocus, d"
        "$mainmod, up, movefocus, u"

        # Switch workspaces
        "$mainmod, 1, focusworkspaceoncurrentmonitor, 1"
        "$mainmod, 2, focusworkspaceoncurrentmonitor, 2"
        "$mainmod, 3, focusworkspaceoncurrentmonitor, 3"
        "$mainmod, 4, focusworkspaceoncurrentmonitor, 4"
        "$mainmod, 5, focusworkspaceoncurrentmonitor, 5"
        "$mainmod, 6, focusworkspaceoncurrentmonitor, 6"
        "$mainmod, 7, focusworkspaceoncurrentmonitor, 7"
        "$mainmod, 8, focusworkspaceoncurrentmonitor, 8"
        "$mainmod, 9, focusworkspaceoncurrentmonitor, 9"
        "$mainmod, 0, focusworkspaceoncurrentmonitor, 10"
		
		# Screenshot
        ",print, exec, grim -g \"$(slurp -d)\" - | wl-copy -t image/png"

		# Move window to workspace and focus it.
        "$mainmod shift, 1, movetoworkspacesilent, 1"
        "$mainmod shift, 2, movetoworkspacesilent, 2"
        "$mainmod shift, 3, movetoworkspacesilent, 3"
        "$mainmod shift, 4, movetoworkspacesilent, 4"
        "$mainmod shift, 5, movetoworkspacesilent, 5"
        "$mainmod shift, 6, movetoworkspacesilent, 6"
        "$mainmod shift, 7, movetoworkspacesilent, 7"
        "$mainmod shift, 8, movetoworkspacesilent, 8"
        "$mainmod shift, 9, movetoworkspacesilent, 9"
        "$mainmod shift, 0, movetoworkspacesilent, 10"
        "$mainmod shift, 1, focusworkspaceoncurrentmonitor, 1"
        "$mainmod shift, 2, focusworkspaceoncurrentmonitor, 2"
        "$mainmod shift, 3, focusworkspaceoncurrentmonitor, 3"
        "$mainmod shift, 4, focusworkspaceoncurrentmonitor, 4"
        "$mainmod shift, 5, focusworkspaceoncurrentmonitor, 5"
        "$mainmod shift, 6, focusworkspaceoncurrentmonitor, 6"
        "$mainmod shift, 7, focusworkspaceoncurrentmonitor, 7"
        "$mainmod shift, 8, focusworkspaceoncurrentmonitor, 8"
        "$mainmod shift, 9, focusworkspaceoncurrentmonitor, 9"
        "$mainmod shift, 0, focusworkspaceoncurrentmonitor, 10"
      ];
	  
	  bindel = [
	    # Volume Control
        ",xf86audioraisevolume,exec,wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%+"
        ",xf86audiolowervolume, exec, wpctl set-volume -l 1.4 @DEFAULT_AUDIO_SINK@ 5%-"
		
		# Brightness Control with brillo
        ",xf86monbrightnessdown,exec,brillo -q -U 5"
        ",xf86monbrightnessup,exec,brillo -q -A 5"
      ];
	  
	  bindm = [
		# Click and drag to move windows with super + left click
        "$mainmod, mouse:272, movewindow"
		
		# Click and drag to resize windows with super + right click
        "$mainmod, mouse:273, resizewindow"
      ];

      windowrule = [
#        "nofocus, class:^jetbrains-(?!toolbox), floating:1, title:^win\d+$"
      ];
	  
	  misc = {
        vfr = true;
        force_default_wallpaper = 0;
      };
	  
      ecosystem = {
        no_donation_nag = true;
        no_update_news = true;
      };

      debug = {
        disable_logs = false;
      };
    };
  };

  programs.wlogout = {
    enable = true;
    layout = [
      {
        "label" = "logout";
        "action" = "loginctl terminate-user $USER";
        "text" = "Logout";
        "keybind" = "e";
      }
      {
        "label" = "shutdown";
        "action" = "systemctl poweroff";
        "text" = "Shutdown";
        "keybind" = "s";
      }
      {
        "label" = "suspend";
        "action" = "systemctl suspend";
        "text" = "Suspend";
        "keybind" = "u";
      }
      {
        "label" = "reboot";
        "action" = "systemctl reboot";
        "text" = "Reboot";
        "keybind" = "r";
      }
    ];
  };

  home.packages = with pkgs; [
    grim
    slurp
  ];

  home.file."${config.xdg.configHome}/hypr/switch.sh" = {
    source = ./switch.sh;
  };

  home.file."${config.xdg.configHome}/hypr/battery.sh" = {
    source = ./battery.sh;
  };
}
