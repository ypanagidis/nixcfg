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
      # settings.appearance = {
      #   # Put whatever your appearance.json uses (often something like theme/cssTheme/etc.)
      #   # Example placeholder:
      #   # cssTheme = "Minimal";
      # };

      # Optional: HM-managed themes (installs + can set active)
      # settings.themes.minimal = {
      #   pkg = ...;   # theme package derivation
      #   enable = true;
      # };
    };
  };
}
