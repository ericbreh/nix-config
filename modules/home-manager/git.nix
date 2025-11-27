{pkgs, ...}: {
  programs.git = {
    enable = true;
    userName = "Eric Chuang";
    userEmail = "ericchuang94@gmail.com";
    extraConfig = {
      init.defaultBranch = "main";
      gpg.format = "ssh";
    };
    signing = {
      signByDefault = true;
      key = "ssh-ed25519 AAAAC3NzaC1lZDI1NTE5AAAAIOanOZf0P4dP7gnyYLQ8WcxTm3ln5rFZE+J/1RhTewVR";
    };
  };
}
