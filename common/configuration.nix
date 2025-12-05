{
  config,
  pkgs,
  inputs,
  hostname,
  ...
}: {
  imports = [
    ./theme
    ./gnome.nix
  ];

  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 20;
      timeout = 0;
    };

    initrd.systemd.enable = true;
  };

  hardware = {
#    steam-hardware.enable = true;
    xone.enable = true;
    enableAllFirmware = true;

    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings = {
        General = {
          Experimental = true;
          FastConnectable = true;
        };
        Policy = {
          AutoEnable = true;
        };
      };
    };

    brillo.enable = true;
    keyboard.qmk.enable = true;

    graphics = {
      enable = true;
      enable32Bit = true;
    };
  };

  virtualisation = {
    docker.enable = true;

    libvirtd = {
      enable = true;

      qemu = {
        swtpm.enable = true;
        ovmf.packages = [ pkgs.OVMFFull.fd ];
      };
    };

    spiceUSBRedirection.enable = true;
  };

  nix = {
    settings = {
      trusted-users = [ "matthew" ];

      # Enable flakes and new 'nix' command
      experimental-features = [
        "nix-command"
        "flakes"
      ];

      auto-optimise-store = true;
      download-buffer-size = 524288000; # 500 MiB
    };

    nixPath = [
      "nixpkgs=${inputs.nixpkgs}"
      "home-manager=${inputs.home-manager}"
    ];

    registry.nixpkgs.flake = inputs.nixpkgs;
  };

  programs = {
    git.enable = true;
    fish.enable = true;

    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      localNetworkGameTransfers.openFirewall = true; # Open ports in the firewall for Steam Local Network Game Transfers
      gamescopeSession.enable = true;
      extraCompatPackages = [
        pkgs.proton-ge-bin
      ];
    };

#    gamescope.enable = true;

#    gamemode = {
#      enable = true;
#      enableRenice = true;
#      settings.general.renice = 10;
#    };

  };

#  security.pam.services.login.enableGnomeKeyring = true;

  services = {
    joycond.enable = true;
    blueman.enable = true;
    udisks2.enable = true;

#    gnome.gnome-keyring.enable = true;

    dbus.implementation = "broker";

    printing = {
      enable = true;
      drivers = [
        pkgs.gutenprint
        pkgs.canon-cups-ufr2
      ];
    };

    avahi = {
      enable = true;
      nssmdns4 = true;
      openFirewall = true;
    };

    scx = {
      enable = true;
      scheduler = "scx_lavd";
      extraArgs = [
        "--autopower"
        "--verbose"
      ];
    };

    automatic-timezoned.enable = true;
    fstrim.enable = true;
    displayManager.gdm.enable = true;

    xserver = {
      enable = true;
      xkb.layout = "gb";
      excludePackages = [ pkgs.xterm ];
    };

    fwupd.enable = true;

    pulseaudio.enable = false;
    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };
  };

  networking = {
    networkmanager = {
      enable = true;
    };

    firewall = {
      allowedTCPPorts = [ /*8384*/ 22000 ];
      allowedUDPPorts = [ 22000 21027 ];
      checkReversePath = false;
    };
  };

  i18n = let
    locale = "en_GB.UTF-8";
  in {
    defaultLocale = locale;
    extraLocaleSettings = {
      LC_ADDRESS = locale;
      LC_IDENTIFICATION = locale;
      LC_MEASUREMENT = locale;
      LC_MONETARY = locale;
      LC_NAME = locale;
      LC_NUMERIC = locale;
      LC_PAPER = locale;
      LC_TELEPHONE = locale;
    };
  };

  fonts.packages = with pkgs; [
    nerd-fonts.symbols-only
    corefonts
    vista-fonts
    google-fonts
  ];

  console.keyMap = "uk";

# Configure your system-wide user settings (groups, etc)
  users = {
    mutableUsers = false;
    users = {
      root.hashedPassword = "!";
      matthew = {
        description = "Matthew Peters";
        hashedPassword = "$6$QFNCuGDTRlfYTgyI$94qSvsOwnDEDQsNFgMx/.wQLsoOk3JhUBp4oTqYagKyzXuBn2JJG.r/Hu0fg4QZJC6sHSps2U0Tj0ME7YWyhP0";
        isNormalUser = true;
        extraGroups = [ "wheel" "networkmanager" "video" "dialout" "docker" "libvirtd" "kvm" ];

        shell = pkgs.fish;
      };
    };
  };

  environment.systemPackages = with pkgs; [
    wireguard-tools
    protonvpn-gui
    dnsmasq
    phodav
  ];

  # Set Hostname
  networking.hostName = hostname;

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}