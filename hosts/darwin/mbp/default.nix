{ pkgs, ... }:

{
  imports = [
    ../../common/default.nix
  ];

  nixpkgs.hostPlatform = "aarch64-darwin";

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
      "ghostty"
      "google-chrome"
      "obsidian"
    ];

    masApps = { };
  };

  system.defaults = {
    dock.autohide = true;
    finder.AppleShowAllExtensions = true;
  };

  system.stateVersion = 6;
}
