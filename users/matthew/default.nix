{ config, pkgs, ... }: {
  users.users.matthew = {
    isNormalUser = true;
    description = "Matthew Peters";
    extraGroups = [ "networkmanager" "wheel" "dialout" "video" "input" "audio" "render" "libvirtd" "kvm" ];

    hashedPassword = "$6$QFNCuGDTRlfYTgyI$94qSvsOwnDEDQsNFgMx/.wQLsoOk3JhUBp4oTqYagKyzXuBn2JJG.r/Hu0fg4QZJC6sHSps2U0Tj0ME7YWyhP0";
  };

  home-manager.users.matthew = import ./home.nix;
}
