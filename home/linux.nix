{ pkgs, lib, ... }:

{
  imports = [
    ./common.nix
    ../modules/browsers
    ../modules/obsedian.nix
  ];

  home.packages =
    (with pkgs; [
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
    RDP_PASS="(move this to a secret file)"
    RDP_DOMAIN=""
    RDP_IP="192.168.122.85"
    WAFLAVOR="libvirt"
  '';
}
