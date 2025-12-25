{ pgks, ... }:
{

  programs.btop = {
    enable = true;
    themes = {
      catppuccin-latte = ./catppuccin-latte.theme;
    };

    settings = {
      color_theme = 'catppuccin-latte'
    };
  };
}
