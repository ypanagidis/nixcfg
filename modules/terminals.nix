{ config, pkgs, ... }:

{
  programs.ghostty = {
    enable = true;
    settings = {
      font-size = 14;
      theme = "Ayu Mirage";
      window-decoration = false;
      gtk-titlebar = false;
    };
  };
}
