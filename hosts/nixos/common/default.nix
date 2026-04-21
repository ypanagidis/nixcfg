{ ... }:

{
  imports = [
    ./core.nix
    ./des
    ./services.nix
    ../../../modules/electron.nix
    ../../../modules/minecraft.nix
  ];
}
