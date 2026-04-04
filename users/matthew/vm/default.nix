{ config, pkgs, ... }:
let
  win11-xml = import ./vm-win11.nix { inherit pkgs config; };
  win11-xml-file = pkgs.writeText "win11-declarative.xml" win11-xml;

  rebuild-win11-vm = pkgs.writeShellScriptBin "rebuild-win11-vm" ''
    echo "Ensuring Looking Glass shmem exists..."
    # FIX: Added a space between 'if' and '['
    if [ ! -f /dev/shm/looking-glass ]; then
      touch /dev/shm/looking-glass
      chmod 660 /dev/shm/looking-glass
      chown matthew:qemu /dev/shm/looking-glass
    fi

    echo "Checking for Windows 11 virtual hard drive..."
    if [ ! -f /var/lib/libvirt/images/win11.qcow2 ]; then
      echo "Creating new 128GB QCOW2 disk..."
      sudo ${pkgs.qemu}/bin/qemu-img create -f qcow2 /var/lib/libvirt/images/win11.qcow2 128G
    fi

    echo "Defining Windows 11 VM in Libvirt..."
    virsh --connect qemu:///system define ${win11-xml-file}

    echo "Done! The VM is ready in virt-manager."
  '';
in
{
  home.packages = [
    rebuild-win11-vm
  ];

  # home.file."VM-Shared/windows-setup.ps1".source = ./windows-setup.ps1;

  home.activation.copyWindowsScript = config.lib.dag.entryAfter [ "writeBoundary" ] ''
    mkdir -p $HOME/VM-Shared

    rm -f $HOME/VM-Shared/windows-setup.ps1

    cp ${./windows-setup.ps1} $HOME/VM-Shared/windows-setup.ps1
    chmod 755 $HOME/VM-Shared/windows-setup.ps1
  '';
}
