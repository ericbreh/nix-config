{inputs, ...}: {
  flake.modules.nixos.lazygit = {
    home-manager.sharedModules = [inputs.self.modules.homeManager.lazygit];
  };

  flake.modules.homeManager.lazygit = {pkgs, ...}: {
    programs.lazygit = {
      enable = true;
      settings = {
        git = {
          ignoreWhitespaceInDiffView = true;
          diffRenderers = [
            {command = "${pkgs.delta}/bin/delta --dark --paging=never --hunk-header-style syntax";}
            {command = "${pkgs.delta}/bin/delta --dark --paging=never --side-by-side --line-numbers-left-format='' --line-numbers-right-format='' --hunk-header-style syntax";}
          ];
        };
        gui = {
          sidePanelWidth = 0.2;
          expandFocusedSidePanel = true;
        };
      };
    };
  };
}
