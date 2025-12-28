{ pkgs, ... }:

{
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

    oh-my-zsh = {
      enable = true;
      theme = "powerlevel10k/powerlevel10k";
      plugins = [
        "git"
        "sudo"
        "docker"
        "kubectl"
        "npm"
        "fzf"
        "z"
        "vi-mode"
      ];
      extraConfig = ''
        export ZSH_CUSTOM="$HOME/.config/oh-my-zsh/custom"
        VI_MODE_SET_CURSOR=true
      '';
    };

    initContent = ''
      # ---------------------------------------------------------
      # 1. KEY MAPPING FIXES
      # ---------------------------------------------------------

      # Alt+Backspace -> Delete Word (Standard ^H mapping)
      bindkey '^H' backward-kill-word

      # Standard Backspace -> Delete Character
      bindkey '^?' backward-delete-char 

      # Cmd+Left/Right -> Jump to Start/End of Line (mapped to Home/End)
      bindkey '^[[H' beginning-of-line
      bindkey '^[[F' end-of-line

      # ---------------------------------------------------------
      # 2. CLEAR SCREEN FIXES (Ctrl+F & Ctrl+L)
      # ---------------------------------------------------------

      # [RESTORED] Ctrl+F to Clear Screen
      # We bind this in ALL modes to prevent the "^F" print error.
      bindkey '^f'      clear-screen
      bindkey -M viins '^f' clear-screen
      bindkey -M vicmd '^f' clear-screen

      # Ctrl+L (Standard Clear) - kept just in case
      bindkey '^L'      clear-screen
      bindkey -M viins '^L' clear-screen
      bindkey -M vicmd '^L' clear-screen

      # ---------------------------------------------------------
      # 3. VI MODE & SYSTEM FIXES
      # ---------------------------------------------------------

      # Fix Ctrl+C (Interrupt) in Command Mode
      bindkey -M vicmd '^C' send-break

      # "jk" to Escape
      bindkey -M viins 'jk' vi-cmd-mode

      # ---------------------------------------------------------
      # 4. FZF CONFIGURATION
      # ---------------------------------------------------------
      if type fzf &>/dev/null; then
        export FZF_DEFAULT_COMMAND='fd --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'
        
        _fzf_preview_cmd='
          if [ -d {} ]; then eza -lT --level=2 --icons=always --color=always {} | head -200
          else bat --style=numbers --color=always --line-range :200 {} 2>/dev/null
          fi'
          
        export FZF_DEFAULT_OPTS="--border --layout=reverse --preview-window=right:60%:wrap --preview '$_fzf_preview_cmd'"
      fi

      [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh

      # ---------------------------------------------------------
      # 5. ALIASES (RESTORED)
      # ---------------------------------------------------------
      function re() {
        pushd ~/nixcfg > /dev/null && sudo nixos-rebuild switch --flake .#nixos && popd > /dev/null
      }

      alias lgit="lazygit"
      alias p="pnpm"
      alias cm="cd ~/Developer/Work/UP/mono/"
      alias cs="cd ~/Developer/sandbox/"
      alias cn="cd ~/nixcfg/"
      alias c="cursor ."
      alias n="nvim"

      if type eza &>/dev/null; then
        alias l="eza --icons=always"
        alias la="eza -a --icons=always"
        alias lh="eza -ad --icons=always .*"
        alias ll="eza -lg --icons=always"
        alias lla="eza -lag --icons=always"
        alias llh="eza -lagd --icons=always .*"
        alias ls="eza --icons=always"
        alias lt2="eza -lTg --level=2 --icons=always"
        alias lt3="eza -lTg --level=3 --icons=always"
        alias lt4="eza -lTg --level=4 --icons=always"
        alias lt="eza -lTg --icons=always"
        alias lta2="eza -lTag --level=2 --icons=always"
        alias lta3="eza -lTag --level=3 --icons=always"
        alias lta4="eza -lTag --level=4 --icons=always"
        alias lta="eza -lTag --icons=always"
      fi
    '';
  };

  home.file.".config/oh-my-zsh/custom/themes/powerlevel10k".source =
    "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k";

  home.packages = with pkgs; [
    zsh-powerlevel10k
    fzf
  ];
}
