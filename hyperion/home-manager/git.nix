{ pkgs, ... }:
{
  home.packages = with pkgs; [
    git-credential-manager
  ];

  programs.git = {
    enable = true;
    userName = "FaintLocket424";
    userEmail = "github.grill135@passinbox.com";
    extraConfig = {
      init.defaultBranch = "main";
      core.autocrlf = "input";

      credential = {
        credentialStore = "secretservice";
        helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
      };
    };
  };
}