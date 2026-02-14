{ ... }:

{
  imports = [
    ../../common/default.nix
    ../common/default.nix
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";

  networking.hostName = "yiannis-mbp";
  networking.localHostName = "yiannis-mbp";
  networking.computerName = "yiannis-mbp";

  system.stateVersion = 6;
}
