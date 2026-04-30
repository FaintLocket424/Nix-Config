{ pkgs, ... }: {
  environment.systemPackages = with pkgs; [
    protonvpn-gui
  ];

  services.resolved.enable = true;
}
