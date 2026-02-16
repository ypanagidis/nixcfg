{ pkgs, ... }:

{
  services.swww.enable = true;

  home.packages = [
    (pkgs.writeShellScriptBin "set-wallpaper" ''
      set -eu

      wallpaper="${pkgs.nixos-artwork.wallpapers.waterfall}/share/backgrounds/nixos/nix-wallpaper-waterfall.png"

      for _ in $(seq 1 40); do
        if ${pkgs.swww}/bin/swww query >/dev/null 2>&1; then
          break
        fi
        sleep 0.15
      done

      if [ -f "$wallpaper" ]; then
        exec ${pkgs.swww}/bin/swww img "$wallpaper" --transition-type wipe --transition-angle 30 --transition-duration 0.8
      fi

      exec ${pkgs.swww}/bin/swww clear 0b0f14
    '')
  ];
}
