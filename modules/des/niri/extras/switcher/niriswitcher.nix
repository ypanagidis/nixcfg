{
  programs.niriswitcher = {
    enable = true;
    settings = {
      center_on_focus = true;
      appearance = {
        icon_size = 48;
        system_theme = "dark";
      };
    };

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
      }

      #container {
        background: rgba(17, 18, 26, 0.94);
        border: 1px solid #7aa2f7;
        border-radius: 12px;
        padding: 10px;
      }
    '';
  };
}
