{
  description = "A very basic flake";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    nixpkgs-25_05.url = "github:nixos/nixpkgs?ref=nixos-25.05";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    nur = {
      url = "github:nix-community/NUR";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    quickemu = {
      url = "github:quickemu-project/quickemu";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  nixConfig = {
    extra-substituters = [
      "https://nix-community.cachix.org"
#      "https://stylix.cachix.org"
      "https://home-manager.cachix.org"
    ];

    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
#      "stylix.cachix.org-1:iTycMb+viP8aTqhRDvV5qjs1jtNJKH9Jjvqyg4DYxhw="
      "home-manager.cachix.org-1:wLVmpPs9J1Na6uhEkqcJcdSmPR61rd76jOnlps6zvM8="
    ];
  };

  outputs = {
    self,
    nixpkgs,
    nixpkgs-25_05,
    nixpkgs-unstable,
    nur,
    home-manager,
    stylix,
    quickemu,
    ...
  } @ inputs:
  let
    system = "x86_64-linux";

    pkgs-unstable = import nixpkgs-unstable {
      inherit system;
      config.allowUnfree = true;
    };

    pkgs-25_05 = import nixpkgs-25_05 {
      inherit system;
      config.allowUnfree = true;
    };

    myUsers = [ "matthew" ];

    mkSystem = hostname: nixpkgs.lib.nixosSystem {
      inherit system;
      specialArgs = { inherit inputs hostname; };

      modules = [
        ./common/configuration.nix      # System Config - All Machines
        ./${hostname}/configuration.nix # System Config - Machine Specific

        nur.modules.nixos.default
        stylix.nixosModules.stylix
        home-manager.nixosModules.home-manager

        {
          nixpkgs.overlays = [
            (final: prev: {
              papers = prev.papers.overrideAttrs (old: {
                preBuild = (old.preBuild or "") + ''
                  export RUST_MIN_STACK=16777216
                '';
              });
            })
          ];
        }

        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;

            extraSpecialArgs = { inherit inputs hostname pkgs-unstable pkgs-25_05; };

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
