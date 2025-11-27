{
  config,
  pkgs,
  ...
}: let
  rebuild-nix = pkgs.writeShellScript "rebuild-nix.sh" ''
    #!/usr/bin/env bash
    set -euo pipefail
    pushd "$HOME/nix-config" > /dev/null
    alejandra . > /dev/null 2>&1
    git add .
    if grep -q '^ID=nixos$' /etc/os-release; then
    	sudo nixos-rebuild switch --flake $HOME/nix-config#$(hostname)
    	gen=$(sudo nixos-rebuild list-generations | grep True | awk '{print $1}')
    	echo "Rebuild successful, generation $gen"
    else
    	home-manager switch --flake $HOME/nix-config#$(hostname)
    	echo "Rebuild successful"
    fi
    popd >/dev/null
  '';
in {
  programs.zsh = {
    enable = true;
    oh-my-zsh.enable = true;
    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;
    envExtra = ''
      export ZSH_DISABLE_COMPFIX="true"
    '';

    shellAliases = {
      rcat = "command cat";
      cat = "bat";
      ls = "eza --group-directories-first --icons=auto";
      la = "ls -A";
      lt = "eza --tree --level=2 --long --icons --git";
      lta = "lt -a";
      cd = "zd";
      rebuild-nix = "${rebuild-nix}";
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

      copy() {
        if [ -z "$1" ]; then
          echo "Usage: copy <filename>"
          return 1
        fi
        if [ ! -r "$1" ]; then
          echo "Error: '$1' not found or not readable."
          return 1
        fi
        wl-copy < "$1"
        echo "Contents of '$1' copied to clipboard."
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
  home.packages = with pkgs; [
    alejandra
  ];
}
