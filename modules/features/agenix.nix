{inputs, ...}: {
  flake.modules.nixos.agenix = {pkgs, ...}: {
    imports = [inputs.agenix.nixosModules.default];

    environment.systemPackages = [inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default];

    age.secrets = {
      webdav.file = inputs.self + "/secrets/webdav.age";
      restic.file = inputs.self + "/secrets/restic.age";
      healthchecks-restic.file = inputs.self + "/secrets/healthchecks-restic.age";
      healthchecks-restic-check.file = inputs.self + "/secrets/healthchecks-restic-check.age";
      healthchecks-restic-offsite.file = inputs.self + "/secrets/healthchecks-restic-offsite.age";
      healthchecks-smart-rhea.file = inputs.self + "/secrets/healthchecks-smart-rhea.age";
      healthchecks-smart-silver.file = inputs.self + "/secrets/healthchecks-smart-silver.age";
      restic-silver-ssh.file = inputs.self + "/secrets/restic-silver-ssh.age";
      duckdns.file = inputs.self + "/secrets/duckdns.age";
    };
  };
}
