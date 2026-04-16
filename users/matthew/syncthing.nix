{ config, ... }: {
  services.syncthing = {
    enable = true;
    overrideFolders = true;
    overrideDevices = true;

    settings = {
      openDefaultPorts = true;
      options.localAnnounceEnabled = true;
      options.urAccepted = -1;

      folders = {
        "Dolphin Emulator Wii Saves" = {
          path = "${config.home.homeDirectory}/.local/share/dolphin-emu/Wii/title";
          id = "dolphin-emu-wii-saves";
          devices = [ "Falcon" "Hyperion" ];
        };

        "Dolphin Emulator Texture Packs" = {
          path = "${config.home.homeDirectory}/.local/share/dolphin-emu/Load/Textures";
          id = "dolphin-emu-load-textures";
          devices = [ "Falcon" "Hyperion" ];
        };
      };

      devices = {
        "Falcon" = { id = "NQWWU2G-FMO27SD-BD4P3KO-RNJTTUS-52XVHGA-AKSFE76-I5HU6SM-2RDTMAH"; };
        "Hyperion" = { id = "T66QOX3-NADLDBH-UBAUUVR-U53YNCA-2GVR4JI-MS3RF4U-WWHHBGZ-YJYWWAU"; };
      };
    };
  };
}
