{ config, pkgs, ... }:

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
      ];

      # This gets inserted into .zshrc before OMZ loads.
      # We set a writable custom dir so themes/plugins can live there.
      extraConfig = ''
        export ZSH_CUSTOM="$HOME/.config/oh-my-zsh/custom"
      '';
    };

    # initExtra is deprecated → use initContent
    initContent = ''
      # fzf: use fd for listing + bat/eza previews
      if type fzf &>/dev/null; then
        export FZF_DEFAULT_COMMAND='fd --hidden --follow --exclude .git'
        export FZF_CTRL_T_COMMAND="$FZF_DEFAULT_COMMAND"
        export FZF_ALT_C_COMMAND='fd --type d --hidden --follow --exclude .git'

        # Preview: directories -> eza tree, files -> bat
        _fzf_preview_cmd='
          if [ -d {} ]; then
            eza -lT --level=2 --icons=always --color=always {} | head -200
          else
            bat --style=numbers --color=always --line-range :200 {} 2>/dev/null
          fi
        '

        export FZF_DEFAULT_OPTS="
          --border
          --layout=reverse
          --preview-window=right:60%:wrap
          --preview '$_fzf_preview_cmd'
        "
      fi
      [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
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
      alias lg="lazygit"
      alias p="pnpm"
    '';
  };

  # Put the *entire* p10k theme directory where OMZ expects it:
  # $ZSH_CUSTOM/themes/powerlevel10k/powerlevel10k.zsh-theme
  home.file.".config/oh-my-zsh/custom/themes/powerlevel10k".source =
    "${pkgs.zsh-powerlevel10k}/share/zsh-powerlevel10k";

  home.packages = with pkgs; [
    zsh-powerlevel10k
    fzf
  ];
}
