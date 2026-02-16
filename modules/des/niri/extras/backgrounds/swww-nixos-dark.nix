{ pkgs, ... }:

{
  services.swww.enable = true;

  home.packages = [
    (pkgs.writeShellScriptBin "set-wallpaper" ''
      set -eu

      wallpaper="${pkgs.nixos-artwork.wallpapers.nineish-dark-gray}/share/backgrounds/nixos/nix-wallpaper-nineish-dark-gray.png"

      for _ in $(seq 1 40); do
        if ${pkgs.swww}/bin/swww query >/dev/null 2>&1; then
          break
        fi
        sleep 0.15
      done

      if [ -f "$wallpaper" ]; then
        exec ${pkgs.swww}/bin/swww img "$wallpaper" --transition-type fade --transition-duration 0.6
      fi

      exec ${pkgs.swww}/bin/swww clear 0b0f14
    '')
  ];
}
