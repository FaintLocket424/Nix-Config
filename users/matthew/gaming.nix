{ config, pkgs, inputs, ... }: {
  home.packages = with pkgs; [
    # Minecraft
    prismlauncher # Minecraft Launcher
    # modrinth-app # Modded Minecraft Launcher
    mcaselector # Tool for filtering chunks in Minecraft worlds
    worldpainter # Minecraft world creator

    # Utils
    evtest
    evtest-qt
    antimicrox
    jstest-gtk
    # xwiimote
    mangohud
    goverlay
    heroic
    lutris

    wineWow64Packages.stable

    (bottles.override { removeWarningPopup = true; })
  ];
}
