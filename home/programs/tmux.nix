{pkgs, ...}: {
  programs.tmux = {
    enable = true;

    # Change Prefix from Ctrl+b to Ctrl+a (Easier to hit)
    prefix = "C-a";

    # Start numbering at 1 (easier to reach)
    baseIndex = 1;

    # Enable mouse support (resize panes, select windows)
    mouse = true;

    # Fix colors for Neovim
    terminal = "tmux-256color";

    extraConfig = ''
      # Remove delay for Esc key (crucial for Neovim)
      set -s escape-time 0

      # Enable true color support
      set-option -sa terminal-overrides ",xterm*:Tc"

      # Renumber windows when one is closed
      set-option -g renumber-windows on

      # Open new panes in current directory
      bind '"' split-window -v -c "#{pane_current_path}"
      bind % split-window -h -c "#{pane_current_path}"

      # Vim-like pane switching (in copy mode)
      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi C-v send-keys -X rectangle-toggle
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
    '';

    plugins = with pkgs.tmuxPlugins; [
      sensible
      vim-tmux-navigator
      yank

      # 4. Catppuccin Theme
      {
        plugin = catppuccin;
        extraConfig = ''
          set -g @catppuccin_flavour 'mocha'
          set -g @catppuccin_window_left_separator ""
          set -g @catppuccin_window_right_separator " "
          set -g @catppuccin_window_middle_separator " █"
          set -g @catppuccin_window_number_position "right"
          set -g @catppuccin_window_default_fill "number"
          set -g @catppuccin_window_default_text "#W"
          set -g @catppuccin_window_current_fill "number"
          set -g @catppuccin_window_current_text "#W"
          set -g @catppuccin_status_modules_right "directory session"
          set -g @catppuccin_status_left_separator  " "
          set -g @catppuccin_status_right_separator ""
          set -g @catppuccin_status_fill "icon"
          set -g @catppuccin_status_connect_separator "no"
          set -g @catppuccin_directory_text "#{pane_current_path}"
        '';
      }
    ];
  };
}
