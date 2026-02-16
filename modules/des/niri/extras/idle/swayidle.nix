{ pkgs, ... }:

{
  programs.swaylock = {
    enable = true;
    settings = {
      clock = true;
      indicator = true;
      show-failed-attempts = true;
      grace = 2;
      screenshots = true;
      effect-blur = "7x5";
    };
  };

  services.swayidle = {
    enable = true;
    events = [
      {
        event = "before-sleep";
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
    ];
    timeouts = [
      {
        timeout = 600;
        command = "${pkgs.swaylock}/bin/swaylock -f";
      }
      {
        timeout = 900;
        command = "${pkgs.systemd}/bin/systemctl suspend";
      }
    ];
  };
}
