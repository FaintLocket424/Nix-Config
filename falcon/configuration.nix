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
    open = true;
    nvidiaSettings = true;
#    package = config.boot.kernelPackages.nvidiaPackages.beta;
    package = config.boot.kernelPackages.nvidiaPackages.mkDriver {
      version = "580.95.05";
      sha256_64bit = "";
      settingsSha256 = "";
      persistencedSha256 = lib.fakeSha256;
    };
  };
}
