{
  config,
  lib,
  pkgs,
  ...
}:
{
  options.myHome.development.enable = lib.mkEnableOption "Development Runtimes and IDEs";

  config = lib.mkIf config.myHome.development.enable {
    home.packages = with pkgs; [
      godot # FOSS game engine
      arduino-ide # IDE for working with Arduino hardware
      unityhub # Manager for Unity game engine

      # Runtimes and Compilers
      (lib.hiPrio jdk25) # Dev Kit and runtime for Java 25
      jdk21 # Dev Kit and runtime for Java 21
      jdk17 # Dev Kit and runtime for Java 17
      jdk8 # Dev Kit and runtime for Java 8
      gradle # Build tool for Java and Kotlin
      (lib.hiPrio python314) # Python 3.14
      python313 # Python 3.13
      python312 # Python 3.12
      gnumake # Building make
      gcc # GNU Compiler Collection
      arduino-cli # CLI for working with Arduino hardware
      pandoc # Document compiler
      texliveFull # LaTeX
      ghc # The Glasgow Haskell Compiler
      (lib.hiPrio msbuild) # C# Compiler related
      mono # C# Compiler related
      dotnet-sdk_9 # C# Compiler related
      dotnet-runtime_9 # C# Compiler related

      # Code Editors
      jetbrains.clion
      jetbrains.goland
      jetbrains.idea
      jetbrains.pycharm
      jetbrains.rider
      jetbrains.webstorm
      vscode
    ];

    programs.ssh = {
      enable = true;
      enableDefaultConfig = true;

      matchBlocks = {
        "*" = {
          addKeysToAgent = "yes";
        };

        "github.com" = {
          hostname = "github.com";
          user = "git";
          identityFile = "~/.ssh/id_ed25519";
        };

        "Hamilton" = {
          hostname = "hamilton8.dur.ac.uk";

          user = "qcsc66";

          setEnv = {
            TERM = "xterm-256color";
          };
        };
      };
    };

    services.ssh-agent.enable = true;

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      silent = true;
    };

    programs.git = {
      enable = true;
      settings = {
        init.defaultBranch = "main";
        core.autocrlf = "input";

        url = {
          "git@github.com:" = {
            insteadOf = "https://github.com/";
          };
        };
      };
    };
  };
}
