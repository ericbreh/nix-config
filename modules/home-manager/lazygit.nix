{pkgs, ...}: {
  home.packages = with pkgs; [
    delta
  ];
  programs.lazygit = {
    enable = true;
    settings = {
      git = {
        pagers = [
          {pager = "delta --dark --paging=never";}
          {
            pager = "ydiff -p cat -s --wrap --width={{columnWidth}}";
            colorArg = "never";
          }
        ];
        diff = "difft --color=always";
      };
    };
  };
}
