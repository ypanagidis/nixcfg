{
  config,
  pkgs,
  lib,
  options,
  ...
}:

let
  hasGraphics = lib.hasAttrByPath [ "hardware" "graphics" ] options;
  hasOpenGL = lib.hasAttrByPath [ "hardware" "opengl" ] options;
in
{
  # Steam is unfree
  nixpkgs.config.allowUnfree = true;

  programs.steam = {
    enable = true;

    # Optional but handy:
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;

    # Declaratively install a custom Proton (GE) that shows up in Steam
    extraCompatPackages = with pkgs; [
      proton-ge-bin
    ];
  };

  # Usually enabled implicitly by programs.steam, but explicit is fine
  hardware.steam-hardware.enable = true;

  # Graphics driver plumbing + 32-bit (needed for many games)
  # Newer NixOS:
  config = lib.mkMerge [
    (lib.optionalAttrs hasGraphics {
      hardware.graphics.enable = true;
      hardware.graphics.enable32Bit = true;
    })

    # Older NixOS:
    (lib.optionalAttrs hasOpenGL {
      hardware.opengl.enable = true;
      hardware.opengl.driSupport = true;
      hardware.opengl.driSupport32Bit = true;
    })
  ];

  # Nice-to-have for performance
  programs.gamemode.enable = true;
}
