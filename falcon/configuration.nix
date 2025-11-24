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

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };
}
