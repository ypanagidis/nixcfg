{
  programs.obsidian = {
    enable = true;

    vaults.notes = {
      enable = true;
      target = "Documents/Obsidian/Main/Notes";

      # Keys here are written into .obsidian/app.json
      settings.app = {
        # Use the exact key name you see in your vault’s .obsidian/app.json
        vimMode = true;
        newFileLocation = "folder";
        newFileFolderPath = "Main Notes";
      };

      # Keys here are written into .obsidian/appearance.json
      settings.appearance = {
        cssTheme = "AnuPpuccin";
      };

      settings.corePlugins = [
        {
          name = "file-explorer";
          enable = true;
        }
        {
          name = "global-search";
          enable = true;
        }
        {
          name = "switcher";
          enable = true;
        }
        {
          name = "graph";
          enable = true;
          settings = {
            collapse-filter = true;
            search = "";
            showTags = false;
            showAttachments = false;
            hideUnresolved = false;
            showOrphans = true;
            collapse-color-groups = true;
            colorGroups = [ ];
            collapse-display = true;
            showArrow = false;
            textFadeMultiplier = 0;
            nodeSizeMultiplier = 1;
            lineSizeMultiplier = 1;
            collapse-forces = true;
            centerStrength = 0.518713248970312;
            repelStrength = 10;
            linkStrength = 1;
            linkDistance = 250;
            scale = 2.2499999999999964;
            close = true;
          };
        }
        {
          name = "backlink";
          enable = true;
          settings = {
            backlinkInDocument = true;
          };
        }
        {
          name = "canvas";
          enable = true;
        }
        {
          name = "outgoing-link";
          enable = true;
        }
        {
          name = "tag-pane";
          enable = true;
        }
        {
          name = "properties";
          enable = true;
        }
        {
          name = "page-preview";
          enable = true;
        }
        {
          name = "daily-notes";
          enable = true;
        }
        {
          name = "templates";
          enable = true;
          settings = {
            folder = "Templates";
          };
        }
        {
          name = "note-composer";
          enable = true;
        }
        {
          name = "command-palette";
          enable = true;
        }
        {
          name = "slash-command";
          enable = false;
        }
        {
          name = "editor-status";
          enable = true;
        }
        {
          name = "bookmarks";
          enable = true;
        }
        {
          name = "markdown-importer";
          enable = false;
        }
        {
          name = "zk-prefixer";
          enable = false;
        }
        {
          name = "random-note";
          enable = false;
        }
        {
          name = "outline";
          enable = true;
        }
        {
          name = "word-count";
          enable = true;
        }
        {
          name = "slides";
          enable = false;
        }
        {
          name = "audio-recorder";
          enable = false;
        }
        {
          name = "workspaces";
          enable = false;
        }
        {
          name = "file-recovery";
          enable = true;
        }
        {
          name = "publish";
          enable = false;
        }
        {
          name = "sync";
          enable = true;
        }
      ];

      settings.hotkeys = {
        "insert-template" = [
          {
            modifiers = [
              "Mod"
              "Shift"
            ];
            key = "T";
          }
        ];
        "workspace:undo-close-pane" = [ ];
      };
    };
  };
}
