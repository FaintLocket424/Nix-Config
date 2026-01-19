{
  config,
  pkgs,
  inputs,
  hostname,
  ...
}:
{
  imports = [
    # nixos-generate-config --root .
    ./hardware-configuration.nix
  ];

  boot = {
    #    loader.systemd-boot.enable = true;
    extraModulePackages = [ config.boot.kernelPackages.ddcci-driver ];

    kernelParams = [
      "workqueue.power_efficient=true"
      "i915.force_probe=a7a1"
    ];
  };

  hardware.graphics.extraPackages = with pkgs; [
    intel-media-driver
    vpl-gpu-rt
    libvdpau-va-gl
  ];

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  services = {
    #    tlp = {
    #      enable = true;
    #      settings = {
    #        CPU_SCALING_GOVERNOR_ON_AC = "performance";
    #        CPU_SCALING_GOVERNOR_ON_BAT = "powersave";
    #        PLATFORM_PROFILE_ON_AC = "performance";
    #        PLATFORM_PROFILE_ON_BAT = "low-power";
    #      };
    #    };
  };
}
