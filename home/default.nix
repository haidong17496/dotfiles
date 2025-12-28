{ config, pkgs, ... }:

{
    imports = [
        ./hyprland/default.nix
        ./walker/default.nix
        ./shell/default.nix
        ./programs/default.nix
    ];

    home.username = "nekoma";
    home.homeDirectory = "/home/nekoma";
    
    home.stateVersion = "25.11";
}
