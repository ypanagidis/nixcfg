{ pkgs, ... }:

{
  boot.loader.systemd-boot.enable = true;
  boot.loader.systemd-boot.configurationLimit = 20;
  boot.loader.efi.canTouchEfiVariables = true;

  networking.networkmanager.enable = true;
  networking.firewall.trustedInterfaces = [ "virbr0" ];
  networking.firewall.allowedTCPPorts = [
    4096
    4000
    3000
  ];

  time.timeZone = "Europe/Athens";
  i18n.defaultLocale = "en_US.UTF-8";

  virtualisation.docker = {
    enable = true;
    daemon.settings = {
      runtimes = {
        runsc = {
          path = "${pkgs.gvisor}/bin/runsc";
          runtimeArgs = [ "--platform=ptrace" ];
        };
      };
    };
  };

  virtualisation.libvirtd = {
    enable = true;
    qemu = {
      package = pkgs.qemu_kvm;
      swtpm.enable = true;
      runAsRoot = true;
    };
  };

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

  programs.firefox.enable = true;

  environment.systemPackages = with pkgs; [
    vim
    chromium
    discord

    usbutils
    pciutils
    alsa-utils
    pulseaudio
    pavucontrol

    git
    curl
    wget
    unzip
    zip
    jq
    ripgrep
    fd
    htop

    nil

    lm_sensors
    smartmontools
    nvme-cli
    sysstat # iostat/sar for tmux cpu plugin

    stdenv.cc.cc.lib
    fuse3
    icu
    zlib
    nss
    openssl
    expat

    virt-manager
    gvisor
    freerdp
    (pkgs.runCommand "xfreerdp3-compat" { } ''
      mkdir -p $out/bin
      ln -s ${pkgs.freerdp}/bin/xfreerdp $out/bin/xfreerdp3
    '')
    libnotify
    libreoffice-fresh
    neofetch
  ];

  environment.sessionVariables = {
    _JAVA_AWT_WM_NONREPARENTING = "1";
  };

  boot.kernelPackages = pkgs.linuxPackages_6_18;

  powerManagement.powerDownCommands = ''
    for dev in /sys/bus/pci/devices/*/power/wakeup; do
      echo disabled > "$dev" 2>/dev/null || true
    done
  '';
}
