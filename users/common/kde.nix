{ ... }: {
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
      fixedWidth = { family = "JetBrainsMono Nerd Font"; pointSize = 10; };
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

    # shortcuts = {
    #   "MaximizeWindow" = "Meta+Up";
    #   "MinimizeWindow" = "Meta+Down";
    #   "Window Quick Tile Left" = "Meta+Left";
    #   "Window Quick Tile Right" = "Meta+Right";
    # };

    powerdevil.AC.autoSuspend.action = "nothing";

    input = {
      mice = [
        {
          name = "*";
          accelerationProfile = "flat";
          acceleration = "-0.1";
        }
      ];
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
}
