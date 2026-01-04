{ pkgs, ... }:
{
  home.packages = [
    (import ./helium.nix { inherit pkgs; })
  ];

  xdg.desktopEntries.helium-browser = {
    name = "Helium";
    genericName = "Web Browser";
    exec = "helium-browser";
    terminal = false;
    categories = [
      "Network"
      "WebBrowser"
    ];
    icon = ./helium.png; # grab one from their repo or website
  };
}
