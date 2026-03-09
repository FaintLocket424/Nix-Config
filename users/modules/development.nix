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
      godotPackages_4_6.godot # FOSS game engine
      arduino-ide # IDE for working with Arduino hardware
      unityhub # Manager for Unity game engine
      paraview # 3D Data Analysis
      lmstudio # Desktop UI for local LLM models
      filezilla # FTP file transfers
      httrack # Website copier
      sshfs # SSH File System

      # Runtimes and Compilers
      jdk25 # Dev Kit and runtime for Java 25
      gradle # Build tool for Java and Kotlin
      python314 # Python 3.14
      gnumake # Building make
      gcc # GNU Compiler Collection
      arduino-cli # CLI for working with Arduino hardware
      pandoc # Document compiler
      texliveFull # LaTeX
      ghc # The Glasgow Haskell Compiler
      haskell-language-server
      (lib.hiPrio msbuild) # C# Compiler related
      mono # C# Compiler related
      dotnet-sdk_9 # C# Compiler related
      dotnet-runtime_9 # C# Compiler related
      go # Compiler for Go
      androidenv.androidPkgs.platform-tools # android sdk tools
      fish-lsp # Language Server for Fish scripts
      uv # Python package manager

      # Code Editors
      jetbrains.clion
      jetbrains.goland
      jetbrains.idea
      jetbrains.pycharm
      jetbrains.rider
      jetbrains.webstorm
      vscode
      eclipses.eclipse-java
    ];

    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;

      extraConfig = ''
        Host *
            WarnWeakCrypto no
      '';

      matchBlocks = {
        "*" = {
          addKeysToAgent = "yes";
          forwardAgent = false;
          compression = false;
          serverAliveInterval = 0;
          serverAliveCountMax = 3;
          hashKnownHosts = false;
          userKnownHostsFile = "~/.ssh/known_hosts";
          controlMaster = "no";
          controlPath = "~/.ssh/master-%r@%n:%p";
          controlPersist = "no";
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

        "NCC" = {
          hostname = "ncc1.clients.dur.ac.uk";
          user = "qcsc66";
          setEnv = {
            TERM = "xterm-256color";
          };
        };

        "Falcon" = {
          hostname = "100.70.23.49";
          user = "matthew";
        };
      };
    };

    services.ssh-agent.enable = true;

    services.ollama = {
      enable = true;
      package = pkgs.ollama-vulkan;
      environmentVariables = {
        GGML_VK_DISABLE_INTEGER_DOT_PRODUCT = "1";
      };
    };

    programs.direnv = {
      enable = true;
      nix-direnv.enable = true;
      silent = true;
    };

    programs.git = {
      enable = true;
      settings = {
        safe = {
          directory = "/home/matthew/programming/Production/nixos-config";
        };
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
