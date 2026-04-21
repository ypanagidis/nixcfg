{
  pkgs,
  inputs,
  lib,
  ...
}:

let
  pkgsUnstable = import inputs.nixpkgs-unstable {
    inherit (pkgs) system;
    config = pkgs.config;
  };
  pkgsMaster = import inputs.nixpkgs-master {
    inherit (pkgs) system;
    config = pkgs.config;
  };
in
{
  _module.args.pkgsUnstable = pkgsUnstable;
  _module.args.pkgsMaster = pkgsMaster;

  home.stateVersion = "25.11";
  home.sessionPath = [ "$HOME/.local/bin" ];

  home.packages = (
    with pkgs;
    [
      pnpm
      nodejs
      pkgsMaster.codex
      remmina
      python3
      bun
      httpie
      pscale
    ]
  );

  programs.ssh = {
    enable = true;
    extraConfig = ''
      Include ~/.config/sealant/ssh_config
    '';
    enableDefaultConfig = false;
    matchBlocks = {
      "*" = {
        addKeysToAgent = "yes";
        hashKnownHosts = true;
      };
      github = {
        hostname = "github.com";
        user = "git";
        identitiesOnly = true;
      };
    };
  };

  imports = [
    ../modules/ides
    ../modules/clis
    ../modules/terminals.nix
  ];
}
