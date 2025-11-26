{
  config,
  pkgs,
  lib,
  inputs,
  hostname,
  ...
}: {
  imports = [
    # nixos-generate-config
    ./hardware-configuration.nix
  ];

  boot.blacklistedKernelModules = [
    "nouveau"
  ];

  services.xserver.videoDrivers = [ "nvidia" ];

  boot.kernelModules = [
    "nvidia"
  ];

  hardware.graphics.extraPackages = with pkgs; [
    nvidia-vaapi-driver
  ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = false;
    nvidiaSettings = true;
#    package = config.boot.kernelPackages.nvidiaPackages.beta;
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "580.105.08";
      sha256_64bit = "sha256-2cboGIZy8+t03QTPpp3VhHn6HQFiyMKMjRdiV2MpNHU=";
      sha256_aarch64 = null;
      openSha256 = "sha256-FGmMt3ShQrw4q6wsk8DSvm96ie5yELoDFYinSlGZcwQ=";
      settingsSha256 = "sha256-YvzWO1U3am4Nt5cQ+b5IJ23yeWx5ud1HCu1U0KoojLY=";
      persistencedSha256 = "sha256-qh8pKGxUjEimCgwH7q91IV7wdPyV5v5dc5/K/IcbruI=";
    };
  };
}
