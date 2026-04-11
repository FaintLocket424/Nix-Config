{ ... }: {
  users.users.matthew = {
    isNormalUser = true;
    description = "Matthew Peters";
    extraGroups = [ "networkmanager" "wheel" "dialout" "plugdev" "video" "input" "audio" "render" "libvirtd" "kvm" "docker" "adbusers" "uinput" ];

    hashedPassword = "$6$QFNCuGDTRlfYTgyI$94qSvsOwnDEDQsNFgMx/.wQLsoOk3JhUBp4oTqYagKyzXuBn2JJG.r/Hu0fg4QZJC6sHSps2U0Tj0ME7YWyhP0";
  };

  home-manager.users.matthew = import ./home.nix;
}
