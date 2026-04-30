{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    protonvpn-gui
  ];

  services.tailscale.enable = true;

  services.resolved.enable = true;
}
