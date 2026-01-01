{ pkgs, ... }:

{
    services.hypridle = {
        enable = true;
        
        settings = {
            general = {
                lock_cmd = "hyprlock";
                before_sleep_cmd = "loginctl lock-session";    
                # Ensure screen turns on when waking from suspend (even if lid was closed)
                after_sleep_cmd = "hyprctl dispatch dpms on";  
            };

            listener = [
                # 2.5 min: Dim Screen & Turn Off Keyboard Backlight
                {
                    timeout = 150;
                    on-timeout = "brightnessctl -s set 10";
                    on-resume = "brightnessctl -r";
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
