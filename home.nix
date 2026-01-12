{ pkgs, ... }:

{
  home.stateVersion = "25.11";

  home.sessionPath = [ "$HOME/.local/bin" ];

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

  # Crapindows
  xdg.configFile."winapps/winapps.conf".text = ''
    RDP_USER="yiannis"
    RDP_PASS="fuckwindows"
    RDP_DOMAIN=""
    RDP_IP="192.168.122.85"
    WAFLAVOR="libvirt"
  '';

  imports = [
    ./modules/ides
    ./modules/clis
    ./modules/browsers
    ./modules/terminals.nix
    ./modules/obsedian.nix
  ];
}
