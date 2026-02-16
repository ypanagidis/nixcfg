{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = [
      {
        layer = "top";
        position = "top";
        mode = "overlay";
        exclusive = false;
        height = 28;
        spacing = 8;

        modules-left = [ "niri/workspaces" ];
        modules-center = [ "niri/window" ];
        modules-right = [ "clock" ];

        "niri/workspaces" = {
          format = "{index}";
        };

        "niri/window" = {
          format = "{}";
          separate-outputs = true;
        };

        clock = {
          format = "{:%H:%M}";
          tooltip-format = "{:%A %d %B %Y %H:%M}";
        };
      }
    ];

    style = ''
      * {
        border: none;
        border-radius: 0;
        font-family: "JetBrainsMono Nerd Font";
        font-size: 12px;
        min-height: 0;
        box-shadow: none;
      }

      window#waybar {
        background: transparent;
        color: #e5e9f0;
        border-bottom: 1px solid rgba(122, 162, 247, 0.20);
        opacity: 0.03;
        transition-property: opacity, border-bottom-color, background-color;
        transition-duration: 160ms;
      }

      window#waybar:hover {
        background: rgba(17, 18, 26, 0.58);
        border-bottom-color: rgba(122, 162, 247, 0.75);
        opacity: 1;
      }

      #workspaces {
        margin-left: 6px;
        background: transparent;
      }

      #workspaces button {
        color: #a9b1d6;
        padding: 0 8px;
        background: transparent;
      }

      #workspaces button.focused {
        color: #7aa2f7;
      }

      #window {
        color: #c0caf5;
        padding: 0 10px;
        background: transparent;
      }

      #clock {
        color: #c0caf5;
        margin-right: 10px;
        padding: 0 8px;
        background: transparent;
      }
    '';
  };
}
