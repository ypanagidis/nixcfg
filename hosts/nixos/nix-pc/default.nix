{ ... }:

{
  imports = [
    ../../common/default.nix
    ../common/default.nix
    ../../../hardware-configuration.nix
    ./system/host-specific.nix
    ../../../modules/steam.nix
    ../../../modules/crapple-display.nix
    ../../../modules/kdeconnect.nix
    ../../../modules/sunshine.nix
  ];

  system.stateVersion = "25.11";
}
