{
  programs.obsidian = {
    enable = true;

    vaults.notes = {
      enable = true;
      target = "Documents/Obsidian/notes";

      # Keys here are written into .obsidian/app.json
      settings.app = {
        # Use the exact key name you see in your vault’s .obsidian/app.json
        vimMode = true;
      };

      # Keys here are written into .obsidian/appearance.json
      settings.appearance = {
        cssTheme = "Ayu Mirage";
      };
    };
  };
}
