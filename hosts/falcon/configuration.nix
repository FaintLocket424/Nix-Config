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

  hardware.firmware = [
    (pkgs.runCommand "broadcom-bt-firmware" { } ''
      mkdir -p $out/lib/firmware/brcm
      # Download the specific firmware file from the well-known winterheart repository
      cp ${pkgs.fetchurl {
        url = "https://github.com/winterheart/broadcom-bt-firmware/raw/master/brcm/BCM20702A1-0a5c-21ec.hcd";
        sha256 = "sha256-RIn4857O6kZ2D11V7lP7l6f9i783Eon4hE8V7R6a7V8=";
      }} $out/lib/firmware/brcm/BCM20702A1-0a5c-21ec.hcd
    '')
  ];
}
