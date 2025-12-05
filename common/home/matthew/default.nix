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
      protonup-ng # IDK - Something for steam proton.
      dolphin-emu # FOSS for running Wii and Gamecube games
      scrcpy # Android screen mirroring
      zotero # Research reference manager
      godot # FOSS game engine
      arduino-ide # IDE for working with Arduino hardware
      mesa-demos
      vulkan-tools
      clinfo
      libva-utils
      vdpauinfo
      distrobox
      gnome-boxes
      quickemu
      unityhub

#      wineWowPackages.stable
#      wine
      winetricks
      wineWowPackages.waylandFull
      wineWowPackages.fonts
      (bottles.override {
        removeWarningPopup = true;
      })

      # Controller libs
      xwiimote # Driver for wiimotes
      evtest # CLI program for
      evtest-qt
      antimicrox
      linuxConsoleTools
      jstest-gtk


      # Runtimes and Compilers
      (lib.hiPrio jdk21) # Dev Kit and runtime for Java 21
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


      # Code Editors
      jetbrains-toolbox
#      jetbrains.idea-ultimate
#      jetbrains.pycharm-professional
#      jetbrains.goland
#      jetbrains.webstorm
#      (
#      let
#        extra-path = with pkgs; [
#          dotnetCorePackages.sdk_6_0
#          dotnetPackages.Nuget
#          mono
#          msbuild
#        ];
#
#        extra-lib = with pkgs; [
#
#        ];
#
#        rider = pkgs.jetbrains.rider.overrideAttrs (attrs: {
#          postInstall = ''
#            # Wrap rider with extra tools and libraries
#            mv $out/bin/rider $out/bin/.rider-toolless
#            makeWrapper $out/bin/.rider-toolless $out/bin/rider \
#              --argv0 rider \
#              --prefix PATH : "${lib.makeBinPath extra-path}" \
#              --prefix LD_LIBRARY_PATH : "${lib.makeLibraryPath extra-lib}"
#
#            # Making Unity Rider plugin work!
#            # The plugin expects the binary to be at /rider/bin/rider,
#            # with bundled files at /rider/
#            # It does this by going up two directories from the binary path
#            # Our rider binary is at $out/bin/rider, so we need to link $out/rider/ to $out/
#            shopt -s extglob
#            ln -s $out/rider/!(bin) $out/
#            shopt -u extglob
#          '' + attrs.postInstall or "";
#        });
#      in
#        rider
#      )
      vscode
    ]) ++ (with pkgs-unstable; [

    ]);
  };

  services = {
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

    chromium = {
      enable = true;
      package = pkgs.brave;
      nativeMessagingHosts = with pkgs; [
        gnome-browser-connector
      ];
    };

    ssh = {
      enable = true;

      matchBlocks = {
        "*" = {
          addKeysToAgent = "yes";
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
