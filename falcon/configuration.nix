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
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };
}
