{ pkgs, ... }:
{
  imports = [
    ./cursor
    ./vscode
  ];

  home.packages = with pkgs; [
    jetbrains.datagrip
  ];
}
