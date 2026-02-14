{ pkgs, ... }:

{
  services.printing.enable = true;
  services.hardware.bolt.enable = true;

  services.syncthing = {
    enable = true;
    user = "yiannis";
    dataDir = "/home/yiannis";
    configDir = "/home/yiannis/.config/syncthing";
  };

  services.avahi = {
    enable = true;
    nssmdns4 = true;
    publish = {
      enable = true;
      addresses = true;
    };
  };

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
}
