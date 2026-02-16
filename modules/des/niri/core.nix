{ pkgs, ... }:

{
  home.packages = with pkgs; [
    wl-clipboard
    jq
    playerctl
    brightnessctl
  ];

  xdg.configFile."niri/config.kdl".text = ''
    input {
        keyboard {
            numlock
            repeat-delay 300
            repeat-rate 30
        }

        touchpad {
            tap
            natural-scroll
        }
    }

    output "Apple Computer Inc StudioDisplay 0x61E8A26E" {
        mode "5120x2880@60.000"
        scale 2
        position x=0 y=1080
    }

    output "Dell Inc. DELL P2719HC 5FDFSS2" {
        mode "1920x1080@60.000"
        scale 1
        position x=320 y=0
    }

    layout {
        gaps 8

        default-column-width { proportion 0.55; }

        focus-ring {
            width 2
            active-color "#7aa2f7"
            inactive-color "#3b4261"
        }

        border {
            off
        }
    }

    screenshot-path "~/Pictures/Screenshots/Screenshot from %Y-%m-%d %H-%M-%S.png"

    spawn-at-startup "mako"
    spawn-at-startup "set-wallpaper"

    binds {
        Mod+Return { spawn "ghostty"; }
        Alt+F1 { spawn "anyrun"; }
        Mod+D { spawn "anyrun"; }
        Mod+Shift+D { spawn "fuzzel"; }
        Mod+Tab { spawn "niriswitcher"; }
        Super+Alt+L { spawn "swaylock"; }

        Mod+1 { spawn-sh "focus-or-launch '^helium$' 'gtk-launch helium.desktop || helium || true'"; }
        Mod+2 { spawn-sh "focus-or-launch '^com[.]mitchellh[.]ghostty$|^ghostty$' 'ghostty'"; }
        Mod+3 {
            spawn-sh "focus-or-launch '^discord$|^discordcanary$|^com[.]discordapp[.]Discord$' 'gtk-launch discord.desktop || discord || true'";
        }
        Mod+4 {
            spawn-sh "focus-or-launch '^io[.]github[.]nokse22[.]high-tide$|^high-tide$' 'gtk-launch io.github.nokse22.high-tide.desktop || high-tide || true'";
        }
        Mod+5 { spawn-sh "focus-or-launch '^obsidian$|^md[.]obsidian[.]Obsidian$' 'gtk-launch obsidian.desktop || obsidian || true'"; }
        Mod+6 { spawn-sh "focus-or-launch '^jetbrains-datagrip$|^datagrip$|datagrip' 'gtk-launch datagrip.desktop || datagrip || true'"; }
        Mod+7 { spawn-sh "focus-or-launch '^bruno$|^com[.]usebruno[.]bruno$' 'gtk-launch bruno.desktop || bruno || true'"; }
        Mod+8 {
            spawn-sh "focus-or-launch '^systemsettings$|^org[.]kde[.]systemsettings$' 'gtk-launch systemsettings.desktop || systemsettings || true'";
        }
        Mod+9 {
            spawn-sh "focus-or-launch '^org[.]kde[.]dolphin$|^dolphin$|^org[.]gnome[.]Nautilus$|^nautilus$' 'xdg-open ~'";
        }

        Mod+Ctrl+Alt+Shift+A { spawn-sh "focus-or-launch '^helium$' 'gtk-launch helium.desktop || helium || true'"; }
        Mod+Ctrl+Alt+Shift+C { spawn-sh "focus-or-launch '^com[.]mitchellh[.]ghostty$|^ghostty$' 'ghostty'"; }
        Mod+Ctrl+Alt+Shift+G { spawn-sh "focus-or-launch '^com[.]mitchellh[.]ghostty$|^ghostty$' 'ghostty'"; }
        Mod+Ctrl+Alt+Shift+D {
            spawn-sh "focus-or-launch '^discord$|^discordcanary$|^com[.]discordapp[.]Discord$' 'gtk-launch discord.desktop || discord || true'";
        }
        Mod+Ctrl+Alt+Shift+T {
            spawn-sh "focus-or-launch '^io[.]github[.]nokse22[.]high-tide$|^high-tide$' 'gtk-launch io.github.nokse22.high-tide.desktop || high-tide || true'";
        }
        Mod+Ctrl+Alt+Shift+O { spawn-sh "focus-or-launch '^obsidian$|^md[.]obsidian[.]Obsidian$' 'gtk-launch obsidian.desktop || obsidian || true'"; }
        Mod+Ctrl+Alt+Shift+P {
            spawn-sh "focus-or-launch '^jetbrains-datagrip$|^datagrip$|datagrip' 'gtk-launch datagrip.desktop || datagrip || true'";
        }
        Mod+Ctrl+Alt+Shift+M { spawn-sh "focus-or-launch '^bruno$|^com[.]usebruno[.]bruno$' 'gtk-launch bruno.desktop || bruno || true'"; }
        Mod+Ctrl+Alt+Shift+R {
            spawn-sh "focus-or-launch '^systemsettings$|^org[.]kde[.]systemsettings$' 'gtk-launch systemsettings.desktop || systemsettings || true'";
        }

        Mod+Shift+S { spawn "raycast-speedtest"; }
        Mod+Shift+P { spawn "raycast-open-ports"; }
        Mod+Shift+I { spawn "raycast-public-ip"; }

        Mod+B { spawn-sh "pkill -SIGUSR1 waybar || true"; }

        XF86AudioRaiseVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05+ -l 1.0"; }
        XF86AudioLowerVolume allow-when-locked=true { spawn-sh "wpctl set-volume @DEFAULT_AUDIO_SINK@ 0.05-"; }
        XF86AudioMute allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SINK@ toggle"; }
        XF86AudioMicMute allow-when-locked=true { spawn-sh "wpctl set-mute @DEFAULT_AUDIO_SOURCE@ toggle"; }

        XF86AudioPlay allow-when-locked=true { spawn-sh "playerctl play-pause"; }
        XF86AudioStop allow-when-locked=true { spawn-sh "playerctl stop"; }
        XF86AudioPrev allow-when-locked=true { spawn-sh "playerctl previous"; }
        XF86AudioNext allow-when-locked=true { spawn-sh "playerctl next"; }

        XF86MonBrightnessUp allow-when-locked=true { spawn "brightnessctl" "set" "+10%"; }
        XF86MonBrightnessDown allow-when-locked=true { spawn "brightnessctl" "set" "10%-"; }

        Mod+Q repeat=false { close-window; }

        Mod+H { focus-column-left; }
        Mod+J { focus-window-down; }
        Mod+K { focus-window-up; }
        Mod+L { focus-column-right; }

        Mod+Ctrl+H { move-column-left; }
        Mod+Ctrl+J { move-window-down; }
        Mod+Ctrl+K { move-window-up; }
        Mod+Ctrl+L { move-column-right; }

        Mod+Shift+Left { move-column-to-monitor-left; }
        Mod+Shift+Down { move-column-to-monitor-down; }
        Mod+Shift+Up { move-column-to-monitor-up; }
        Mod+Shift+Right { move-column-to-monitor-right; }
        Mod+Shift+H { move-column-to-monitor-left; }
        Mod+Shift+J { move-column-to-monitor-down; }
        Mod+Shift+K { move-column-to-monitor-up; }
        Mod+Shift+L { move-column-to-monitor-right; }

        Ctrl+F1 { focus-workspace 1; }
        Ctrl+F2 { focus-workspace 2; }
        Ctrl+F3 { focus-workspace 3; }
        Ctrl+F4 { focus-workspace 4; }
        Ctrl+F5 { focus-workspace 5; }
        Ctrl+F6 { focus-workspace 6; }
        Ctrl+F7 { focus-workspace 7; }
        Ctrl+F8 { focus-workspace 8; }
        Ctrl+F9 { focus-workspace 9; }

        Mod+Ctrl+1 { move-column-to-workspace 1; }
        Mod+Ctrl+2 { move-column-to-workspace 2; }
        Mod+Ctrl+3 { move-column-to-workspace 3; }
        Mod+Ctrl+4 { move-column-to-workspace 4; }
        Mod+Ctrl+5 { move-column-to-workspace 5; }
        Mod+Ctrl+6 { move-column-to-workspace 6; }
        Mod+Ctrl+7 { move-column-to-workspace 7; }
        Mod+Ctrl+8 { move-column-to-workspace 8; }
        Mod+Ctrl+9 { move-column-to-workspace 9; }

        Mod+V { toggle-window-floating; }
        Mod+F { maximize-column; }
        Mod+Shift+F { fullscreen-window; }
        Mod+C { center-column; }

        Print { screenshot; }
        Ctrl+Print { screenshot-screen; }
        Alt+Print { screenshot-window; }

        Mod+Shift+E { quit; }
    }
  '';
}
