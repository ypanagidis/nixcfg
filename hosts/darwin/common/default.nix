{ pkgs, ... }:

{
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

    brews = [
      "mas"
      "opencode"
      "duti"
    ];

    casks = [
      "cursor"
      "datagrip"
      "discord"
      "claude-code"
      "ghostty"
      "google-chrome"
      "helium-browser"
      "httpie"
      "karabiner-elements"
      "obsidian"
      "raycast"
      "tableplus"
      "tidal"
    ];

    masApps = { };
  };

  system.defaults = {
    CustomUserPreferences = {
      "com.apple.symbolichotkeys" = {
        AppleSymbolicHotKeys = {
          "64" = {
            enabled = false;
          };
          "65" = {
            enabled = false;
          };
        };
      };
    };

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

  system.activationScripts.setDefaultBrowser.text = ''
    if [ -x /run/current-system/sw/bin/duti ] && [ -d /Applications/Helium.app ]; then
      /usr/bin/sudo -u yiannis /run/current-system/sw/bin/duti -s net.imput.helium http all || true
      /usr/bin/sudo -u yiannis /run/current-system/sw/bin/duti -s net.imput.helium https all || true
      /usr/bin/sudo -u yiannis /run/current-system/sw/bin/duti -s net.imput.helium public.html all || true
      /usr/bin/sudo -u yiannis /run/current-system/sw/bin/duti -s net.imput.helium public.url all || true
    fi
  '';
}
