{
  description = "nix-config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";

    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    noctalia = {
      url = "github:noctalia-dev/noctalia-shell";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    eko-messenger-client = {
      url = "github:eko-network/eko-messenger-client";
    };

    nix-index-database = {
      url = "github:nix-community/nix-index-database";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = inputs @ {nixpkgs, ...}: {
    nixosConfigurations = {
      titan = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/titan/configuration.nix
          ./modules/nixos
          inputs.home-manager.nixosModules.default
          inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-12th-gen
        ];
      };
      silver = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/silver/configuration.nix
          ./modules/nixos
          inputs.home-manager.nixosModules.default
        ];
      };
    };
  };
}
