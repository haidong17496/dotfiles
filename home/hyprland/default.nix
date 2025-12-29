{ pkgs, ... }:

{
    imports = [
        ./hyprsunset.nix
    ];

    wayland.windowManager.hyprland = {
        enable = true;
        
        extraConfig = ''
            # --- MODULES ---
            source = ${./modules/monitor.conf}
            source = ${./modules/env.conf}
            source = ${./modules/autostart.conf}
            source = ${./modules/input.conf}
            source = ${./modules/theme.conf}
            source = ${./modules/keybinding.conf}
            source = ${./modules/windows.conf}
        '';
    };

    home.packages = with pkgs; [
        hyprpaper
        hyprlock
        hypridle
        hyprsunset
    ];
}
