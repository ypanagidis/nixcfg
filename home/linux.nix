{ pkgs, lib, ... }:

{
  imports = [
    ./common.nix
    ../modules/des
    ../modules/browsers
    ../modules/obsedian.nix
  ];

  home.packages =
    (with pkgs; [
      high-tide
      protonup-qt
      protontricks
      mangohud
      ffmpeg-full
      google-chrome
      haruna
      bruno
      opencode
      playwright-mcp
    ])
    # ++ lib.optionals (pkgs ? opencode) [ pkgs.opencode ]
    ++ lib.optionals (pkgs ? claude) [ pkgs.claude ]
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

  xdg.configFile."opencode/opencode.json".text = builtins.toJSON {
    "$schema" = "https://opencode.ai/config.json";
    mcp.playwright = {
      type = "local";
      command = [ "mcp-server-playwright" ];
      enabled = true;
    };
  };

  programs.ssh.matchBlocks.github.identityFile = "~/.ssh/id_ed25519";
}
