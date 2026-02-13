{
  config,
  pkgs,
  lib,
  ...
}:

{
  services.sunshine = {
    enable = true;
    package = pkgs.sunshine.override {
      cudaSupport = true;
    };
    autoStart = true;
    capSysAdmin = true;
    openFirewall = true;
    settings = {
      sunshine_name = "nix-pc";
    };
    applications = {
      apps = [
        {
          name = "Desktop";
          auto-detach = "true";
        }
      ];
    };
  };
}
