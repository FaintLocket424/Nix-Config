{ pkgs, inputs, ... }:
{
  imports = [
    ./gaming.nix
    ./development.nix
    ./scripts.nix
    ./kde.nix
    ./hyprland.nix
    ./firefox.nix
    ./vm
    ./syncthing.nix
  ];

  home.sessionVariables = {
    NH_FLAKE = "$HOME/nixos-config";
  };

  home.packages = with pkgs; [
    # Utils
    nh
    pciutils
    usbutils
    ncdu
    linuxConsoleTools
    yazi # Terminal file manager
    filezilla # FTP file transfers
    photoflare # Image Editor
    bambu-studio # 3D Printing Slicer
    freecad # 3D Modelling
    # obs-studio # Screen Recording
    obsidian # Note-taking App
    scrcpy # Android Screen Mirroring
    dolphin-emu # Dolphin Wii Emulator
    ryubing # Switch Emulator
    inputs.eden.packages.${pkgs.system}.eden
    moonlight-qt
  ];

  programs.kitty.enable = true;

  home.file.".config/vesktop/themes" = {
    source = ./discord_themes;
    recursive = true;
  };
}
