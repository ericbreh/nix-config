{inputs, ...}: {
  flake.modules.nixos.niri = {pkgs, ...}: {
    home-manager.sharedModules = [inputs.self.modules.homeManager.niri];

    programs.niri.enable = true;

    security.polkit.enable = true;
    services.gnome.gnome-keyring.enable = true;
    environment.sessionVariables.NIXOS_OZONE_WL = "1";
    environment.systemPackages = with pkgs; [
      xwayland-satellite
      gpu-screen-recorder
    ];

    services.upower.enable = true;
  };

  flake.modules.homeManager.niri = {
    config,
    pkgs,
    ...
  }: {
    imports = [
      inputs.noctalia.homeModules.default
    ];

    programs.noctalia-shell = {
      enable = true;
    };

    home.file = {
      ".config/niri".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/modules/features/niri/config/niri";
      ".config/noctalia/".source =
        config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/nix-config/modules/features/niri/config/noctalia";
    };
    home.packages = with pkgs; [
      wl-clipboard
      fd
    ];
  };
}
