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
      high-tide
      python3
      bun
      bruno
      pscale
    ])
    ++ lib.optionals (pkgs ? opencode) [ pkgs.opencode ]
    ++ lib.optionals (pkgs ? claude) [ pkgs.claude ];

  imports = [
    ../modules/ides
    ../modules/clis
    ../modules/terminals.nix
  ];
}
