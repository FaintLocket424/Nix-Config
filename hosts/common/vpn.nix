{ pkgs, ... }: {
  # environment.systemPackages = with pkgs; [
  # protonvpn-gui
  # ];

  networking = {
    firewall.checkReversePath = "loose";

    wireguard.interfaces = {
      wg0 = {
        ips = [
          "10.2.0.2/32"
          "2a07:b944::2:2/128"
        ];

        privateKeyFile = "/run/secrets/wg-proton-private.key";

        listenPort = 51820;

        peers = [
          {
            publicKey = "AFp36cKCIznWgRchU9fE2G9kPK6zcdS+7S/u4drPU1g=";

            allowedIPs = [
              "0.0.0.0/0"
              "::/0"
            ];

            endpoint = "146.70.48.2:51820";

            persistentKeepalive = 25;
          }
        ];
      };
    };

    nameservers = [ "10.2.0.1" "2a07:b944::2:1" ];
  };

  # services.tailscale.enable = true;

  services.resolved = {
    enable = true;
  };
}
