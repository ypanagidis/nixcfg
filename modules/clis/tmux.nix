{ pkgs, ... }:
let
  # Define the Kanagawa plugin manually since it's not in nixpkgs
  kanagawa = pkgs.tmuxPlugins.mkTmuxPlugin {
    pluginName = "kanagawa";
    version = "unstable-2023-01-01";
    src = pkgs.fetchFromGitHub {
      owner = "Nybkox";
      repo = "tmux-kanagawa";
      rev = "master"; # You can tag a specific commit here if you prefer stability
      sha256 = "sha256-ldc++p2PcYdzoOLrd4PGSrueAGNWncdbc5k6wmFM9kQ="; # See note below!
    };
  };
in
{
  programs.tmux = {
    enable = true;

    # 1. Terminal Settings
    terminal = "screen-256color";

    # 2. Prefix Setting
    prefix = "C-s";

    # 3. Basic Settings
    mouse = true;
    baseIndex = 1; # Optional: Usually preferred to start windows at 1

    # 4. Plugins
    # Nix manages plugins, replacing TPM entirely.
    plugins = with pkgs; [
      tmuxPlugins.vim-tmux-navigator
      {
        plugin = kanagawa;
        extraConfig = ''
          set -g @kanagawa-plugins "cpu-usage ram-usage powerline git time"
          set -g @kanagawa-show-powerline true
          set -g @kanagawa-military-time true
          set -g @kanagawa-show-timezone false
          set -g @kanagawa-show-empty-plugins false
        '';
      }
    ];

    # 5. Extra Config (Porting your custom bindings)
    extraConfig = ''
      # True color settings
      set -ag terminal-overrides ",xterm-256color:RGB"
      set -g pane-border-style 'bg=default'
      set -g pane-active-border-style 'bg=default'
      set -g status-style 'bg=default'
      set -g window-style 'bg=default'
      set -g window-active-style 'bg=default'

      # Split bindings (removing old ones)
      unbind %
      bind = split-window -h
      unbind '"'
      bind - split-window -v

      # Pane resizing
      bind -r j resize-pane -D 5
      bind -r k resize-pane -U 5
      bind -r l resize-pane -R 5
      bind -r h resize-pane -L 5

      # Pane Zoom
      bind -r m resize-pane -Z

    '';
  };
}
