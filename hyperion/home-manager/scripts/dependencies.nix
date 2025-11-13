{ pkgs, ... }: {
  # Key: Script name (e.g., "my-player-script")
  # Value: List of runtime inputs (packages)

  "update" = [
    pkgs.git
    pkgs.nh
  ];

  "rebuild" = [
    pkgs.git
  ];

  # You can also define a default set of dependencies for scripts not listed here
  "default" = [
#    pkgs.bash
    pkgs.coreutils # For commands like `ls`, `grep`, `sed`
  ];
}