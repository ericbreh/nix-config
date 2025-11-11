{pkgs, ...}: {
  programs.git = {
    enable = true;
    settings = {
      user = {
        name = "Eric Chuang";
        email = "ericchuang94@gmail.com";
      };
      init = {
        defaultBranch = "main";
      };
      pull = {
        rebase = false;
      };
    };
    signing = {
      signByDefault = true;
    };
  };
}
