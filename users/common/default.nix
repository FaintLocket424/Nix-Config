{ pkgs, lib, ... }: {
  home.packages = with pkgs; [
    bat
    eza
    fd
    ripgrep

    fastfetch
    pfetch
    p7zip
    wget

    geteduroam
    btop
    htop
    vesktop
    qalculate-qt

    haruna
  ];

  programs.plasma = {
    enable = true;
    overrideConfig = true;

    workspace = {
      cursor = {
        animationTime = 5;
        cursorFeedback = "Bouncing";
        size = 20;
        theme = "Bibata-Modern-Classic";
      };

      lookAndFeel = "org.kde.breezedark.desktop";
      theme = "breeze-dark";

      wallpaperFillMode = "preserveAspectCrop";
      widgetStyle = "breeze";
    };

    fonts = {
      fixedWidth = { family = "JetBrainsMono Nerd Font Mono"; pointSize = 10; };
      general = { family = "Noto Sans"; pointSize = 10; };
    };

    kwin = {
      effects = {
        blur.enable = true;
        dimAdminMode.enable = true;
        # minimization.animation = "magiclamp";
        shakeCursor.enable = false;
        # slideBack.enable = true;
        # windowOpenClose.animation = "glide";
      };
    };

    input = {
      touchpads = [
        {
          name = "SYNA32DE:00 06CB:CEE7 Touchpad";
          naturalScroll = true;
          productId = "cee7";
          vendorId = "06cb";
        }
      ];
    };

    kscreenlocker = {
      autoLock = true;
      timeout = 5;
    };
  };

  programs = {
    chromium = {
      enable = true;
      package = pkgs.brave;

      commandLineArgs = [
        "--enable-features=UseOzonePlatform"
        "--ozone-platform=wayland"
        "--enable-gpu-rasterization"
        "--enable-zero-copy"
        "--enable-smooth-scrolling"
      ];
    };

    fish = {
      enable = true;

      shellAliases = {
        ls = "eza --icons --group-directories-first";
        cat = "bat";
        ll = "eza -l --icons --git -a";
        find = "fd";
        grep = "rg";
      };

      interactiveShellInit = ''
        fastfetch
        set -g fish_greeting ""
      '';
    };

    zoxide = {
      enable = true;
      enableFishIntegration = true;
      options = [ "--cmd cd" ];
    };

    fzf = {
      enable = true;
      enableFishIntegration = true;
      defaultCommand = "fd --type f";
    };

    starship = {
      enable = true;
      enableFishIntegration = true;
      settings = {
        add_newline = false;
        command_timeout = 20;
        format = "[](green)$username[](bg:cyan fg:green)$directory[](fg:cyan bg:blue)$git_branch$git_status[](fg:blue bg:bright-black)$time[ ](fg:bright-black)$line_break$character";

        username = {
          show_always = true;
          style_user = "bg:green fg:black";
          style_root = "bg:green fg:black";
          format = "[ $user ]($style)";
        };

        directory = {
          style = "fg:black bg:cyan";
          format = "[ $path ]($style)";
          truncation_length = 3;
          truncation_symbol = "…/";
        };

        git_branch = {
          symbol = "";
          style = "bg:blue fg:black";
          format = "[[ $symbol $branch ](fg:black bg:blue)]($style)";
        };

        git_status = {
          style = "bg:blue";
          format = "[[($all_status$ahead_behind )](fg:black bg:blue)]($style)";
        };

        time = {
          disabled = false;
          time_format = "%R";
          style = "bg:bright-black";
          format = "[[  $time ](fg:white bg:bright-black)]($style)";
        };
      };
    };

    git.enable = true;
    home-manager.enable = true;
  };

  services = {
    playerctld.enable = true;
  };

  fonts.fontconfig.enable = true;

  systemd.user.startServices = "sd-switch";

  home.stateVersion = "25.11";
}
