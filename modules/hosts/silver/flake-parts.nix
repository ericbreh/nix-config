{inputs, ...}: {
  flake.nixosConfigurations.silver = inputs.nixpkgs.lib.nixosSystem {
    modules = [
      inputs.self.modules.nixos.silver
      inputs.home-manager.nixosModules.default
      {home-manager.useGlobalPkgs = true;}
    ];
  };
}
