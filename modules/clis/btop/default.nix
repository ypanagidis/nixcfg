{ ... }:
{

  programs.btop = {
    enable = true;
    themes = {
      catppuccin-latte = ./catppuccin_latte.theme;
      ayu-mirage = ./ayu-mirage.theme;
    };

    settings = {
      color_theme = "ayu-mirage";
    };
  };
}
