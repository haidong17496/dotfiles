{ config, pkgs, ... }:

{
    imports = [
        ./hyprland/default.nix
        ./walker/default.nix
        ./shell/default.nix
        ./programs/default.nix
    ];

    home.pointerCursor = {
        gtk.enable = true;
        package = pkgs.bibata-cursors;
        name = "Bibata-Modern-Ice";
        size = 24;
    };

    home.username = "nekoma";
    home.homeDirectory = "/home/nekoma";
    
    home.stateVersion = "25.11";
}
