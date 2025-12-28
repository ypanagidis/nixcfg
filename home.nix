{ pkgs, ... }:

{
  home.stateVersion = "25.11";

  # Steam
  home.packages = with pkgs; [
    protonup-qt # manage extra Proton builds easily (GUI)
    protontricks # winetricks for Proton prefixes
    mangohud # performance overlay
    claude-code
    pnpm
    nodejs
    google-chrome
    high-tide
  ];

  imports = [
    ./modules/ides
    ./modules/clis
    ./modules/terminals.nix
  ];
}
