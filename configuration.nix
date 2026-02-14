{ ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./system/nixos/common.nix
    ./system/nixos/desktop.nix
    ./system/nixos/services.nix
    ./modules/steam.nix
    ./modules/crapple-display.nix
    ./modules/kdeconnect.nix
    ./modules/sunshine.nix
  ];

  system.stateVersion = "25.11";
}
