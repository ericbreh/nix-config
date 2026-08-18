{inputs, ...}: {
  flake.modules.nixos.ssh = {
    home-manager.sharedModules = [inputs.self.modules.homeManager.ssh];
  };

  flake.modules.homeManager.ssh = {
    programs.ssh = {
      enable = true;
      enableDefaultConfig = false;
      settings = {
        silver = {
          HostName = "silver";
          User = "ericbreh";
        };
        rhea = {
          HostName = "10.0.0.173";
          User = "ericbreh";
        };
      };
    };
  };
}
