{
  description = "nix-config flake";

  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
    nixos-hardware.url = "github:NixOS/nixos-hardware/master";
    # eko-messenger.url = "path:/home/ericbreh/Github/eko-messenger";
  };

  outputs = {nixpkgs, ...} @ inputs: {
    nixosConfigurations = {
      titan = nixpkgs.lib.nixosSystem {
        specialArgs = {inherit inputs;};
        modules = [
          ./hosts/titan/configuration.nix
          ./modules/nixos
          inputs.home-manager.nixosModules.default
          inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-12th-gen
          # inputs.eko-messenger.nixosModules.default
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
