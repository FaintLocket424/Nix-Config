{
  description = "A very basic flake";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.11";
    nixpkgs-unstable.url = "github:nixos/nixpkgs/nixos-unstable";

    treefmt-nix.url = "github:numtide/treefmt-nix";

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
      "https://home-manager.cachix.org"
    ];

    extra-trusted-public-keys = [
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "home-manager.cachix.org-1:wLVmpPs9J1Na6uhEkqcJcdSmPR61rd76jOnlps6zvM8="
    ];
  };

  outputs =
    {
      self,
      nixpkgs,
      nixpkgs-unstable,
      nur,
      home-manager,
      stylix,
      treefmt-nix,
      ...
    }@inputs:
    let
      system = "x86_64-linux";
      pkgs = nixpkgs.legacyPackages.${system};

      pkgs-unstable = import nixpkgs-unstable {
        inherit system;
        config.allowUnfree = true;
      };

      mkHost =
        hostname: system:
        nixpkgs.lib.nixosSystem {
          inherit system;
          specialArgs = { inherit inputs hostname; };
          modules = [
            ./hosts/${hostname} # Host Specific

            ./modules/nixos/core
            ./modules/nixos/features/desktop.nix
            ./modules/nixos/features/connectivity.nix
            ./modules/nixos/features/gaming.nix
            ./users

            nur.modules.nixos.default
            stylix.nixosModules.stylix
            home-manager.nixosModules.home-manager
            {
              home-manager = {
                useGlobalPkgs = true;
                useUserPackages = true;
                extraSpecialArgs = { inherit inputs hostname pkgs-unstable; };
              };
            }

            {
              nixpkgs.config.allowUnfree = true;
            }
          ];
        };

      treefmtConfig = treefmt-nix.lib.evalModule pkgs {
        projectRootFile = "flake.nix";
        programs.nixfmt.enable = true;
      };
    in
    {
      formatter.${system} = treefmtConfig.config.build.wrapper;

      # NixOS configuration entrypoints
      # Available through 'nixos-rebuild --flake .#your-hostname'
      #      nixosConfigurations = nixpkgs.lib.genAttrs [ "falcon" "hyperion" ] mkSystem;
      nixosConfigurations = {
        falcon = mkHost "falcon" "x86_64-linux";
        hyperion = mkHost "hyperion" "x86_64-linux";
      };
    };
}
