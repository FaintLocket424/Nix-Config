{ config, pkgs, ... }: {
  imports = [
    ./hardware-configuration.nix

    ./virtualisation.nix
  ];

  boot = {
    kernelParams = [
      "amd_pstate=active"
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

  swapDevices = [
    {
      device = "/swapfile";
      size = 8192; # Size in Megabytes
    }
  ];

  services = {
    rc-timing-api = {
      enable = true;
      openFirewall = true;
    };

    sunshine = {
      enable = true;
      autoStart = true;
      capSysAdmin = true;
      openFirewall = true;
    };
  };
}
