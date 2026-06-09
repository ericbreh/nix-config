{...}: {
  flake.modules.nixos.navidrome = {
    services.navidrome = {
      enable = true;
      settings = {
        Address = "0.0.0.0";
        MusicFolder = "/srv/storage/media/music";
      };
      openFirewall = true;
    };
  };
}
