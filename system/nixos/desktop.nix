{ config, pkgs, ... }:

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

  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;
    package = config.boot.kernelPackages.nvidiaPackages.production;
    open = true;
    powerManagement = {
      enable = true;
      finegrained = false;
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

  hardware.apple-studio-display.enable = true;

  services.hardware.openrgb = {
    enable = true;
  };

  programs.coolercontrol.enable = true;
}
