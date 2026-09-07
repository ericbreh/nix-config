{inputs, ...}: {
  flake.modules.nixos.kunifiedpush = {
    home-manager.sharedModules = [inputs.self.modules.homeManager.kunifiedpush];
  };

  flake.modules.homeManager.kunifiedpush = {
    imports = [inputs.kunifiedpush-flake.homeManagerModules.kunifiedpush];
    services.kunifiedpush.enable = true;
  };
}
