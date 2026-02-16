{
  programs.anyrun = {
    enable = true;
    config = {
      plugins = [
        "libapplications.so"
        "libsymbols.so"
        "libshell.so"
      ];
      x.fraction = 0.5;
      y.absolute = 12;
      width.absolute = 720;
      height.absolute = 1;
      hidePluginInfo = true;
      maxEntries = 8;
    };

    extraConfigFiles."applications.ron".text = ''
      Config(
        desktop_actions: true,
        max_entries: 8,
        terminal: Some("ghostty"),
      )
    '';

    extraCss = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 14px;
      }

      #window {
        background: transparent;
      }

      box#main {
        background: rgba(17, 18, 26, 0.95);
        border: 1px solid #7aa2f7;
        border-radius: 12px;
        padding: 10px;
      }

      list#main {
        background: transparent;
      }

      box.plugin:first-child {
        margin-top: 6px;
      }
    '';
  };
}
