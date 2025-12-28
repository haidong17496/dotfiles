{ config, pkgs, ... }:

{
    # 1. Hyprland (System level)
    programs.hyprland.enable = true;

    # 2. Display Manager: Ly
    services.displayManager.ly.enable = true;

    # 3. Graphics & Portals
    xdg.portal = {
        enable = true;
        extraPortals = [
            pkgs.xdg-desktop-portal-hyprland
        ];
    };

    # 4. Critical Wayland Dependencies
    environment.systemPackages = with pkgs; [
        wayland
        wayland-protocols
        libxkbcommon
        vulkan-loader
        mesa
        wl-clipboard
    ];
}
