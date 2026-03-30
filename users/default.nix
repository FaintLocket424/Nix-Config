{ config, pkgs, ... }: {
  imports = [
    ./matthew
    #    ./francesca
  ];

  programs.fish.enable = true;
  users.defaultUserShell = pkgs.fish;
  users.users.root.hashedPassword = "!";
  users.mutableUsers = false;
}
