{
  lib,
  config,
  ...
}: {
  options.home-manager.git.enable = lib.mkEnableOption "Enable git";
  config = lib.mkIf config.home-manager.git.enable {
    programs.git = {
      enable = true;
      settings = {
        user.name = "Eric Chuang";
        user.email = "ericchuang94@gmail.com";
        init.defaultBranch = "main";
        gpg.format = "ssh";
        pull.rebase = true;
      };
      signing = {
        signByDefault = true;
        key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOanOZf0P4dP7gnyYLQ8WcxTm3ln5rFZE+J/1RhTewVR";
      };
    };
  };
}
