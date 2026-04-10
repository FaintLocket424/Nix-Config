{ pkgs, lib, ... }:
let
  wallpaper = ./wallpapers/art002e009288orig.jpg;
in
{
  home.activation.setWallpaperAllScreens = lib.hm.dag.entryAfter [ "writeBoundary" ] ''
    ${pkgs.kdePackages.plasma-workspace}/bin/plasma-apply-wallpaperimage ${wallpaper}
  '';

  # https://nix-community.github.io/plasma-manager/options.xhtml
  programs.plasma = {
    workspace = {
      wallpaper = "${wallpaper}";
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

    kscreenlocker.appearance.wallpaper = "${wallpaper}";
  };
}
