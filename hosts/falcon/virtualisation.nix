{ pkgs, ... }: {
  boot.initrd.kernelModules = [
    "vfio_pci"
    "vfio"
    "vfio_iommu_type1"
  ];

  boot.kernelParams = [
    "amd_iommu=on"
    "iommu=pt"

    "vfio-pci.ids=10de:1b06,10de:10ef"
  ];

  virtualisation = {
    docker.enable = true;
    libvirtd = {
      enable = true;

      qemu = {
        package = pkgs.qemu_kvm;
        runAsRoot = true;
        vhostUserPackages = [ pkgs.virtiofsd ];
      };

      hooks.qemu = {
        "looking-glass" = pkgs.writeScript "looking-glass-hook" ''
          #!/bin/sh
          # $1 is the VM name, $2 is the event

          if [ "$2" = "started" ]; then
            chown matthew:kvm /dev/shm/looking-glass
            chmod 660 /dev/shm/looking-glass
          fi
        '';
      };
    };

    spiceUSBRedirection.enable = true;
  };

  systemd.tmpfiles.rules = [
    "f /dev/shm/looking-class 0660 matthew kvm -"
  ];
  programs.virt-manager.enable = true;
}
