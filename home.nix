{ ... }:

{
  home.stateVersion = "25.11";

  imports = [
    ./modules/vscode.nix
    ./modules/zsh.nix
    ./modules/ghostty.nix
  ];
}
