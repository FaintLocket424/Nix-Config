{ config, pkgs, ... }:
{
  home.file."ansible/inventory.yml".text = ''
    all:
      children:
        windows_vm:
          hosts:
            192.168.122.50:
          vars:
            ansible_user: "matthew"
            ansible_connection: ssh
            ansible_shell_type: cmd
            ansible_ssh_common_args: "-o StrictHostKeyChecking=no"
  '';
}
