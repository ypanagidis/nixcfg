{ pkgs, lib, ... }:

{
  imports = [
    ./common.nix
    ../modules/browsers
    ../modules/obsedian.nix
  ];

  home.packages =
    (with pkgs; [
      high-tide
      protonup-qt
      protontricks
      mangohud
      google-chrome
      haruna
    ])
    ++ lib.optionals (pkgs ? winapps) [
      pkgs.winapps
      pkgs.winapps-launcher
    ];

  xdg.configFile."winapps/winapps.conf".text = ''
    RDP_USER="yiannis"
    RDP_PASS="fuckwindows"
    RDP_DOMAIN=""
    RDP_IP="192.168.122.85"
    WAFLAVOR="libvirt"
  '';

  programs.ssh.matchBlocks.github.identityFile = "~/.ssh/id_ed25519";
}
