{
  description = "A very basic flake";

  inputs = {
    # Nixpkgs
    nixpkgs.url = "github:nixos/nixpkgs?ref=nixos-25.05";

    hyprlock.url = "github:hyprwm/hyprlock";

    hyprland.url = "github:hyprwm/Hyprland";

    nix-stable.url = "github:NixOS/nixpkgs/nixos-25.05";

    lanzaboote = {
      url = "github:nix-community/lanzaboote/v0.4.2";
    };

    # Home Manager
    home-manager = {
      url = "github:nix-community/home-manager/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    stylix = {
      url = "github:nix-community/stylix/release-25.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    wezterm.url = "github:wezterm/wezterm?dir=nix";
  };

  nixConfig = {
    extra-substituters = [
      "https://hyprland.cachix.org"
      "https://nix-community.cachix.org"
      "https://lanzaboote.cachix.org"
      "https://stylix.cachix.org"
      "https://wezterm.cachix.org"
    ];

    extra-trusted-public-keys = [
      "hyprland.cachix.org-1:a7pgxzMz7+chwVL3/pzj6jIBMioiJM7ypFP8PwtkuGc="
      "wezterm.cachix.org-1:kAbhjYUC9qvblTE+s7S+kl5XM1zVa4skO+E/1IDWdH0="
      "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
      "lanzaboote.cachix.org-1:Nt9//zGmqkg1k5iu+B3bkj3OmHKjSw9pvf3faffLLNk="
      "stylix.cachix.org-1:iTycMb+viP8aTqhRDvV5qjs1jtNJKH9Jjvqyg4DYxhw="
    ];
  };

  outputs = {
    self,
    lanzaboote,
    nixpkgs,
    stylix,
    home-manager,
    nix-stable,
    ...
  } @ inputs: let
    system = "x86_64-linux";
    stable = import nix-stable {
      inherit system;
      config.allowUnfree = true;
    };
  in {
    # NixOS configuration entrypoint
    # Available through 'nixos-rebuild --flake .#your-hostname'
    nixosConfigurations = {
      hyperion = nixpkgs.lib.nixosSystem {
        specialArgs = {
          inherit inputs;
          inherit stable;
          inherit system;
        };

        pkgs = import nixpkgs {
          inherit system;
          config.allowUnfree = true;
        };

        modules = [
          ./hyperion/configuration.nix
          stylix.nixosModules.stylix
          home-manager.nixosModules.home-manager
          {
            home-manager = {
              extraSpecialArgs = {
                inherit inputs;
                inherit system;
                inherit stable;
              };
              users.matthew = import ./hyperion/home-manager/home.nix;
            };
          }
          lanzaboote.nixosModules.lanzaboote
        ];
      };
    };
  };
}
