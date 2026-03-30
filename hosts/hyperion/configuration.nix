{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  boot.kernelParams = [
    "i915.force_probe=a7a1"
    "intel_pstate=active" # Better cpu power management
    "i915.enable_fbc=1" # Intel frame buffer compression
    "i915.enable_psr=1" # Intel Panel self refresh for better battery
    "i915.enable_guc=3" # Enables advanced Intel firmware (GuC/HuC) for better video/power management
  ];

  hardware = {
    graphics.extraPackages = with pkgs;[
      intel-media-driver # Fast modern Intel media driver
      intel-vaapi-driver
      intel-compute-runtime
      vpl-gpu-rt
      libva-vdpau-driver
      libvdpau-va-gl
      vulkan-loader
    ];

    cpu.intel.updateMicrocode = true;
  };

  environment.sessionVariables = {
    LIBVA_DRIVER_NAME = "iHD";
  };

  services.power-profiles-daemon.enable = true;

  services.udev.extraHwdb = ''
    evdev:name:Intel HID events:*
     KEYBOARD_KEY_08=unknown
  '';

  services.ollama.environmentVariables = {
    GGML_VK_DISABLE_INTEGER_DOT_PRODUCT = "1";
  };
}
