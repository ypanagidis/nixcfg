{ pkgs, lib, ... }:

lib.mkMerge [
  (lib.mkIf pkgs.stdenv.isLinux {
    programs.ghostty = {
      enable = true;
      settings = {
        font-size = 14;
        theme = "Ayu Mirage";
        window-decoration = false;
        gtk-titlebar = false;
        copy-on-select = "clipboard";
      };
    };
  })

  (lib.mkIf pkgs.stdenv.isDarwin {
    xdg.configFile."ghostty/config".text = ''
      font-size = 14
      theme = Ayu Mirage
      window-decoration = false
      copy-on-select = clipboard
    '';
  })
]
