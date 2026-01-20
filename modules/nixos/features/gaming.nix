{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.myFeatures.gaming.enable = lib.mkEnableOption "Gaming and High-Performance setup";

  config = lib.mkIf config.myFeatures.gaming.enable {
    hardware.graphics = {
      enable = true;
      enable32Bit = true;
    };
    hardware.xone.enable = true;
    services.joycond.enable = true;

    services.scx = {
      enable = true;
      scheduler = "scx_lavd";
      extraArgs = [
        "--autopower"
        "--verbose"
      ];
    };

    programs.steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      localNetworkGameTransfers.openFirewall = true;
      gamescopeSession.enable = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
    };
  };
}
