{ ... }:

{
  services.printing.enable = true;

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
}
