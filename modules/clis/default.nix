{ pkgs, ... }:

{
  imports = [
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
    gh.enable = true; # prefer this instead of home.packages when possible
  };
}
