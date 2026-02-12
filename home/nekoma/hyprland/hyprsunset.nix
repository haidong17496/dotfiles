{pkgs, ...}: let
  # Define a custom script to handle the toggle logic
  toggle-hyprsunset = pkgs.writeShellScriptBin "toggle-hyprsunset" ''
    if systemctl --user is-active --quiet hyprsunset; then
        systemctl --user stop hyprsunset
        # Optional: Send a notification
        ${pkgs.libnotify}/bin/notify-send "Night Light" "Off (6500K)" -t 2000
    else
        systemctl --user start hyprsunset
        ${pkgs.libnotify}/bin/notify-send "Night Light" "On (4000K)" -t 2000
    fi
  '';
in {
  # Install the script
  home.packages = [toggle-hyprsunset];

  systemd.user.services.hyprsunset = {
    Unit = {
      Description = "Hyprland Blue Light Filter";
      After = ["graphical-session.target"];
      PartOf = ["graphical-session.target"];
    };

    Service = {
      ExecStart = "${pkgs.hyprsunset}/bin/hyprsunset --temperature 4000";
      Restart = "on-failure";
    };

    Install = {
      WantedBy = ["graphical-session.target"];
    };
  };
}
