{ pkgs, ... }:

{
  services.xserver.enable = true;
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.kdePackages.xdg-desktop-portal-kde ];
  };

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

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
}
