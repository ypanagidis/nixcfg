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
      [[ -f ~/.p10k.zsh ]] && source ~/.p10k.zsh
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
