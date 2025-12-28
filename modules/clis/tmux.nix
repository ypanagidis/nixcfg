{ pkgs, ... }:
let
  kanagawa = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "kanagawa";
    version = "unstable-2023-01-01";
    src = pkgs.fetchFromGitHub {
      owner = "Nybkox";
      repo = "tmux-kanagawa";
      rev = "master";
      sha256 = "sha256-ldc++p2PcYdzoOLrd4PGSrueAGNWncdbc5k6wmFM9kQ=";
    };
  };
in
{
  programs.tmux = {
    enable = true;

    # 1. CORE SETTINGS
    # ---------------------------------------------------------
    terminal = "screen-256color";
    prefix = "C-s";
    mouse = true;
    baseIndex = 1;

    # 2. PLUGINS
    # ---------------------------------------------------------
    plugins = with pkgs; [
      tmuxPlugins.vim-tmux-navigator
      {
        plugin = kanagawa;
        extraConfig = ''
          set -g @kanagawa-plugins "cpu-usage ram-usage powerline git time"
          set -g @kanagawa-show-powerline true
          set -g @kanagawa-military-time true
          set -g @kanagawa-show-empty-plugins false
        '';
      }
    ];

    # 3. EXTRA CONFIGURATION
    # ---------------------------------------------------------
    extraConfig = ''
      # =========================================================
      # 1. KEYBOARD FIXES
      # =========================================================
      set-window-option -g xterm-keys on
      set -s escape-time 0

      # [FIX] Alt+Backspace (keyd sends Ctrl+h)
      # Unbind Ctrl+h from root table so it passes through to Zsh for "Delete Word"
      unbind -n C-h

      # [FIX] Alt+Arrows (Force Passthrough)
      bind -n C-Left send-keys Escape "[1;5D"
      bind -n C-Right send-keys Escape "[1;5C"

      # =========================================================
      # 2. VISUALS & CURSOR (BACKGROUND FIX)
      # =========================================================
      set -ag terminal-overrides ",xterm-256color:RGB"
      set -ga terminal-overrides ',*:Ss=\E[%p1%d q:Se=\E[2 q'

      # [CRITICAL] Force Transparent Background
      # These lines override the theme's background to match your Ghostty config.
      set -g window-style 'bg=default'
      set -g window-active-style 'bg=default'
      set -g pane-border-style 'bg=default'
      set -g pane-active-border-style 'bg=default'
      set -g status-style 'bg=default'

      # =========================================================
      # 3. STANDARD BINDINGS
      # =========================================================
      unbind %
      bind = split-window -h
      unbind '"'
      bind - split-window -v

      bind -r j resize-pane -D 5
      bind -r k resize-pane -U 5
      bind -r l resize-pane -R 5
      bind -r h resize-pane -L 5
      bind -r m resize-pane -Z

      # =========================================================
      # 4. SCROLLING
      # =========================================================
      set-window-option -g mode-keys vi

      bind u copy-mode        # Prefix + u
      bind v copy-mode        # Prefix + v
      bind -n S-PageUp copy-mode -u

      bind -n WheelUpPane if-shell -F -t = "#{mouse_any_flag}" "send-keys -M" "if -Ft= '#{pane_in_mode}' 'send-keys -M' 'copy-mode -e'"

      bind-key -T copy-mode-vi v send-keys -X begin-selection
      bind-key -T copy-mode-vi y send-keys -X copy-selection-and-cancel
      bind-key -T copy-mode-vi C-u send-keys -X halfpage-up
      bind-key -T copy-mode-vi C-d send-keys -X halfpage-down
    '';
  };
}
