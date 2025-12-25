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

  # 3. ADD THIS SECTION (Desktop Entry & Icon)
  # This generates ~/.local/share/applications/cursor.desktop
  xdg.desktopEntries.cursor = {
    name = "Cursor";
    genericName = "Code Editor";
    exec = "cursor"; # This binary name comes from 'pname' in your cursor.nix
    terminal = false;
    categories = [ "Development" ];

    # Ensure you have 'cursor.png' inside the 'cursor/' folder!
    icon = ./cursor.png;
  };
}
