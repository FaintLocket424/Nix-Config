{
  config,
  pkgs,
  inputs,
  hostname,
  ...
}: {
  imports = [
    # nixos-generate-config
    ./hardware-configuration.nix
  ];

  boot.blacklistedKernelModules = [
    "nvidia"
    "nvidiafb"
    "nvidia-drm"
    "nvidia-uvm"
    "nvidia-modeset"
  ];

  services.xserver.videoDrivers = [ "nouveau" ];

#  services.xserver.videoDrivers = [ "nvidia" ];

#  boot.kernelModules = [
#    "nvidia"
#  ];

#  hardware.graphics.extraPackages = with pkgs; [
#    nvidia-vaapi-driver
#  ];

#  hardware.nvidia = {
#    modesetting.enable = true;
#    powerManagement.enable = true;
#    powerManagement.finegrained = false;
#    open = true;
#    nvidiaSettings = true;
#    package = config.boot.kernelPackages.nvidiaPackages.production;
#  };
}
