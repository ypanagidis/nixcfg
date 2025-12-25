{ config, pkgs, ... }:

{
  programs.ghostty = {
    enable = true;
    settings = {
      font-size = 14;
      theme = "Night Owlish Light";
    };
  };
}
