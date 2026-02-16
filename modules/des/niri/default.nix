{ ... }:

{
  imports = [
    ./core.nix

    ./extras/backgrounds/swww-nixos-dark.nix
    # ./extras/backgrounds/swww-nixos-waterfall.nix

    ./extras/notifications/mako.nix
    ./extras/auth/polkit-gnome.nix
    ./extras/idle/swayidle.nix
    ./extras/tools/network-actions.nix
    ./extras/tools/focus-or-launch.nix
    ./extras/switcher/niriswitcher.nix

    ./extras/launchers/anyrun.nix
    ./extras/launchers/fuzzel.nix

    ./extras/bars/waybar-rice-oled.nix
    # ./extras/bars/waybar-minimal-focus.nix
    # ./extras/bars/waybar-minimal-stats.nix
  ];
}
