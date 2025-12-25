{
  pkgs ? import <nixpkgs> { },
}:

pkgs.appimageTools.wrapType2 {
  name = "cursor";
  version = "latest"; # We don't care about versions here

  src = pkgs.fetchurl {
    url = "https://api2.cursor.sh/updates/download/golden/linux-x64/cursor/2.2";
    sha256 = "1xmax9j52jynzi29hpr133rg992gbsml445f7vixvwy4mcpp8aw6";
  };

  extraPkgs =
    pkgs: with pkgs; [
      libsecret
      libnotify
      libappindicator-gtk3
    ];
}
