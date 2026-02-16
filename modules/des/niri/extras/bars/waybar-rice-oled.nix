{
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    settings = [
      {
        layer = "top";
        position = "top";
        mode = "dock";
        exclusive = true;
        height = 32;
        spacing = 10;
        margin-top = 0;
        margin-left = 8;
        margin-right = 8;
        on-sigusr1 = "toggle";
        reload_style_on_change = true;

        modules-left = [ "niri/workspaces" ];
        modules-center = [ "niri/window" ];
        modules-right = [
          "pulseaudio"
          "network"
          "clock"
        ];

        "niri/workspaces" = {
          format = "{icon}";
          format-icons = {
            focused = "◉";
            active = "●";
            default = "○";
          };
        };

        "niri/window" = {
          format = "{}";
          separate-outputs = true;
          max-length = 90;
          rewrite = {
            "^null$" = "Desktop";
            "^$" = "Desktop";
          };
        };

        network = {
          format-wifi = "NET {signalStrength}%";
          format-ethernet = "NET {ipaddr}";
          format-disconnected = "NET down";
          tooltip-format = "{ifname} {ipaddr}/{cidr}";
        };

        pulseaudio = {
          format = "VOL {volume}%";
          format-muted = "VOL mute";
        };

        clock = {
          format = "{:%a %H:%M}";
          tooltip-format = "{:%A %d %B %Y %H:%M}";
        };
      }
    ];

    style = ''
      * {
        font-family: "JetBrainsMono Nerd Font";
        font-size: 12px;
        min-height: 0;
        border: none;
        border-radius: 0;
        box-shadow: none;
      }

      window#waybar {
        background: rgba(7, 10, 14, 0.22);
        color: rgba(235, 219, 178, 0.95);
        border: 1px solid rgba(235, 219, 178, 0.12);
        border-radius: 10px;
        margin-top: -30px;
        transition-property: margin-top, background-color, border-color;
        transition-duration: 170ms;
      }

      window#waybar:hover {
        margin-top: 0;
        background: rgba(7, 10, 14, 0.62);
        border-color: rgba(235, 219, 178, 0.26);
      }

      #workspaces,
      #window,
      #pulseaudio,
      #network,
      #clock {
        background: transparent;
        padding: 0 8px;
      }

      #workspaces {
        margin-left: 6px;
      }

      #workspaces button {
        color: rgba(235, 219, 178, 0.64);
        padding: 0 7px;
        background: transparent;
      }

      #workspaces button.active,
      #workspaces button.focused {
        color: rgba(184, 187, 38, 0.98);
      }

      #window {
        color: rgba(235, 219, 178, 0.92);
      }

      #clock {
        margin-right: 6px;
      }

      tooltip {
        background: rgba(7, 10, 14, 0.94);
        border: 1px solid rgba(235, 219, 178, 0.24);
      }
    '';
  };
}
