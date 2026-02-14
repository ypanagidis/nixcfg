{ config, pkgs, ... }:

{
  networking.hostName = "nix-pc";

  boot.kernelModules = [
    "k10temp"
    "asus_ec_sensors"
  ];

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

  hardware.apple-studio-display.enable = true;

  services.hardware.openrgb = {
    enable = true;
  };

  programs.coolercontrol.enable = true;

  services.hardware.bolt.enable = true;

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

  environment.systemPackages = with pkgs; [
    liquidctl
    openrgb
  ];

  boot.kernelParams = [
    "mem_sleep_default=s2idle"
    "nvidia.NVreg_PreserveVideoMemoryAllocations=1"
    "pci=realloc=on,pcie_bus_perf,hpbussize=32"
  ];
}
