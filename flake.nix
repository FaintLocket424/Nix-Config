{
  description = "Matthew's NixOS Gaming Laptop Configuration";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-25.11";
    nixpkgs-unstable.url = "github:NixOS/nixpkgs/nixos-unstable";

    home-manager = {
      url = "github:nix-community/home-manager/release-25.11";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    plasma-manager = {
      url = "github:nix-community/plasma-manager";
      inputs.nixpkgs.follows = "nixpkgs";
      inputs.home-manager.follows = "home-manager";
    };

    treefmt-nix = {
      url = "github:numtide/treefmt-nix";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, nixpkgs-unstable, home-manager, plasma-manager, treefmt-nix, ... }@inputs:
    let
      systems = [ "x86_64-linux" "aarch64-linux" ];

      forAllSystems = nixpkgs.lib.genAttrs systems;

      allowedUnfree = import ./lib/unfree-list.nix;

      mkSystem = { hostname, system ? "x86_64-linux" }:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = {
            inherit inputs hostname;
          };

          modules = [
            {
              nixpkgs.config = {
                allowUnfree = false;
                allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) allowedUnfree;
              };
            }
            ./hosts/common/configuration.nix
            ./hosts/${hostname}/configuration.nix
            ./users

            home-manager.nixosModules.home-manager
            {
              home-manager.useUserPackages = true;

              home-manager.extraSpecialArgs = {
                inherit inputs hostname;
              };

              home-manager.backupFileExtension = "backup";

              home-manager.sharedModules = [
                ./users/common
                plasma-manager.homeModules.plasma-manager
                {
                  nixpkgs.config = {
                    allowUnfree = false;
                    allowUnfreePredicate = pkg: builtins.elem (nixpkgs.lib.getName pkg) allowedUnfree;
                  };
                }
              ];
            }
          ];
        };
    in
    {
      # Generate the formatter for each supported system
      formatter = forAllSystems (system:
        let
          pkgs = nixpkgs.legacyPackages.${system};

          treefmtEval = treefmt-nix.lib.evalModule pkgs {
            projectRootFile = "flake.nix";
            programs.nixpkgs-fmt.enable = true;
          };
        in
        treefmtEval.config.build.wrapper
      );

      nixosConfigurations = {
        hyperion = mkSystem { hostname = "hyperion"; };
        falcon = mkSystem { hostname = "falcon"; };
      };
    };
}
