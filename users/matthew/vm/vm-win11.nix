{ pkgs, config, ... }:

''
  <domain type="kvm">
    <name>win11</name>
    <uuid>882430f5-db64-4041-a9d7-2e314503dd27</uuid>
    <memory unit="GiB">16</memory>
    <vcpu placement="static">12</vcpu>

    <memoryBacking>
      <access mode="shared"/>
      <source type="memfd"/>
    </memoryBacking>

    <os>
      <type arch="x86_64" machine="pc-q35-10.1">hvm</type>
      <loader readonly="yes" type="pflash" format="raw">${pkgs.OVMFFull.fd}/FV/OVMF_CODE.fd</loader>
      <nvram template="${pkgs.OVMFFull.fd}/FV/OVMF_VARS.fd" templateFormat="raw" format="raw">/var/lib/libvirt/qemu/nvram/win11_VARS.fd</nvram>
    </os>

    <features>
      <acpi/>
      <apic/>
      <hyperv mode="custom">
        <relaxed state="on"/>
        <vapic state="on"/>
        <spinlocks state="on" retries="8191"/>
        <vpindex state="on"/>
        <runtime state="on"/>
        <synic state="on"/>
        <stimer state="on"/>
        <frequencies state="on"/>
        <tlbflush state="on"/>
        <ipi state="on"/>
        <avic state="on"/>
      </hyperv>
      <vmport state="off"/>
      <smm state="on"/>
    </features>

    <cpu mode="host-passthrough" check="none" migratable="on">
      <topology sockets="1" dies="1" clusters="1" cores="6" threads="2"/>
      <feature policy="require" name="topoext"/>
    </cpu>

    <clock offset="localtime">
      <timer name="rtc" tickpolicy="catchup"/>
      <timer name="pit" tickpolicy="delay"/>
      <timer name="hpet" present="no"/>
      <timer name="hypervclock" present="yes"/>
    </clock>

    <on_poweroff>destroy</on_poweroff>
    <on_reboot>restart</on_reboot>
    <on_crash>destroy</on_crash>

    <devices>
      <emulator>${pkgs.qemu_kvm}/bin/qemu-system-x86_64</emulator>

      <disk type="file" device="disk">
        <driver name="qemu" type="qcow2" cache="none" io="native" discard="unmap"/>
        <source file="/var/lib/libvirt/images/win11.qcow2"/>
        <target dev="sda" bus="sata"/>
        <boot order="1"/>
      </disk>

      <disk type="file" device="cdrom">
        <driver name="qemu" type="raw"/>
        <source file="${pkgs.virtio-win.src}"/>
        <target dev="sdb" bus="sata"/>
        <readonly/>
      </disk>

      <filesystem type="mount" accessmode="passthrough">
        <driver type="virtiofs"/>
        <source dir="${config.home.homeDirectory}/VM-Shared"/>
        <target dir="host-share"/>
      </filesystem>

      <controller type="usb" model="qemu-xhci" ports="15"/>

      <interface type="network">
        <mac address="52:54:00:36:d3:9d"/>
        <source network="default"/>
        <model type="e1000e"/>
      </interface>

      <input type="mouse" bus="ps2"/>
      <input type="mouse" bus="virtio"/>
      <input type="keyboard" bus="ps2"/>
      <input type="keyboard" bus="virtio"/>

      <graphics type="spice" port="5900" autoport="no" listen="127.0.0.1">
        <listen type="address" address="127.0.0.1"/>
        <image compression="off"/>
        <clipboard copypaste="yes"/>
      </graphics>

      <video>
        <model type="none"/>
      </video>

      <hostdev mode="subsystem" type="pci" managed="yes">
        <source>
          <address domain="0x0000" bus="0x09" slot="0x00" function="0x0"/>
        </source>
      </hostdev>

      <hostdev mode="subsystem" type="pci" managed="yes">
        <source>
          <address domain="0x0000" bus="0x09" slot="0x00" function="0x1"/>
        </source>
      </hostdev>

      <hostdev mode="subsystem" type="pci" managed="yes">
        <source>
          <address domain="0x0000" bus="0x0c" slot="0x00" function="0x3"/>
        </source>
      </hostdev>

      <shmem name="looking-glass">
        <model type="ivshmem-plain"/>
        <size unit="M">128</size>
      </shmem>

      <controller type="virtio-serial" index="0"/>

      <channel type="spicevmc">
        <target type="virtio" name="com.redhat.spice.0"/>
      </channel>
    </devices>
  </domain>
''
