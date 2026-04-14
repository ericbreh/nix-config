{inputs, ...}: {
  flake.modules.nixos.git = {
    home-manager.sharedModules = [inputs.self.modules.homeManager.git];
  };

  flake.modules.homeManager.git = {
    programs.git = {
      enable = true;
      lfs.enable = true;
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
      ignores = [".opencode/"];
    };
  };
}
