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
in
{
  _module.args.pkgsUnstable = pkgsUnstable;

  home.stateVersion = "25.11";
  home.sessionPath = [ "$HOME/.local/bin" ];

  home.packages =
    (with pkgs; [
      pnpm
      nodejs
      python3
      bun
      httpie
      pscale
    ])
    ++ lib.optionals (pkgs ? opencode) [ pkgs.opencode ]
    ++ lib.optionals (pkgs ? claude) [ pkgs.claude ];

  programs.ssh = {
    enable = true;
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
