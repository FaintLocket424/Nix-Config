{ pkgs, ... }: {
  home.packages = with pkgs; [
    # Game Engines
    godotPackages_4_6.godot # FOSS game engine

    # Runtimes, Compilers, and CLI Dev Tools
    jdk25 # Java Development Kit
    # gradle # Build tool for Java/Kotlin
    python315 # Python 3.15
    # uv # Python package manager
    # gnumake # Make
    gcc # GNU Compiler Collection
    # arduino-cli # Arduino headless CLI
    # platformio # PlatformIO microcontroller toolchain manager
    # avrdude # AVR Flashing
    # openocd # ARM/STM32 debugging and flashing
    # pandoc # Document compiler
    # texliveFull # LaTeX
    # ghc # Glasgow Haskell Compiler
    # haskell-language-server
    # mono # C# Compiler related
    # dotnet-sdk_9 # .NET 9 SDK
    # dotnet-runtime_9 # .NET 9 Runtime
    # android-tools # Android platform tools (adb, fastboot)
    # vegeta # API Testing

    nixd # Nix LSP
    nixpkgs-fmt # Nix formatter

    # Utilities
    # httrack # Website copier
    sshfs # SSH File System
  ];

  services = {
    ollama = {
      enable = true;
      package = pkgs.ollama-vulkan;
      environmentVariables = {
        OLLAMA_HOST = "0.0.0.0";
      };
    };

    ssh-agent.enable = true;
  };

  programs = {
    git = {
      settings = {
        user.name = "FaintLocket424";
        user.email = "github.grill135@passinbox.com";
        init.defaultBranch = "main";
        core.autocrlf = "input";
        url = {
          " git@github.com:" = {
            insteadOf = "https://github.com/";
          };
        };
      };
      ignores = [
        "result"
        "result-*"
        ".direnv/"
        ".envrc"
      ];
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      silent = true;
    };

    ssh = {
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

          # Connection multiplexing (Massively speeds up multiple SSH sessions to the same host)
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
          setEnv = { TERM = "xterm-256color"; };
        };

        "NCC" = {
          hostname = "ncc1.clients.dur.ac.uk";
          user = "qcsc66";
          setEnv = { TERM = "xterm-256color"; };
        };

        "Falcon" = {
          hostname = "100.70.23.49";
          user = "matthew";
        };
      };
    };

    zed-editor = {
      enable = true;

      extensions = [
        "nix"
        "go"
        "java"
        "python"
        "toml"
        "fish"
        "nvim-nightfox"
        "git-firefly"
        "powershell"
      ];

      userSettings = {
        theme = {
          mode = "dark";
          light = "Dawnfox - blurred";
          dark = "Carbonfox - blurred";
        };

        agent.enabled = false;
        base_keymap = "JetBrains";

        # UI
        ui_font_size = 14;
        ui_font_family = "Inter";

        # Editor
        buffer_font_size = 14;
        buffer_font_family = "JetBrainsMono Nerd Font";
        buffer_font_features = {
          calt = true;
        };

        terminal = {
          font_family = "JetBrainsMono Nerd Font";

          font_features = {
            calt = true;
          };
        };

        collaboration_panel.button = false;

        show_edit_predictions = false;

        telemetry = {
          diagnostics = false;
          metrics = false;
        };

        autosave = "on_focus_change";

        # Use system language servers
        languages = {
          Nix = {
            language_servers = [ "nixd" ];
            formatter.external.command = "nixpkgs-fmt";
          };
          Go = {
            language_servers = [ "gopls" ];
          };
          Java = {
            language_servers = [ "jdtls" ];
          };
          Fish = {
            language_servers = [ "fish-lsp" ];
          };
        };

        # Disable automatic LSP installation attempts
        lsp = {
          nixd.binary.ignore_system_version = false;
          gopls.binary.ignore_system_version = false;
          jdtls.binary.ignore_system_version = false;
          fish-lsp.binary.ignore_system_version = false;
        };
      };
    };
  };
}
