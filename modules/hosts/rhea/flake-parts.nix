{inputs, ...}: {
  flake.nixosConfigurations.rhea = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.self.modules.nixos.rhea
      inputs.home-manager.nixosModules.default
      {home-manager.useGlobalPkgs = true;}
    ];
  };
}
