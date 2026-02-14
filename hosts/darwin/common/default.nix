{ pkgs, ... }:

{
  services.karabiner-elements.enable = true;

  users.users.yiannis.home = "/Users/yiannis";
  system.primaryUser = "yiannis";

  environment.systemPackages = with pkgs; [
    git
    curl
    wget
    jq
  ];

  homebrew = {
    enable = true;

    onActivation = {
      autoUpdate = true;
      upgrade = true;
      cleanup = "zap";
    };

    taps = [
      "homebrew/core"
      "homebrew/cask"
    ];

    brews = [
      "mas"
    ];

    casks = [
      "cursor"
      "datagrip"
      "discord"
      "ghostty"
      "google-chrome"
      "helium"
      "httpie"
      "obsidian"
      "raycast"
      "tableplus"
      "tidal"
    ];

    masApps = { };
  };

  system.defaults = {
    NSGlobalDomain = {
      KeyRepeat = 1;
      InitialKeyRepeat = 10;
      ApplePressAndHoldEnabled = false;
    };

    dock = {
      autohide = true;
      persistent-apps = [
        "/System/Library/CoreServices/Finder.app"
        "/Applications/Helium.app"
        "/Applications/Ghostty.app"
        "/Applications/HTTPie.app"
        "/Applications/TablePlus.app"
        "/Applications/DataGrip.app"
        "/Applications/TIDAL.app"
      ];
      persistent-others = [
        "/Applications"
        "/Users/yiannis/Downloads"
      ];
    };
    finder.AppleShowAllExtensions = true;
  };
}
