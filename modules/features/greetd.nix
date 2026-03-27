{...}: {
  flake.modules.nixos.greetd = {pkgs, ...}: {
    services.greetd = {
      enable = true;
      settings = {
        default_session = {
          command = "${pkgs.tuigreet}/bin/tuigreet -r";
        };
      };
    };
    security.pam.services.greetd.enableGnomeKeyring = true;
  };
}
