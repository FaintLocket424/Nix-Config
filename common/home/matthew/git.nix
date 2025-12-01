{ pkgs, ... }:
{
  home.packages = with pkgs; [
    git-credential-manager
  ];

  programs.git = {
    enable = true;
    settings = {
      user.name = "FaintLocket424";
      user.email = "github.grill135@passinbox.com";

      init.defaultBranch = "main";
      core.autocrlf = "input";

      credential = {
        credentialStore = "secretservice";
        helper = "${pkgs.git-credential-manager}/bin/git-credential-manager";
      };
    };
  };
}