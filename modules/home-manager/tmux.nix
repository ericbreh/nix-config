{
  lib,
  config,
  pkgs,
  ...
}: {
  options = {
    tmux.enable = lib.mkEnableOption "Enable tmux";
    tmux.prefix = lib.mkOption {
      type = lib.types.str;
      default = "a";
      description = "tmux prefix";
    };
  };

  config = lib.mkIf config.tmux.enable {
    programs.tmux = {
      enable = true;
      baseIndex = 1;
      escapeTime = 10;
      keyMode = "vi";
      mouse = true;
      historyLimit = 50000;
      terminal = "tmux-256color";
      customPaneNavigationAndResize = true;
      extraConfig = ''
        unbind C-b
        set -g prefix C-${config.tmux.prefix}
        bind C-${config.tmux.prefix} send-prefix

        set -g renumber-windows on
        set -g focus-events on
        set -s set-clipboard off

        set -g status-position top
        set -g status-justify absolute-centre
        set -g status-style bg=default
        set -g status-style "fg=brightblack"
        setw -g mode-style "bg=#737373"
        set -g window-status-current-style "fg=white bold"
        set -g status-right "#h "
        set -g status-left " #S"

        bind -T copy-mode-vi v send -X begin-selection
        bind -T copy-mode-vi y send -X copy-pipe-and-cancel "wl-copy"
        bind-key -T copy-mode-vi MouseDragEnd1Pane send-keys -X copy-pipe-and-cancel "wl-copy"

        bind c new-window -c "#{pane_current_path}"
        bind '"' split-window -c "#{pane_current_path}"
        bind % split-window -h -c "#{pane_current_path}"
        bind C new-session
        bind -r n if-shell '[ "$(tmux list-windows | wc -l)" -eq 1 ]' 'new-window -c "#{pane_current_path}"' 'next-window'
        bind -r N if-shell '[ "$(tmux list-sessions | wc -l)" -eq 1 ]' 'new-session' 'switch-client -n'

        bind-key g run-shell 'tmux display-popup -w 90% -h 90% -E "cd #{pane_current_path} && lazygit"'

        bind-key & kill-window
        bind-key x kill-pane
        bind -r a last-window
      '';
    };
  };
}
