{
  config,
  pkgs,
  lib,
  inputs,
  hostname,
  pkgs-unstable,
  ...
}: {
  imports = [
    ./stylix.nix
    ./git.nix
    ./shell.nix
  ];

  home = {
    sessionVariables = {
        STEAM_EXTRA_COMPAT_TOOLS_PATHS =
            "\${HOME}/.steam/root/compatibilitytools.d";
    };

    packages = (with pkgs; [
      photoflare # Image Editor like Paint.NET
      popsicle # ISO Writer
      bambu-studio # 3D Printing Slicer for Bambu Labs Printers
      freecad # FOSS 3D Modelling Software
      obs-studio # FOSS for Screen Recording and Streaming
      obsidian # FOSS for Markdown Note-taking
      protonup # IDK - Something for steam proton.
      dolphin-emu # FOSS for running Wii and Gamecube games
      scrcpy # Android screen mirroring
      zotero # Research reference manager
      godot # FOSS game engine
      arduino-ide # IDE for working with Arduino hardware



      # Controller libs
      xwiimote # Driver for wiimotes
      evtest # CLI program for
      evtest-qt
      antimicrox
      linuxConsoleTools
      jstest-gtk


      # Runtimes and Compilers
      (hiPrio jdk21) # Dev Kit and runtime for Java 21
      jdk17 # Dev Kit and runtime for Java 17
      jdk8 # Dev Kit and runtime for Java 8
      gradle # Build tool for Java and Kotlin
      (hiPrio python314) # Python 3.14
      python313 # Python 3.13
      python312 # Python 3.12
      gnumake # Building make
      gcc # GNU Compiler Collection
      arduino-cli # CLI for working with Arduino hardware
      pandoc # Document compiler
      texliveFull # LaTeX
      ghc # The Glasgow Haskell Compiler


      # Code Editors
      jetbrains.idea-ultimate
      jetbrains.pycharm-professional
      jetbrains.goland
      jetbrains.webstorm
      vscode
    ]) ++ (with pkgs-unstable; [

    ]);
  };

  services = {
#    hyprpaper.enable = true;
#
#    hyprsunset = {
#      enable = true;
#      transitions = {
#        sunrise = {
#          calendar = "*-*-* 06:00:00";
#          requests = [
#            [ "temperature" "6500" ]
#            [ "gamma 100" ]
#          ];
#        };
#        sunset = {
#          calendar = "*-*-* 19:00:00";
#          requests = [
#            [ "temperature" "3500" ]
#          ];
#        };
#      };
#    };

    # Wayland Notifications
#    mako = {
#      enable = true;
#      settings = {
#        default-timeout = "5000";
#        border-radius = "5";
#        icons = "true";
#        max-icon-size = "96";
#        layer = "top";
#      };
#    };

    syncthing = {
      enable = true;
      settings = {
        openDefaultPorts = true;
        options.localAnnounceEnabled = true;
        options.urAccepted = -1;
      };
      overrideDevices = true;
      overrideFolders = true;
    };
  };

  programs = {
    git.enable = true;

    ssh = {
      enable = true;
      matchBlocks = {
        "Hamilton" = {
          hostname = "hamilton8.dur.ac.uk";

          user = "qcsc66";

          setEnv = {
            TERM = "xterm-256color";
          };
        };
      };
    };

    direnv = {
      enable = true;
      nix-direnv.enable = true;
      silent = true;
    };

    fuzzel = {
      enable = true;
      settings = {
        main = {
          terminal = "${pkgs.kitty}/bin/kitty";
          width = 60;
          horizontal-pad = 8;
          vertical-pad = 4;
          icon-theme = "Papirus-Dark";
        };
        border.radius = 2;
      };
    };
  };
}
