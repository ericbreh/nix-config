{inputs, ...}: {
  flake.modules.nixos.cli = {
    home-manager.sharedModules = [inputs.self.modules.homeManager.cli];
  };

  flake.modules.homeManager.cli = {pkgs, ...}: {
    home.packages = with pkgs; [
      tree
      gdu
      fastfetch
      btop
      usbutils
      yazi
      mgitstatus
      rsync
    ];
  };
}
