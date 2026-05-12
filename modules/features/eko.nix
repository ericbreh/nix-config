{inputs, ...}: {
  flake.modules.nixos.eko = {pkgs, ...}: {
    environment.systemPackages = [inputs.eko.packages.${pkgs.stdenv.hostPlatform.system}.default];
  };
}
