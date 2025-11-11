{
  config,
  pkgs,
  ...
}: {
  programs.zsh = {
    enable = true;
    oh-my-zsh.enable = true;

    syntaxHighlighting.enable = true;
    autosuggestion.enable = true;

    initContent = ''
      if [ -z "$TMUX" ] && [ "$TERM_PROGRAM" != "vscode" ]; then tmux attach -t main || tmux new -s main; fi
      source ${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k/powerlevel10k.zsh-theme
      source ~/.p10k.zsh

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

      alias rcat='command cat'
      alias cat='bat'
      alias ls='eza --group-directories-first --icons=auto'
      alias la='ls -A'
      alias lt='eza --tree --level=2 --long --icons --git'
      alias lta='lt -a'
      alias cd='zd'
      alias ..='cd ..'
      alias ...='cd ../..'
      alias ....='cd ../../..'
      alias .....='cd ../../../..'
      alias cd ...='cd ../..'
      alias cd ....='cd ../../..'
      alias cd .....='cd ../../../..'
    '';
  };

  home.file.".p10k.zsh" = {
    source = config.lib.file.mkOutOfStoreSymlink "${config.home.homeDirectory}/.dots/zsh/.p10k.zsh";
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
}
