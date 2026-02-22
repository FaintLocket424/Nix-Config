{
  config,
  pkgs,
  inputs,
  hostname,
  ...
}:
{
  imports = [
    ./theme
  ];

  # NIX SETTINGS (The Engine)
  nix = {
    settings = {
      trusted-users = [ "matthew" ]; # Move 'root' here too if needed
      experimental-features = [
        "nix-command"
        "flakes"
      ];
      auto-optimise-store = true;
      download-buffer-size = 524288000;
    };
    nixPath = [
      "nixpkgs=${inputs.nixpkgs}"
      "home-manager=${inputs.home-manager}"
    ];
    registry.nixpkgs.flake = inputs.nixpkgs;
  };

  # BOOT (Core Essentials)
  boot = {
    loader = {
      efi.canTouchEfiVariables = true;
      systemd-boot.enable = true;
      systemd-boot.configurationLimit = 10;
    };
    initrd.systemd.enable = true;
  };

  # LOCALE (The "Matthew" Standard)
  i18n =
    let
      locale = "en_GB.UTF-8";
    in
    {
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

  console.keyMap = "uk";
  #  time.timeZone = "Europe/London"; # Matches your GB locale

  # CORE SERVICES (Always on)
  services.fstrim.enable = true;
  services.fwupd.enable = true;
  services.dbus.implementation = "broker";
  hardware.enableAllFirmware = true;

  # NETWORKING BASE
  networking.hostName = hostname;
  networking.networkmanager.enable = true;

  # SHELL & TOOLS
  programs.fish.enable = true;
  programs.git.enable = true;

  programs.nix-ld.enable = true;
  programs.nix-ld.libraries = with pkgs; [
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

  system.stateVersion = "25.05";
}
stdlib