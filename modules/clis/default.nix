{ pkgs, ... }:

{
  imports = [
    ./tmux.nix
    ./btop
    ./shell
  ];

  programs = {
    direnv = {
      enable = true;
      nix-direnv.enable = true;
    };
    eza.enable = true;
    fzf.enable = true;
    lazygit.enable = true;
    gh.enable = true;
    bat.enable = true;
    yazi = {
      enable = true;
      enableZshIntegration = true;
      settings = {
        manager = {
          show_hidden = true;
        };
      };
    };
  };
}
