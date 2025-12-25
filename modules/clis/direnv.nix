{ pkgs, ... }:

{
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true; # Critical for speed & caching
  };
}
