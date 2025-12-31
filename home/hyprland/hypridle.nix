{ pkgs, ... }:

{
    services.hypridle = {
        enable = true;
        
        settings = {
            general = {
                lock_cmd = "pidof hyprlock || hyprlock";       # Avoid multiple instances
                before_sleep_cmd = "loginctl lock-session";    # Lock before suspend
                after_sleep_cmd = "hyprctl dispatch dpms on";  # Wake up screen immediately
            };

            listener = [
                # 2.5 min: Dim screen
                {
                    timeout = 150;
                    on-timeout = "brightnessctl -s set 10";      # Save current, set to 10
                    on-resume = "brightnessctl -r";              # Restore previous
                }
                # 5 min: Lock screen
                {
                    timeout = 300;
                    on-timeout = "loginctl lock-session";
                }
                # 5.5 min: Screen off
                {
                    timeout = 330;
                    on-timeout = "hyprctl dispatch dpms off";
                    on-resume = "hyprctl dispatch dpms on";
                }
                # 30 min: Suspend
                {
                    timeout = 1800;
                    on-timeout = "systemctl suspend";
                }
            ];
        };
    };
}
