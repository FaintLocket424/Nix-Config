{ pkgs, config, ... }: {
  services.syncthing = {
    enable = true;

    # overrideFolders = true;
    # overrideDevices = true;

    # settings.folders = { };

    # settings.devices = {
    #   "desktop" = { id = ""; };
    #   "laptop" = { id = ""; };
    # };
  };
}
