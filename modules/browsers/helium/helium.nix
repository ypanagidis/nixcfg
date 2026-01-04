{ pkgs, ... }:

pkgs.appimageTools.wrapType2 {
  pname = "helium-browser";
  version = "0.7.9.1";
  src = pkgs.fetchurl {
    url = "https://github.com/imputnet/helium-linux/releases/download/0.7.9.1/helium-0.7.9.1-x86_64.AppImage";
    sha256 = "08vgld73dyzf6yg9rswxqza6rnii1ck97wvjha3ly9jgs9sbrp7b"; # nix will tell you
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
