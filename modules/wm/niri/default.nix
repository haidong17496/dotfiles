{pkgs, ...}: {
  programs.niri = {
    enable = true;
    package = pkgs.niri;
  };

  services.dbus.enable = true;

  xdg.portal = {
    enable = true;
    extraPortals = [
      pkgs.xdg-desktop-portal-gnome
      pkgs.xdg-desktop-portal-gtk
    ];
    config = {
      common = {
        default = ["gnome" "gtk"];
      };
    };
  };

  # services.gnome.gnome-keyring.enable = true;

  # 4. Environment Variables
  environment.sessionVariables = {
    NIXOS_OZONE_WL = "1";
    DISPLAY = ":0";
    WLR_NO_HARDWARE_CURSORS = "1";
  };
}
