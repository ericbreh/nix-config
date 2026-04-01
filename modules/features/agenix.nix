{inputs, ...}: {
  flake.modules.nixos.agenix = {pkgs, ...}: {
    imports = [inputs.agenix.nixosModules.default];

    environment.systemPackages = [inputs.agenix.packages.${pkgs.stdenv.hostPlatform.system}.default];

    age.secrets.webdav.file = inputs.self + "/secrets/webdav.age";
    age.secrets.restic.file = inputs.self + "/secrets/restic.age";
    age.secrets.healthchecks-restic.file = inputs.self + "/secrets/healthchecks-restic.age";
    age.secrets.healthchecks-restic-check.file = inputs.self + "/secrets/healthchecks-restic-check.age";
    age.secrets.healthchecks-smart.file = inputs.self + "/secrets/healthchecks-smart.age";
  };
}
