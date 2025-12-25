{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/steam.nix
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
  hardware.graphics = {
    enable = true;
    enable32Bit = true;
  };

  hardware.nvidia = {
    modesetting.enable = true;
    nvidiaSettings = true;

    # If RTX 5060 requires newer driver, switch to beta
    package = config.boot.kernelPackages.nvidiaPackages.production;
    # package = config.boot.kernelPackages.nvidiaPackages.beta;

    open = true;
  };

  #Kernel Modules
  boot.kernelModules = [
    "k10temp"
    "asus_ec_sensors"
  ];

  boot.kernelParams = [
    "mem_sleep_default=s2idle"
    "usbcore.autosuspend=-1"
  ];

  systemd.sleep.extraConfig = ''
    MemorySleepMode=s2idle
  '';

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

  # Shell
  programs.zsh.enable = true;

  # Fonts
  fonts.packages = with pkgs; [
    nerd-fonts.jetbrains-mono
  ];

  # User
  users.users.yiannis = {
    isNormalUser = true;
    description = "Yiannis Panagidis";
    shell = pkgs.zsh;
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
  programs.nix-ld.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    chromium
    discord

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
    prismlauncher

    # Sensors
    lm_sensors
    smartmontools # drive temps
    nvme-cli # nvme temps (optional)

    stdenv.cc.cc.lib
    fuse3
    icu
    zlib
    nss
    openssl
    expat
    bat

  ];

  boot.kernelPackages = pkgs.linuxPackages_latest;

  system.stateVersion = "25.11";
}
