{
  description = "A very basic flake";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";

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
    nixpkgs-unstable,
    nur,
    home-manager,
    stylix,
    ...
  } @ inputs:
  let
    system = "x86_64-linux";

    pkgs-unstable = import nixpkgs-unstable {
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
            (final: prev: let
              newVersion = "0.10.5";
            in {
              modrinth-app-unwrapped = prev.modrinth-app-unwrapped.overrideAttrs (old: {
                version = newVersion;

                src = prev.fetchFromGitHub {
                  owner = "modrinth";
                  repo = "code";
                  tag = "v${newVersion}";
                  hash = "sha256-KqC+5RLLvg3cyjY7Ecw9qxQ5XUKsK7Tfxl4WC1OwZeI=";
                };

                cargoHash = "sha256-jWMHii65hTnTmiBFHxZ4xO5V+Qt/MPCy75eJvnlyE4c=";

                patches = builtins.filter (p: !prev.lib.hasSuffix "remove-spotless.patch" (toString p))
                    old.patches;
              });
            })
          ];
        }

        {
          home-manager = {
            useGlobalPkgs = true;
            useUserPackages = true;

            extraSpecialArgs = { inherit inputs hostname pkgs-unstable; };

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
