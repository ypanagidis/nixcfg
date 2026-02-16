{ pkgs, ... }:

let
  mkQuickAction =
    name: command:
    pkgs.writeShellScriptBin name ''
      exec ${pkgs.ghostty}/bin/ghostty -e ${pkgs.bash}/bin/bash -lc '${command}; printf "\nPress Enter to close..."; read -r'
    '';
in
{
  home.packages = [
    (mkQuickAction "raycast-speedtest" "${pkgs.ookla-speedtest}/bin/speedtest --accept-license --accept-gdpr")
    (mkQuickAction "raycast-open-ports" "${pkgs.iproute2}/bin/ss -tulpen")
    (mkQuickAction "raycast-public-ip" "${pkgs.curl}/bin/curl -s https://api.ipify.org")
  ];

  xdg.desktopEntries = {
    raycast-speedtest = {
      name = "Network Speed Test";
      genericName = "Quick Action";
      exec = "raycast-speedtest";
      terminal = false;
      icon = "network-workgroup";
      categories = [
        "Network"
        "Utility"
      ];
    };

    raycast-open-ports = {
      name = "Open Ports";
      genericName = "Quick Action";
      exec = "raycast-open-ports";
      terminal = false;
      icon = "network-server";
      categories = [
        "Network"
        "System"
      ];
    };

    raycast-public-ip = {
      name = "Public IP";
      genericName = "Quick Action";
      exec = "raycast-public-ip";
      terminal = false;
      icon = "network-wireless";
      categories = [
        "Network"
        "Utility"
      ];
    };
  };
}
