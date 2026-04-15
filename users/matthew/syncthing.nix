{ pkgs, config, ... }: {
  services.syncthing = {
    enable = true;

    # overrideFolders = true;
    overrideDevices = true;

    # settings.folders = { };

    settings.devices = {
      "Falcon" = { id = "NQWWU2G-FMO27SD-BD4P3KO-RNJTTUS-52XVHGA-AKSFE76-I5HU6SM-2RDTMAH"; };
      #   "Hyperion" = { id = ""; };
    };
  };
}
