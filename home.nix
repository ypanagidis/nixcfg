{
  config,
  pkgs,
  inputs,
  ...
}:

let
  pkgsUnstable = import inputs.nixpkgs-unstable {
    inherit (pkgs) system;
    config = pkgs.config;
  };
in
{

  _module.args.pkgsUnstable = pkgsUnstable;
  home.stateVersion = "25.11";

  home.sessionPath = [ "$HOME/.local/bin" ];

  home.packages = with pkgs; [
    protonup-qt
    protontricks
    mangohud
    pnpm
    nodejs
    google-chrome
    high-tide
    opencode
    python3
    bun
    claude
    winapps
    winapps-launcher
    bruno
    haruna
    # example: pull ONE package from unstable:
    # pkgsUnstable.<packageName>
  ];

  xdg.configFile."winapps/winapps.conf".text = ''
    RDP_USER="yiannis"
    RDP_PASS="(move this to a secret file)"
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
