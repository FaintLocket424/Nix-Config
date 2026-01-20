{
  config,
  lib,
  inputs,
  pkgs,
  pkgs-unstable,
  hostname,
  ...
}:
{
  imports = [ inputs.home-manager.nixosModules.home-manager ];

  options.myFeatures.allUsers.enable = lib.mkEnableOption "Enable standard user set";

  config = lib.mkIf config.myFeatures.allUsers.enable {
    users.mutableUsers = false;
    users.users = {
      root.hashedPassword = "!";

      matthew = {
        description = "Matthew Peters";
        hashedPassword = "$6$QFNCuGDTRlfYTgyI$94qSvsOwnDEDQsNFgMx/.wQLsoOk3JhUBp4oTqYagKyzXuBn2JJG.r/Hu0fg4QZJC6sHSps2U0Tj0ME7YWyhP0";
        isNormalUser = true;
        extraGroups = [
          "wheel"
          "networkmanager"
          "video"
          "dialout"
        ];

        shell = pkgs.fish;
      };

      fran = {
        description = "Francesca Gibbons";
        hashedPassword = "$6$QFNCuGDTRlfYTgyI$94qSvsOwnDEDQsNFgMx/.wQLsoOk3JhUBp4oTqYagKyzXuBn2JJG.r/Hu0fg4QZJC6sHSps2U0Tj0ME7YWyhP0";
        isNormalUser = true;
        extraGroups = [ "wheel" ];

        shell = pkgs.fish;
      };
    };

    home-manager = {
      useGlobalPkgs = true;
      useUserPackages = true;
      extraSpecialArgs = { inherit inputs hostname pkgs-unstable; };

      sharedModules = [
        ./modules/development.nix
        ./modules/gaming.nix
      ];

      users = {
        matthew = import ./matthew;
        fran = import ./fran;
      };
    };
  };
}
