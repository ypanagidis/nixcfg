{
  programs.fuzzel = {
    enable = true;
    settings = {
      main = {
        terminal = "ghostty";
        layer = "overlay";
        font = "JetBrainsMono Nerd Font:size=12";
        width = 48;
        lines = 12;
        prompt = "> ";
        icon-theme = "Papirus-Dark";
      };

      border = {
        width = 1;
        radius = 10;
      };

      colors = {
        background = "11121af2";
        text = "e5e9f0ff";
        match = "7aa2f7ff";
        selection = "1f2335ff";
        selection-text = "e5e9f0ff";
        selection-match = "7aa2f7ff";
        border = "7aa2f7ff";
      };
    };
  };
}
