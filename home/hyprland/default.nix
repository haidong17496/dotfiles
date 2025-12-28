{ pkgs, ... }:

{
    wayland.windowManager.hyprland = {
        enable = true;
        extraConfig = builtins.readFile ./hyprland.conf;
    };

    home.packages = with pkgs; [
        hyprpaper
        hyprlock
        hypridle
    ];
}
