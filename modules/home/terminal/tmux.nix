{
  flake.homeModules.tmux = {
    programs.tmux = {
      enable = true;
      clock24 = true;
      keyMode = "vi";
      mouse = true;
      prefix = "C-s";
      terminal = "tmux-256color";
      extraConfig = ''
        bind h select-pane -L
        bind j select-pane -D
        bind k select-pane -U
        bind l select-pane -R

        bind -n C-h select-pane -L
        bind -n C-j select-pane -D
        bind -n C-k select-pane -U
        bind -n C-l select-pane -R
        bind r source-file ~/.config/tmux/tmux.conf \; display-message "Config reloaded!"
        

        setw -g mode-keys vi
        bind-key -T copy-mode-vi v send-keys -X begin-selection
        bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel

        set -g base-index 1
        set -g pane-base-index 1

        unbind '"'
        unbind %
        bind | split-window -h
        bind - split-window -v
      '';
    };
  };
}
