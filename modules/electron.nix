{ pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    electron
  ];

  programs.nix-ld = {
    enable = true;

    # Runtime libs for Electron binaries distributed outside nixpkgs
    # (for example node_modules/.pnpm/electron/.../dist/electron).
    libraries = with pkgs; [
      stdenv.cc.cc
      zlib
      glib
      nss
      nspr
      dbus
      expat
      gtk3
      gdk-pixbuf
      cairo
      pango
      atk
      at-spi2-atk
      at-spi2-core
      libdrm
      libgbm
      mesa
      libglvnd
      xorg.libX11
      xorg.libXcomposite
      xorg.libXdamage
      xorg.libXext
      xorg.libXfixes
      xorg.libXrandr
      xorg.libXcursor
      xorg.libXi
      xorg.libXrender
      xorg.libXScrnSaver
      xorg.libxshmfence
      xorg.libXtst
      xorg.libxcb
      xorg.libxkbfile
      libxkbcommon
      wayland
      alsa-lib
      cups
      libsecret
      libnotify
      libappindicator-gtk3
      pipewire
      fontconfig
      freetype
      harfbuzz
      ffmpeg
    ];
  };
}
