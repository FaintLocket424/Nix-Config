{ pkgs, hostname, lib, inputs, ... }:
let
  locale = "en_GB.UTF-8";

  custom-sddm-theme = pkgs.sddm-astronaut.override {
    embeddedTheme = "black_hole";
  };
in
{
  # --- Boot and Kernel ---
  boot = {
    loader = {
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 10;
      efi.canTouchEfiVariables = true;
      timeout = 5;
    };
    initrd.systemd.enable = true;
    kernel.sysctl = {
      "net.ipv4.ip_unprivileged_port_start" = 443;
    };
    kernelPackages = pkgs.linuxPackages_latest;
    kernelParams = [
      "quiet"
      "splash"
    ];
    kernelModules = [
      "ntsync"
    ];
  };

  # --- Hardware ---
  hardware = {
    #    enableAllFirmware = true;
    enableRedistributableFirmware = true;
    graphics.enable = true;
    graphics.enable32Bit = true;
    bluetooth = {
      enable = true;
      powerOnBoot = true;
      settings.General.Experimental = true;
    };
    xone.enable = true;

    logitech.wireless = {
      enable = true;
      enableGraphical = true;
    };
  };

  # --- Networking ---

  networking = {
    hostName = hostname;
    useDHCP = lib.mkDefault true;
    networkmanager = {
      enable = true;
      plugins = [ pkgs.networkmanager-openconnect ];
    };
  };

  # --- Localisation and Input ---
  time.timeZone = "Europe/London";
  i18n = {
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
      LC_TIME = locale;
    };
  };
  console.keyMap = "uk";

  # --- Services ---

  services = {
    xserver = {
      enable = true;
      excludePackages = [ pkgs.xterm ];
      xkb = {
        layout = "gb";
        variant = "";
      };
    };

    resolved.enable = true;
    fstrim.enable = true;
    fwupd.enable = true;
    dbus.implementation = "broker";
    udisks2.enable = true;
    devmon.enable = true;
    tailscale.enable = true;
    openssh.enable = true;
    joycond.enable = true;

    avahi = {
      enable = true;
      nssmdns4 = true;
      publish = {
        enable = true;
        addresses = true;
        domain = true;
        hinfo = true;
        userServices = true;
        workstation = true;
      };
    };

    displayManager.sddm = {
      enable = true;
      wayland.enable = true;
      theme = "sddm-astronaut-theme";
      extraPackages = [ custom-sddm-theme ];
    };
    desktopManager.plasma6.enable = true;

    pipewire = {
      enable = true;
      alsa.enable = true;
      alsa.support32Bit = true;
      pulse.enable = true;
      wireplumber.enable = true;
    };

    printing = {
      enable = true;
      drivers = with pkgs; [
        gutenprint
        canon-cups-ufr2
      ];
    };

    udev.packages = with pkgs; [
      platformio-core.udev
      openocd
    ];
  };

  security.rtkit.enable = true;

  documentation.man.generateCaches = false;

  # --- Desktop Apps & Programs
  programs = {
    hyprland = {
      enable = true;
      xwayland.enable = true;
    };
    gamemode.enable = true;

    steam = {
      enable = true;
      remotePlay.openFirewall = true;
      dedicatedServer.openFirewall = true;
      gamescopeSession.enable = true;
      localNetworkGameTransfers.openFirewall = true;
      extraCompatPackages = [ pkgs.proton-ge-bin ];
      protontricks.enable = true;
    };

    nix-ld = {
      enable = true;
      libraries = with pkgs; [
        stdenv.cc.cc
        stdenv.cc.cc.lib
        zlib
        fuse3
        icu
        nss
        openssl
        curl
        expat
      ];
    };

    ssh.askPassword = lib.mkForce "";
  };

  virtualisation.libvirtd = {
    enable = true;

    qemu = {
      swtpm.enable = true;
      # ovmf.packages = [ pkgs.OVMFFull.fd ];
    };
  };

  virtualisation.spiceUSBRedirection.enable = true;
  programs.virt-manager.enable = true;

  # --- Fonts ---
  fonts = {
    packages = with pkgs; [
      noto-fonts
      noto-fonts-cjk-sans
      noto-fonts-color-emoji
      liberation_ttf

      corefonts
      vista-fonts
      google-fonts

      nerd-fonts.jetbrains-mono
      nerd-fonts.fira-code
      nerd-fonts.symbols-only
    ];

    fontconfig.defaultFonts = {
      sansSerif = [ "Noto Sans" "Arial" ];
      serif = [ "Noto Serif" "Times New Roman" ];
      monospace = [ "JetBrains Mono" "Consolas" ];
    };
  };

  # --- System Management and Nix ---
  nix = {
    settings = {
      trusted-users = [ "matthew" ];
      experimental-features = [ "nix-command" "flakes" ];
      auto-optimise-store = true;
      download-buffer-size = 524288000;
    };
    nixPath = [ "nixpkgs=${inputs.nixpkgs}" ];
    registry.nixpkgs.flake = inputs.nixpkgs;
    gc = {
      automatic = true;
      dates = "weekly";
      options = "--delete-older-than 14d";
    };
  };

  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    nano
    vulkan-tools
    protonvpn-gui
    custom-sddm-theme
    dnsmasq
    phodav
  ];

  environment.etc."libinput/local-overrides.quirks".text = ''
    [Logitech G502 Remove High Res Scrolling]
    MatchName=*
    AttrEventCode=-REL_WHEEL_HI_RES;-REL_HWHEEL_HI_RES;
  '';

  environment.sessionVariables.NIXOS_OZONE_WL = "1";

  system.stateVersion = "25.11";
}
