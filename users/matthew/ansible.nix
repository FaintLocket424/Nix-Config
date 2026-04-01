{ config, pkgs, ... }:
{
  home.file."ansible/inventory.yml".text = ''
    all:
      children:
        windows_vm:
          hosts:
            192.168.122.240:
          vars:
            ansible_user: "matthew"
            ansible_connection: ssh
            ansible_shell_type: cmd
            ansible_ssh_common_args: "-o StrictHostKeyChecking=no"
  '';

  home.file."ansible/setup-windows.yml".text = ''
    - name: Configure Windows 11 VM
      hosts: windows_vm
      tasks:
        - name: Create a new directory on the C: Drive
          win_file:
            path: C:\Games
            state: directory

        - name: Install Firefox and Steam using winget
          win_shell: |
            winget install Mozilla.Firefox --accept-source-agreements --accept-package-agreements
            winget install Valve.Steam --accept-source-agreements --accept-package-agreements

        - name: Disable Windows Telemetry via Registry
          win_regedit:
            path: HKLM:\SOFTWARE\Policies\Microsoft\Windows\DataCollection
            name: AllowTelemetry
            data: 0
            type: dword
  '';
}
