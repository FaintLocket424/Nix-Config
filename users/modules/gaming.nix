{
  config,
  lib,
  pkgs,
  hostname,
  ...
}:
{
  options.myHome.gaming.enable = lib.mkEnableOption "Gaming apps and launchers";

  config = lib.mkIf config.myHome.gaming.enable {
    home.packages = with pkgs; [
      protonup-ng # IDK - Something for steam proton.
      dolphin-emu # FOSS for running Wii and Gamecube games
      modrinth-app # Minecraft Launcher
      prismlauncher # Minecraft Launcher

      #      mesa-demos
      #      vulkan-tools
      #      clinfo
      #      libva-utils
      #      vdpauinfo

      # WINE translation layer for x86 games.
      winetricks
      wineWowPackages.waylandFull
      wineWowPackages.fonts
      (bottles.override {
        removeWarningPopup = true;
      })

      # Controller libs
      xwiimote # Driver for wiimotes
      evtest # CLI program for
      evtest-qt
      antimicrox
      linuxConsoleTools
      jstest-gtk
    ];
  };
}
