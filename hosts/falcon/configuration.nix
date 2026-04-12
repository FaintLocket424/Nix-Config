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
      "nouveau"
    ];
  };

  services.xserver.videoDrivers = [ "nvidia" ];

  hardware.nvidia = {
    modesetting.enable = true;
    powerManagement.enable = true;
    powerManagement.finegrained = false;
    open = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.beta;
  };

  hardware.bluetooth.settings.General = {
    FastConnectable = "true";
    JustWorksRepairing = "always";
  };

  hardware.cpu.amd.updateMicrocode = true;

  hardware.firmware = with pkgs; [
    broadcom-bt-firmware
  ];
}
