{ pkgs, ... }:

{
    # We use a systemd service so we can toggle it with one command.
    systemd.user.services.hyprsunset = {
        Unit = {
            Description = "Hyprland Blue Light Filter";
            After = [ "graphical-session.target" ];
            PartOf = [ "graphical-session.target" ];
        };

        Service = {
            # 3200K is a comfortable warm temperature for night
            ExecStart = "${pkgs.hyprsunset}/bin/hyprsunset --temperature 3200";
            Restart = "on-failure";
        };

        Install = {
            WantedBy = [ "graphical-session.target" ];
        };
    };
}
