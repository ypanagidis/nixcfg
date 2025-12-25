{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
  ];

  # Enable flakes system-wide
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "nixos";
  networking.networkmanager.enable = true;

  # Time zone / locales
  time.timeZone = "Europe/Athens";

  i18n.defaultLocale = "en_US.UTF-8";

  # X11 + KDE Plasma 6
  services.xserver.enable = true;

  services.displayManager.sddm.enable = true;
  services.desktopManager.plasma6.enable = true;

  services.xserver.xkb = {
    layout = "us";
    variant = "";
  };

  services.keyd = {
    enable = true;
    keyboards.default = {
      ids = [ "*" ];
      settings.main = {
        "leftalt+backspace" = "C-backspace";
        "rightalt+backspace" = "C-backspace"; # optional
      };
    };
  };

  # Allow unfree packages (needed for NVIDIA + Discord)
  nixpkgs.config.allowUnfree = true;

  # NVIDIA
  services.xserver.videoDrivers = [ "nvidia" ];
  hardware.graphics.enable = true;

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;

    # If RTX 5060 requires newer driver, switch to beta
    package = config.boot.kernelPackages.nvidiaPackages.production;
    # package = config.boot.kernelPackages.nvidiaPackages.beta;

    open = true;
  };

  # Printing
  services.printing.enable = true;

  # Thunderbolt/USB4 authorization helper (useful for Studio Display)
  services.hardware.bolt.enable = true;

  # Audio: PipeWire
  services.pulseaudio.enable = false; # renamed from hardware.pulseaudio
  security.rtkit.enable = true;

  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    wireplumber.enable = true;
  };

  # User
  users.users.yiannis = {
    isNormalUser = true;
    description = "Yiannis Panagidis";
    extraGroups = [
      "networkmanager"
      "wheel"
    ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  # Firefox via module
  programs.firefox.enable = true;

  # System packages (VS Code is managed via Home Manager in /etc/nixos/home.nix)
  environment.systemPackages = with pkgs; [
    vim
    chromium
    discord

    # Tools you were missing earlier
    usbutils # lsusb
    pciutils # lspci
    alsa-utils # aplay
    pulseaudio # pactl (works with pipewire-pulse)
    pavucontrol

    # Dev basics
    git
    curl
    wget
    unzip
    zip
    jq
    ripgrep
    fd
    htop

    # Nix tooling (used by VS Code settings)
    nil
    alejandra
  ];

  system.stateVersion = "25.11";
}
