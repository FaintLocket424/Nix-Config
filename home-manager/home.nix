{
  pkgs,
  config,
  ...
}: {
  nixpkgs.config = {
    allowUnfree = true;
    system = "x86_64-linux";
  };

  stylix = {
    targets = {
      qt.platform = "qtct";
#      waybar.font = "sansSerif";
    };

    iconTheme = {
      enable = true;
      dark = "Papirus-Dark";
      light = "Papirus-Light";
      package = pkgs.papirus-icon-theme;
    };
  };

  fonts.fontconfig.enable = true;

  imports = [
    ./system
    ./terminal
  ];

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
      git-credential-manager

      # Default Applications
      ## Web Browsers
      firefox
      brave
      chromium
    
      ## Image Viewer
      xviewer
	  photoflare

      ## PDF Reader
      evince

      ## Media Player
      celluloid

      ## File Browser
      nemo-with-extensions

      ## Text Editor
      notepad-next

      ## ISO Writer
      popsicle

      ## Virtual Machines
  #    gnome-boxes
  #    swtpm
  #    spice-gtk
    
      ## QT Fixes/packages
      kdePackages.qtwayland
      kdePackages.kwayland
      kdePackages.kservice
      libsForQt5.qtwayland
    
      ## Remote Desktop
      parsec-bin

      ## CAD and 3D Printing
      bambu-studio
      freecad

      ## Disk Usage Analyser
      # qdirstat
    
    # File Sync
#    syncthing

#      resilio-sync

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

      networkmanagerapplet
    
      # Editors
      audacity
      obs-studio
      obsidian
      ## Code Editors
      jetbrains.idea-ultimate
      jetbrains.pycharm-professional
      jetbrains.goland
      jetbrains.webstorm
	  # android-studio-full
    
      # Social
      zapzap
      vesktop

      # Gaming
      mangohud
      protonup
      ## Minecraft
      gdlauncher-carbon
      modrinth-app
      jdk21
      ## Emulators
      dolphin-emu
	  
      gradle

      (hiPrio python313)
      python312

      libressl

      insomnia
      postman

      xwiimote
      geteduroam
      scrcpy
	  singularity
	  usbutils
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
    direnv = {
      enable = true;
      nix-direnv.enable = true;
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

  home.file."${config.xdg.configHome}/libvirt/qemu.conf" = {
      source = ./qemu.conf;
  };
  
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
