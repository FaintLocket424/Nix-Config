{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.myFeatures.connectivity.enable = lib.mkEnableOption "Printing, Bluetooth, and VPNs";

  config = lib.mkIf config.myFeatures.connectivity.enable {
    hardware.bluetooth = {
      enable = true;
      powerOnBoot = true;
    };
    services.blueman.enable = true;

    services = {
      printing = {
        enable = true;
        drivers = [
          pkgs.gutenprint
          pkgs.canon-cups-ufr2
        ];
      };

      avahi = {
        enable = true;
        nssmdns4 = true;
        openFirewall = true;
      };

      tailscale.enable = true;
    };

    environment.systemPackages = with pkgs; [
      wireguard-tools
      protonvpn-gui
    ];
  };
}
