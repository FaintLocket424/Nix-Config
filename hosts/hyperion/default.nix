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

  myFeatures = {
    desktop.gnome.enable = true;
    desktop.hyprland.enable = true;
    gaming.enable = true;
    connectivity.enable = true;
    allUsers.enable = true;
  };

  boot = {
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

  hardware.brillo.enable = true;

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  services.udev.extraHwdb = ''
    # Disable airplane mode trigger on HP x360 tilt/lid
    evdev:name:Intel HID events:*
     KEYBOARD_KEY_08=unknown
  '';
}
