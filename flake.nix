{
  description = "A very basic flake";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
      "https://stylix.cachix.org"
      "https://home-manager.cachix.org"
    ];

    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "stylix.cachix.org-1:iTycMb+viP8aTqhRDvV5qjs1jtNJKH9Jjvqyg4DYxhw="
      "home-manager.cachix.org-1:wLVmpPs9J1Na6uhEkqcJcdSmPR61rd76jOnlps6zvM8="
    ];
  };

  outputs = {
    self,
    nixpkgs,
    home-manager,
    stylix,
    ...
  } @ inputs:
  let
    system = "x86_64-linux";

    myUsers = [ "matthew" ];

    mkSystem = hostname: nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs hostname; };

      modules = [
        ./common/configuration.nix      # System Config - All Machines
        ./${hostname}/configuration.nix # System Config - Machine Specific

        stylix.nixosModules.stylix
        home-manager.nixosModules.home-manager

        {
          home-manager = {
            extraSpecialArgs = { inherit inputs hostname; };

#            sharedModules = [
#              import ./common/home/common      # Home Manager -   All Machines   - All Users
#              import ./${hostname}/home/common # Home Manager - Machine Specific - All Users
#            ];

            users = nixpkgs.lib.genAttrs myUsers (username:
              { config, pkgs, ...}: {
                home.username = username;
                home.homeDirectory = "/home/${username}";

                imports = [
                  ./common/home/common      # Home Manager -   All Machines   - All Users
                  ./${hostname}/home/common # Home Manager - Machine Specific - All Users
                  ./common/home/${username}      # Home Manager -   All Machines   - User Specific
                  ./${hostname}/home/${username} # Home Manager - Machine Specific - User Specific
                ];
              }
            );
          };
        }

        {
          nixpkgs.config.allowUnfree = true;
        }
      ];
    };
  in {
    # NixOS configuration entrypoints
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = nixpkgs.lib.genAttrs [ "falcon" "hyperion" ] mkSystem;
  };
}
