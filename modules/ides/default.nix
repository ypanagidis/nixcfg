{ pkgs, ... }:
{
  imports = [
    ./cursor
    ./vscode
    ./nvim-config/neovim.nix
    ./datagrip/datagrip.nix
  ];

}
