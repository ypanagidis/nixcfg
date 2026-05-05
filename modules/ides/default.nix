{ pkgs, lib, ... }:

let
  pname = "opencode-desktop";
  version = "downloaded";
  src = builtins.path {
    path = ./opencode-desktop-linux-x86_64.AppImage;
    name = "opencode-desktop-linux-x86_64.AppImage";
  };

  opencodeDesktop = pkgs.appimageTools.wrapType2 {
    inherit pname version src;

    extraPkgs =
      pkgs: with pkgs; [
        libnotify
        libsecret
        libappindicator-gtk3
        xorg.libxkbfile
      ];

    meta = {
      description = "Desktop GUI for opencode";
      homepage = "https://github.com/anomalyco/opencode";
      license = lib.licenses.mit;
      platforms = [ "x86_64-linux" ];
      mainProgram = pname;
    };
  };

  appimageContents = pkgs.appimageTools.extractType2 { inherit pname version src; };
in
{
  imports = [
    ./cursor
    ./t3
    ./vscode
    ./nvim-config/neovim.nix
    ./datagrip/datagrip.nix
    ./intellij
  ];

  home.packages = lib.optionals pkgs.stdenv.isLinux [ opencodeDesktop ];

  xdg.desktopEntries.opencode-desktop = lib.mkIf pkgs.stdenv.isLinux {
    name = "OpenCode";
    genericName = "AI Coding Agent";
    comment = "Desktop GUI for opencode";
    exec = "${opencodeDesktop}/bin/${pname} --no-sandbox %U";
    terminal = false;
    categories = [ "Development" ];
    mimeType = [ "x-scheme-handler/opencode" ];
    settings.StartupWMClass = "OpenCode";
    icon = "${appimageContents}/usr/share/icons/hicolor/310x310/apps/@opencode-aidesktop.png";
  };
}
