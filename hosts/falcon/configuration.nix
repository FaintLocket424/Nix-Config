{ config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix
  ];

  boot.initrd.kernelModules = [
    "vfio_pci"
    "vfio"
    "vfio_iommu_type1"
  ];

  boot = {
    kernelParams = [
      "amd_pstate=active"
      "amd_iommu=on"
      "iommu=pt"

      "vfio-pci.ids=10de:1b06,10de:10ef"
    ];

    blacklistedKernelModules = [
      "noveau"
    ];
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.stable;
  };

  hardware.cpu.amd.updateMicrocode = true;

  environment.systemPackages = with pkgs; [
    broadcom-bt-firmware
  ];
}
