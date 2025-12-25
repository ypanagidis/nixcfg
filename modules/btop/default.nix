{ pgks, ... }:
{

  programs.btop = {
    enable = true;
    themes = {
      catppuccin-latte = ./catppuccin_latte.theme;
    };

    settings = {
      color_theme = "catppuccin-latte";
    };
  };
}
