{inputs, ...}: {
  flake.modules.nixos.core = {
    home-manager.sharedModules = [inputs.self.modules.homeManager.core];
  };

  flake.modules.homeManager.core = {pkgs, ...}: {
    home.packages = with pkgs; [
      unzip
      zip
      wget
      curl
      ripgrep
      fd
      wl-clipboard
      tree
      gdu
      fastfetch
      btop
      usbutils
      yazi
      mgitstatus
    ];
  };
}
