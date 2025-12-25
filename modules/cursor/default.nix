{ pkgs, ... }:

{
  # 1. Install your custom Cursor package
  home.packages = [
    (import ./cursor.nix { inherit pkgs; })
  ];

  # 2. Symlink your existing JSON files
  # Cursor reads config from ~/.config/Cursor/User/ on Linux
  xdg.configFile."Cursor/User/settings.json".source = ./settings.json;
  xdg.configFile."Cursor/User/keybindings.json".source = ./keybindings.json;
}
