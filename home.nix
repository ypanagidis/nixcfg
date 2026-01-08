{ pkgs, ... }:

{
  home.stateVersion = "25.11";

  # Steam
  home.packages = with pkgs; [
    protonup-qt # manage extra Proton builds easily (GUI)
    protontricks # winetricks for Proton prefixes
    mangohud # performance overlay
    pnpm
    nodejs
    google-chrome
    high-tide
    pkgs.opencode
    python3
    bun
    claude
    winapps
    winapps-launcher
  ];

  imports = [
    ./modules/ides
    ./modules/clis
    ./modules/browsers
    ./modules/terminals.nix
    ./modules/obsedian.nix
  ];
}
