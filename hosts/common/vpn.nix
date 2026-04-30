{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    # protonvpn-gui
  ];

  networking = {
    firewall.checkReversePath = "loose";

    wireguard.interfaces."wg-proton" = {
      ips = [
        "10.2.0.2/32"
        "2a07:b944::2:2/128"
      ];

      privateKeyFile = "/run/secrets/proton.key";

      routes = [
        { address = "0.0.0.0"; prefixLength = 1; }
        { address = "128.0.0.0"; prefixLength = 1; }
        { address = "::"; prefixLength = 1; }
        { address = "8000::"; prefixLength = 1; }
      ];

      peers = [
        {
          publicKey = "AFp36cKCIznWgRchU9fE2G9kPK6zcdS+7S/u4drPU1g=";
          endpoint = "146.70.48.2:51820";

          allowedIPs = [
            "0.0.0.0/1"
            "128.0.0.0/1"

            "::/1"
            "8000::/1"
          ];

          persistentKeepalive = 25;
        }
      ];
    };
  };

  services.tailscale.enable = true;

  services.resolved = {
    enable = true;
    dnssec = "false";
  };
}
