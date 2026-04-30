{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # protonvpn-gui
  ];

  networking = {
    firewall.checkReversePath = "loose";

    wireguard.interfaces."wg-proton" = {
      ips = [ "10.x.x.x/32" ];
      privateKeyFile = "/run/secrets/proton.key";

      routes = [
        { address = "0.0.0.0"; prefixLength = 1; }
        { address = "128.0.0.0"; prefixLength = 1; }
      ];

      peers = [
        {
          publicKey = "AFp36cKCIznWgRchU9fE2G9kPK6zcdS+7S/u4drPU1g=";
          endpoint = "HOST:PORT";

          allowedIPs = [
            "0.0.0.0/1"
            "128.0.0.0/1"
          ];
        }
      ];
    };
  };

  services.tailscale.enable = true;
  services.resolved.enable = true;
}
