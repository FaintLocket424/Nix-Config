{
  pkgs,
  config,
  ...
}:
{
  nixpkgs.config = {
    allowUnfree = true;
    system = "x86_64-linux";
  };

  imports = [
    ./stylix.nix
    ./git.nix
    ./shell.nix
    ./cli_utils.nix
    ./system
  ];

  programs.btop.enable = true;

  fonts.fontconfig.enable = true;

  home = {
    keyboard = "uk";
    username = "matthew";
    homeDirectory = "/home/matthew";

    sessionVariables = {
        STEAM_EXTRA_COMPAT_TOOLS_PATHS =
            "\${HOME}/.steam/root/compatibilitytools.d";
    };

    packages = with pkgs; [
      # System Management
      selectdefaultapplication
      bleachbit
      via
      pwvucontrol
      networkmanagerapplet

      brave # Web Browser
      xviewer # Image Viewer
	    photoflare # Image Editor like Paint.NET
      celluloid # Media Player
      nemo-with-extensions # File Browser
      notepad-next # Text Editor
      popsicle # ISO Writer
      parsec-bin # Remote Desktop
      bambu-studio # 3D Printing Slicer for Bambu Labs Printers
      freecad # FOSS 3D Modelling Software
      obs-studio # FOSS for Screen Recording and Streaming
      obsidian # FOSS for Markdown Note-taking
      zapzap # Whatsapp desktop app
      vesktop # Lightweight linux discord client
      mangohud # IDK
      protonup # IDK - Something for steam proton.
      gdlauncher-carbon # FOSS for launching Minecraft
      modrinth-app # FOSS for launching Minecraft
#      dolphin-emu # FOSS for running Wii and Gamecube games
      libressl # IDK
      geteduroam # Software for getting on eduroam
      scrcpy # Android screen mirroring
	    gnumake # Building make
	    gcc # GNU Compiler Collection
	    pandoc # Document compiler
	    texliveFull # LaTeX
	    zotero # Research reference manager
	    godot # FOSS game engine

      # Controller libs
      xwiimote # Driver for wiimotes
      evtest # CLI program for
      evtest-qt
      antimicrox
      linuxConsoleTools
      jstest-gtk

      # Runtimes
      jdk21 # Dev Kit and runtime for Java 21
      gradle # Build tool for Java and Kotlin
      (hiPrio python314) # Python 3.14
      python313 # Python 3.13
      python312 # Python 3.12

      # QT Fixes/packages
      kdePackages.qtwayland
      kdePackages.kwayland
      kdePackages.kservice
      libsForQt5.qtwayland

      # LibreOffice and Dictionaries
      libreoffice-qt6-fresh
      hunspell
      hunspellDicts.en_GB-ise
      aspell
      aspellDicts.en

      # Fonts
      nerd-fonts.symbols-only
      corefonts
      vistafonts
      open-sans
      jetbrains-mono

      # Code Editors
      jetbrains.idea-ultimate
      jetbrains.pycharm-professional
      jetbrains.goland
      jetbrains.webstorm
      vscode
    ];
  };

  services = {
    polkit-gnome.enable = true;
    hyprpaper.enable = true;
    playerctld.enable = true;

    udiskie = {
      enable = true;
      settings = {
        program_options = {
          # replace with your favorite file manager
          file_manager = "${pkgs.nemo-with-extensions}/bin/nemo";
        };
      };
    };

    mako = {
      enable = true;
      settings = {
        default-timeout = "5000";
        border-radius = "5";
        icons = "true";
        max-icon-size = "96";
        layer = "top";
      };
    };

    blueman-applet.enable = true;

    gnome-keyring = {
     enable = true;
     components = [
       "pkcs11"
       "secrets"
       "ssh"
     ];
    };

    syncthing = {
      enable = true;
      settings = {
        openDefaultPorts = true;
        options.localAnnounceEnabled = true;
        options.urAccepted = -1;
        devices = {
          falcon = {
            name = "Falcon";
            id = "MYFAGZC-Z6HAPNZ-4Y66OCM-JBIXCWG-IB42EPE-YJOKBC3-QCO6LH5-TOPPGA5";
          };
          s25 = {
            name = "S25";
            id = "RJYXKAI-CMTCOMD-XPLK5PG-4DGG3FB-SWFD6TL-B7WQDZJ-EKC4B2P-LRXNVA2";
          };
        };
        folders = {
          programming = {
            enable = true;
            devices = ["falcon"];
            id = "programming";
            label = "Programming";
            path = "~/programming";
          };
          sharedDocuments = {
            enable = true;
            devices = ["falcon"];
            id = "sharedDocuments";
            label = "Shared Documents";
            path = "~/sharedDocuments";
          };
        };
      };
      overrideDevices = true;
      overrideFolders = true;
    };
  };

  programs = {
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

    kitty = {
      enable = true;
      settings = {
        font_features = "CommitMonoNF-Regular +calt +ss05 +ss04 +ss03 +ss02 +ss01";
        window_padding_width = 0;
        "modify_font cell_height" = "120%";
      };
    };
  };

#  home.file."${config.xdg.configHome}/libvirt/qemu.conf" = {
#      source = ./qemu.conf;
#  };
  
#  home.file.".local/bin/extractMojangJar.sh" = {
#    source = ./scripts/extractMojangJar.sh;
#    executable = true;
#  };



  # Enable home-manager and git
  programs.home-manager.enable = true;
  programs.git.enable = true;

  # Nicely reload system units when changing configs
  systemd.user.startServices = "sd-switch";

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  home.stateVersion = "25.05";
}
