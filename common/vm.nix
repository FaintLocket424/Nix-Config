{ pkgs, ... }:
{
  programs.dconf.enable = true;

  users.users.matthew.extraGroups = [
    "libvirtd"
    "kvm"
    "docker"
    "vboxusers"
  ];

  environment.systemPackages = with pkgs; [
    virt-manager
    virt-viewer
    spice
    spice-gtk
    spice-protocol
    virtio-win
    win-spice
    adwaita-icon-theme
  ];

  virtualisation = {
    docker.enable = true;

    libvirtd = {
      enable = true;
      qemu = {
        swtpm.enable = true;
      };
    };

    #    virtualbox.host.enable = true;
    #    virtualbox.host.enableExtensionPack = true;

    spiceUSBRedirection.enable = true;
  };

  services.spice-vdagentd.enable = true;
}
