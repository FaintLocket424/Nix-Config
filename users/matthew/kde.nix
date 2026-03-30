{ pkgs, lib, ... }: {
  home.activation.setWallpaperAllScreens = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.kdePackages.plasma-workspace}/bin/plasma-apply-wallpaperimage ${./wallpaper.jpg}
  '';

  # https://nix-community.github.io/plasma-manager/options.xhtml
  programs.plasma = {
    workspace = {
      wallpaper = "${./wallpaper.jpg}";
    };

    kwin = {
      effects = {
        desktopSwitching.animation = "slide";
        wobblyWindows.enable = true;
      };

      virtualDesktops = {
        number = 8;
        rows = 2;
      };
    };

    shortcuts = {
      "services/org.kde.konsole.desktop"."_launch" = "Ctrl+Alt+T";
    };

    kscreenlocker.appearance.wallpaper = "${./wallpaper.jpg}";
  };
}
