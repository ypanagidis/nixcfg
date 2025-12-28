{ pkgs, ... }:
{
  imports = [
    ./cursor
    ./vscode
    ./nvim-config/neovim.nix
  ];

  home.packages = with pkgs; [
    jetbrains.datagrip
  ];
}
