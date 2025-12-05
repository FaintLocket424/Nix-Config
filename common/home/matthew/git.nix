{ pkgs, ... }:
{
  programs.git = {
    enable = true;
    settings = {
      user.name = "FaintLocket424";
      user.email = "github.grill135@passinbox.com";

      init.defaultBranch = "main";
      core.autocrlf = "input";

      url = {
        "git@github.com:" = {
          insteadOf = "https://github.com/";
        };
      };
    };
  };

  programs.ssh = {
    addKeysToAgent = "yes";

    matchBlocks = {
      "github.com" = {
        hostname = "github.com";
        user = "git";
        identityFile = "~/.ssh/id_ed25519";
      };
    };
  };

  services.ssh-agent.enable = true;
}