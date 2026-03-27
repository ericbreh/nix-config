{inputs, ...}: {
  flake.nixosConfigurations.titan = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.self.modules.nixos.titan
      inputs.home-manager.nixosModules.default
      inputs.nixos-hardware.nixosModules.lenovo-thinkpad-x1-12th-gen
      {home-manager.useGlobalPkgs = true;}
    ];
  };
}
