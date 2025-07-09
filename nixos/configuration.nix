# System configuration file
{
  pkgs,
  stable,
  options,
  config,
  inputs,
  ...
}: {
  imports = [
    # nixos-generate-config
    ./hardware-configuration.nix
    ./theme
  ];

  boot = {
    extraModulePackages = [config.boot.kernelPackages.ddcci-driver];
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
      timeout = 0;
    };

    kernelParams = [
      "workqueue.power_efficient=true"
      "i915.force_probe=a7a1"
    ];

    initrd = {
      systemd.enable = true;
    };
  };

  hardware = {
    enableAllFirmware = true;
    bluetooth = {
      enable = true;
      settings.General.Disable = "Headset";
    };
    brillo.enable = true;
    keyboard.qmk.enable = true;

    graphics = {
      enable = true;
      enable32Bit = true;
#      driSupport = true;
#      driSupport32Bit = true;

      extraPackages = with pkgs; [
        intel-media-driver
        vpl-gpu-rt
      ];
    };
  };
  
  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  nix = {
    settings = {
      trusted-users = ["matthew"];

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

  virtualisation = {
      libvirtd.enable = true;
      libvirtd.qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        swtpm.enable = true;
        ovmf = {
          enable = true;
          packages = [(pkgs.OVMFFull.override {
            secureBoot = true;
            tpmSupport = true;
          })];
        };
      };

#      docker = {
#        enable = true;
#        autoPrune.enable = true;
#      };
    };

  programs = {
    hyprland = {
      enable = true;
      withUWSM = true;
      xwayland.enable = true;
    };

    virt-manager.enable = true;

    steam = {
      enable = true;
      remotePlay.openFirewall = true; # Open ports in the firewall for Steam Remote Play
      dedicatedServer.openFirewall = true; # Open ports in the firewall for Source Dedicated Server
      gamescopeSession.enable = true;
      extraCompatPackages = [
        pkgs.proton-ge-bin
      ];
    };

    gamescope = {
      enable = true;
    };

    gamemode = {
      enable = true;
      enableRenice = true;
      settings.general.renice = 10;
    };
  };

  services = {
    dbus.implementation = "broker";

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

    xserver = {
      enable = true;
      xkb = {
        layout = "gb";
        variant = "";
      };
      displayManager.gdm.enable = true;
      excludePackages = [ pkgs.xterm ];
    };

    fwupd.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      jack.enable = true;
    };

    tlp = {
      enable = true;
      settings = {
        CPU_SCALING_GOVERNOR_ON_AC = "performance";
        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
        PLATFORM_PROFILE_ON_AC = "performance";
        PLATFORM_PROFILE_ON_BAT = "low-power";
      };
    };
  };

  xdg.portal = {
    enable = true;
    extraPortals = builtins.attrValues {
      inherit
        (pkgs)
        xdg-desktop-portal-hyprland
        xdg-desktop-portal-gtk
        ;
    };
    config.common.default = "*";
  };

  # Set Hostname
  networking = {
    hostName = "hyperion";
    networkmanager = {
      enable = true;
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

  services.gnome.gnome-keyring.enable = true;

  programs = {
    git.enable = true;
    fish.enable = true;
  };

  console.keyMap = "uk";

  # Configure your system-wide user settings (groups, etc)
  users = {
    mutableUsers = true;
    users = {
      root.hashedPassword = "!";
      matthew = {
        description = "Matthew Peters";
        hashedPassword = "$6$jeYZ3.QYh.Hqa6pR$wbdeB2vysnjf5nNglU8Eb7LyQ.hdrGhL5wPGf4VnECdW.dmkgjrN/flAODApiqo/tSuUYtqgDZoyJ/4sYUs.d1";
        isNormalUser = true;
        extraGroups = ["wheel" "networkmanager" "video" "libvirtd"];

        shell = pkgs.fish;
      };
    };
  };

  environment.systemPackages = builtins.attrValues {
    inherit
      (pkgs)
    ;
  };

  # https://nixos.wiki/wiki/FAQ/When_do_I_update_stateVersion
  system.stateVersion = "25.05";
}
