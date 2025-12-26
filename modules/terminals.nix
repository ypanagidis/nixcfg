{ config, pkgs, ... }:

{
  programs.ghostty = {
    enable = true;
    settings = {
      font-size = 14;
      theme = "Ayu Mirage";
      gtk-titlebar-hide-when-maximized = true;
    };
  };
}
