{inputs, ...}: {
  flake.modules.nixos.zsh = {
    home-manager.sharedModules = [inputs.self.modules.homeManager.zsh];
  };

  flake.modules.homeManager.zsh = {pkgs, ...}: let
    rebuild-nix = pkgs.writeShellScript "rebuild-nix.sh" ''
      #!/usr/bin/env bash
      set -euo pipefail
      pushd "$HOME/nix-config" > /dev/null
      ${pkgs.alejandra}/bin/alejandra . > /dev/null 2>&1
      git add .
      nh os switch .
      popd >/dev/null
    '';
  in {
    programs.zsh = {
      enable = true;
      oh-my-zsh.enable = true;
      syntaxHighlighting.enable = true;
      autosuggestion.enable = true;

      shellAliases = {
        rcat = "command cat";
        cat = "bat";
        ls = "eza --group-directories-first --icons=auto";
        la = "ls -A";
        lt = "eza --tree --level=2 --long --icons --git";
        lta = "lt -a";
        cd = "zd";
        rebuild-nix = "${rebuild-nix}";
        myrsync = "rsync -ah --partial --info=progress2,stats2";
      };

      initContent = ''
        if [ -z "$TMUX" ] && [ "$TERM_PROGRAM" != "vscode" ]; then tmux attach -t main || tmux new -s main; fi
        source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
        source ${./.p10k.zsh}

        setopt GLOB_DOTS
        zstyle ':completion:*' special-dirs false
        zstyle ':completion:*:cd:*' tag-order 'directories'

        zd() {
          if [ $# -eq 0 ]; then
            builtin cd ~ && return
          elif [ -d "$1" ]; then
            builtin cd "$1"
          else
            z "$@"
          fi
        }
        compdef _cd zd

        open() {
          nohup xdg-open "$@" >/dev/null 2>&1 &
        }
      '';
    };

    programs.zoxide.enable = true;
    programs.eza.enable = true;
    programs.bat = {
      enable = true;
      config = {
        paging = "never";
        style = "plain";
      };
    };
  };
}
