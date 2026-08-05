{inputs, ...}: {
  flake.modules.nixos.ssh = {
    home-manager.sharedModules = [inputs.self.modules.homeManager.ssh];
  };

  flake.modules.homeManager.ssh = {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      matchBlocks = {
        silver = {
          hostname = "silver";
          user = "ericbreh";
        };
        rhea = {
          hostname = "10.0.0.173";
          user = "ericbreh";
        };
      };
    };
  };
}
