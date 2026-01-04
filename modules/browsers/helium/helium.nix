{ pkgs, ... }:

pkgs.appimageTools.wrapType2 {
  pname = "helium-browser";
  version = "0.7.7.1";
  src = pkgs.fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/0.7.7.1/helium-0.7.7.1-x86_64.AppImage";
    sha256 = "sha256-qEHUFzCwsCyFNLFCC62wo2x1lr/boAI/UDsaaNP1vrc="; # nix will tell you
  };
  extraPkgs =
    pkgs: with pkgs; [
      glib
      nss
      nspr
      at-spi2-atk
      cups
      dbus
      libdrm
      gtk3
      pango
      cairo
      xorg.libX11
      xorg.libXcomposite
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXrandr
      mesa
      alsa-lib
      libxkbcommon
      wayland
    ];
}
