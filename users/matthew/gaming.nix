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
    jstest-gtk
    mangohud
    goverlay
    heroic
    lutris

    wineWow64Packages.stable

    (bottles.override { removeWarningPopup = true; })
  ];

  home.file.".local/bin/minecraft-jars/java-25".source = "${pkgs.jdk25}/bin/java";
  home.file.".local/bin/minecraft-jars/java-21".source = "${pkgs.jdk21}/bin/java";
  home.file.".local/bin/minecraft-jars/java-17".source = "${pkgs.jdk17}/bin/java";
}
