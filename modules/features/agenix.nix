{inputs, ...}: {
  flake.modules.nixos.agenix = {pkgs, ...}: {
    imports = [inputs.agenix.nixosModules.default];

    environment.systemPackages = [inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default];

    age.secrets = {
      webdav.file = inputs.self + "/secrets/webdav.age";
      restic.file = inputs.self + "/secrets/restic.age";
      healthchecks-restic-local-rhea.file = inputs.self + "/secrets/healthchecks-restic-local-rhea.age";
      healthchecks-restic-offsite-rhea.file = inputs.self + "/secrets/healthchecks-restic-offsite-rhea.age";
      healthchecks-restic-check-rhea.file = inputs.self + "/secrets/healthchecks-restic-check-rhea.age";
      healthchecks-restic-check-silver.file = inputs.self + "/secrets/healthchecks-restic-check-silver.age";
      healthchecks-smartd-rhea.file = inputs.self + "/secrets/healthchecks-smartd-rhea.age";
      healthchecks-smartd-silver.file = inputs.self + "/secrets/healthchecks-smartd-silver.age";
      restic-offsite-ssh.file = inputs.self + "/secrets/restic-offsite-ssh.age";
      duckdns.file = inputs.self + "/secrets/duckdns.age";
    };
  };
}
