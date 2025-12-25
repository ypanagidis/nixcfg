{ pkgs, ... }:

{
  home.stateVersion = "25.11";

  # Steam
  home.packages = with pkgs; [
    protonup-qt # manage extra Proton builds easily (GUI)
    protontricks # winetricks for Proton prefixes
    mangohud # performance overlay
  ];

  imports = [
    ./modules/vscode.nix
    ./modules/zsh.nix
    ./modules/ghostty.nix
    ./modules/steam.nix
  ];
}
