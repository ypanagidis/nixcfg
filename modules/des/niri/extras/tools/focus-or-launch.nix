{ pkgs, ... }:

{
  home.packages = [
    (pkgs.writeShellScriptBin "focus-or-launch" ''
      set -euo pipefail

      if [ "$#" -lt 2 ]; then
        printf 'usage: %s <app-id-regex> <launch-command>\n' "$0" >&2
        exit 2
      fi

      app_id_regex="$1"
      launch_cmd="$2"

      window_id="$(${pkgs.niri}/bin/niri msg -j windows | ${pkgs.jq}/bin/jq -r --arg re "$app_id_regex" '
        map(select((.app_id // "") | test($re)))
        | if length == 0 then
            empty
          else
            max_by([(.focus_timestamp.secs // 0), (.focus_timestamp.nanos // 0)]).id
          end
      ')"

      if [ -n "$window_id" ]; then
        exec ${pkgs.niri}/bin/niri msg action focus-window --id "$window_id"
      fi

      exec ${pkgs.bash}/bin/bash -lc "$launch_cmd"
    '')
  ];
}
