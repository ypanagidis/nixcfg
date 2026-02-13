{ config, pkgs, ... }:

{
  imports = [
    ./hardware-configuration.nix
    ./modules/steam.nix
    ./modules/crapple-display.nix
    ./modules/kdeconnect.nix
    ./modules/sunshine.nix
  ];

  # Enable flakes system-wide
  nix.settings.experimental-features = [
    "nix-command"
    "flakes"
  ];

  # Bootloader
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 20;
  boot.loader.efi.canTouchEfiVariables = true;

  # Networking
  networking.hostName = "nix-pc";
  networking.networkmanager.enable = true;
  networking.firewall.trustedInterfaces = [ "virbr0" ];
  networking.firewall.allowedTCPPorts = [
    4096
    4000
    3000
  ];

  # Time zone / locales
  time.timeZone = "Europe/Athens";

  i18n.defaultLocale = "en_US.UTF-8";

  # Virtualisation
  # Docker
  virtualisation.docker.enable = true;
  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      swtpm.enable = true;
      runAsRoot = true;
    };
  };

  # X11 + KDE Plasma 6
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
            # Sends Ctrl+Backspace (Usually ^H)
            backspace = "C-backspace";
          };
          "cmd_nav:M" = {
            left = "home";
            right = "end";
            # Sends Shift+Home, then Backspace
            backspace = "macro(S-home backspace)";
          };
        };
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

    open = true;
  };

  #Kernel Modules
  boot.kernelModules = [
    "k10temp"
    "asus_ec_sensors"
  ];

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

  services.syncthing = {
    enable = true;
    user = "yiannis";
    dataDir = "/home/yiannis";
    configDir = "/home/yiannis/.config/syncthing";
  };

  # mDNS for local network service discovery (opencode.local)
  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
    };
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
      "docker"
      "libvirtd"
      "kvm"
    ];
    packages = with pkgs; [
      kdePackages.kate
    ];
  };

  # Apple Studio Display
  hardware.apple-studio-display.enable = true;

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

    # Virtualisation deps
    virt-manager
    freerdp
    (pkgs.runCommand "xfreerdp3-compat" { } ''
      mkdir -p $out/bin
      ln -s ${pkgs.freerdp}/bin/xfreerdp $out/bin/xfreerdp3
    '')
    libnotify
    libreoffice-fresh
    neofetch
    # Fans
    liquidctl
    openrgb
  ];
  services.hardware.openrgb = {
    enable = true;
    # Optional: specify the package if you need a specific version
    # package = pkgs.openrgb;
  };

  programs.coolercontrol.enable = true;
  # Thunderbolt controller rebind after wake - fixes USB4 DP tunnel
  systemd.services.thunderbolt-rebind = {
    description = "Rebind Thunderbolt controller after resume";
    after = [ "post-resume.target" ];
    wantedBy = [ "post-resume.target" ];
    path = [ pkgs.pciutils ];
    serviceConfig = {
      Type = "oneshot";
      ExecStart = "${pkgs.bash}/bin/bash -c 'dev=$(lspci -D | grep \"ASM4242 PCIe Switch Upstream\" | cut -d\" \" -f1); echo 1 > /sys/bus/pci/devices/$dev/remove; sleep 2; echo 1 > /sys/bus/pci/rescan'";
    };
  };

  # Opencode web interface - accessible from local network
  systemd.services.opencode-web = {
    description = "Opencode Web Interface";
    after = [ "network.target" ];
    wantedBy = [ "multi-user.target" ];
    serviceConfig = {
      Type = "simple";
      ExecStart = "${pkgs.opencode}/bin/opencode web --hostname 0.0.0.0 --port 4096 --mdns --mdns-domain nix-pc.local";
      Restart = "on-failure";
      RestartSec = "5s";
      User = "yiannis";
      WorkingDirectory = "/home/yiannis";
    };
  };

  environment.sessionVariables = {
    # Fixes blank/grey screens and popups in Java apps on Wayland
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };

  boot.kernelParams = [
    "mem_sleep_default=s2idle"
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    "pci=realloc=on,pcie_bus_perf,hpbussize=32"
  ];

  hardware.nvidia.powerManagement = {
    enable = true;
    finegrained = false;
  };

  boot.kernelPackages = pkgs.linuxPackages_latest;

  powerManagement.powerDownCommands = ''
    # Disable all PCI device wakes to prevent spurious wake from S3
    for dev in /sys/bus/pci/devices/*/power/wakeup; do
      echo disabled > "$dev" 2>/dev/null || true
    done
  '';

  system.stateVersion = "25.11";
}
