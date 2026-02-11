{ pkgs, ... }:
{
  # Key: Script name (e.g., "my-player-script")
  # Value: List of runtime inputs (packages)

  "rebuild-system" = [
    pkgs.git
  ];

  "update-flake" = [
    pkgs.git
  ];

  "durham-vpn" = [
    pkgs.openconnect
    pkgs.vpnc-scripts
  ];

  # You can also define a default set of dependencies for scripts not listed here
  "default" = [
    pkgs.coreutils # For commands like `ls`, `grep`, `sed`
  ];
}
