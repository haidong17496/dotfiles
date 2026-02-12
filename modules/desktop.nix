{
  config,
  pkgs,
  ...
}: {
  # 1. Hyprland (System level)
  programs.hyprland.enable = true;
  programs.hyprlock.enable = true;

  # 2. Display Manager: Ly
  services.displayManager.ly.enable = true;

  # 3. Graphics & Portals
  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gtk
      pkgs.xdg-desktop-portal-hyprland
    ];
    config = {
      common.default = ["gtk"];
      hyprland.default = ["hyprland" "gtk"];
    };
  };
}
