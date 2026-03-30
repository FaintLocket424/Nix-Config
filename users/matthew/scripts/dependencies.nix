{ pkgs }:

{
  # Default dependencies if a script isn't explicitly listed here
  "default" = with pkgs;[
    coreutils
    findutils
    jq
  ];

  "rebuild-system" = with pkgs;[
    git
    nh
    fastfetch
    nix
  ];

  "update-flake" = with pkgs; [
    git
    nix
  ];

  "connect-durham-vpn" = with pkgs;[
    openconnect
    vpnc-scripts
  ];

  "config-durham-dns" = with pkgs;[
    iproute2
    systemd
  ];
}
