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
    ./modules/vscode
    ./modules/shell
    ./modules/cursor
    ./modules/btop
    ./modules/ghostty.nix
    ./modules/gh.nix
    ./modules/lazygit.nix
    ./modules/direnv.nix
    ./modules/fzf.nix
    ./modules/eza.nix
  ];
}
