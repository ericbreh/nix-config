{
  lib,
  config,
  ...
}: {
  options.podman.enable = lib.mkEnableOption "Enable podman";
  config = lib.mkIf config.podman.enable {
    virtualisation.podman = {
      enable = true;
      # Create a `docker` alias forpodman, to use it as a drop-in replacement
      dockerCompat = true;
      # Required for containers under podman-compose to be able to talk to each other.
      defaultNetwork.settings.dns_enabled = true;
    };
  };
}
