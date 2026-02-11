{
  config,
  lib,
  pkgs,
  ...
}:

{
  options.myFeatures.desktop.common.enable = lib.mkEnableOption "Common Desktop Infrastructure";

  config = lib.mkIf config.myFeatures.desktop.common.enable {
    # 1. Base Graphics & Input
    services.xserver = {
      enable = true; # Needed for XWayland and some DMs
      xkb.layout = "gb";
      excludePackages = [ pkgs.xterm ];
    };

    services.displayManager.gdm.enable = true;

    # 2. Hardware / System Utilities
    services.udisks2.enable = true;
    services.automatic-timezoned.enable = true;
    services.flatpak.enable = true;

    # 3. Audio (PipeWire)
    services.pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    # 4. Fonts
    fonts.packages = with pkgs; [
      nerd-fonts.symbols-only
      corefonts
      vista-fonts
      google-fonts
    ];

    # 5. Default Terminal (Global Preference)
    # We set this here so it persists even if you switch to Hyprland
    xdg.terminal-exec = {
      enable = true;
      settings.default = [ "kitty.desktop" ];
    };
  };
}
