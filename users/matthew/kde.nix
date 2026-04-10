{ pkgs, lib, ... }:
let
  wallpaper = ./wallpapers/art002e009301-large.jpg;
in
{
  systemd.user.services.set-plasma-wallpaper = {
    Unit = {
      Description = "Set Plasma Wallpaper";
      After = [ "graphical-session.target" ];
      PartOf = [ "graphical-session.target" ];
    };

    Install.WantedBy = [ "graphical-session.target" ];

    Service = {
      ExecStart = "${pkgs.writeShellScript "set-wallpaper" ''
        sleep 2
        ${pkgs.kdePackages.plasma-workspace}/bin/plasma-apply-wallpaperimage ${wallpaper}
      ''}";
      Type = "oneshot";
    };
  };

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
