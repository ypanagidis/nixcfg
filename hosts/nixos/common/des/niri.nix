{ pkgs, ... }:

{
  services.xserver.enable = true;

  services.displayManager.sddm.enable = true;
  services.displayManager.defaultSession = "niri";

  programs.niri = {
    enable = true;
    useNautilus = false;
  };

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.keyd = {
    enable = true;
    keyboards = {
      default = {
        ids = [ "*" ];
        settings = {
          main = {
            leftalt = "layer(alt_nav)";
            rightalt = "layer(alt_nav)";
            leftmeta = "layer(cmd_nav)";
            rightmeta = "layer(cmd_nav)";
          };
          "alt_nav:A" = {
            left = "C-left";
            right = "C-right";
            backspace = "C-backspace";
          };
          "cmd_nav:M" = {
            left = "home";
            right = "end";
            backspace = "macro(S-home backspace)";
          };
        };
      };
    };
  };

  services.pulseaudio.enable = false;
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  environment.systemPackages = with pkgs; [
    xwayland-satellite
  ];
}
