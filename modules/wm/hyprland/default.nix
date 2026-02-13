{pkgs, ...}: {
  programs.hyprland = {
    enable = true;
    xwayland.enable = true;
  };

  # --- XDG Portal Configuration ---
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

  services.dbus.enable = true;

  # securely stores secrets, passwords, keys, and certificates
  # services.gnome.gnome-keyring.enable = true;

  # --- Environment Variables ---
  environment.sessionVariables = {
    # Electron apps (VSCode, Discord, etc.) to use Wayland
    NIXOS_OZONE_WL = "1";

    # Firefox
    MOZ_ENABLE_WAYLAND = "1";

    # Required for some apps to choose the right backend
    XDG_CURRENT_DESKTOP = "Hyprland";
    XDG_SESSION_TYPE = "wayland";
    XDG_SESSION_DESKTOP = "Hyprland";

    # GTK/QT Wayland
    _JAVA_AWT_WM_NONREPARENTING = "1";
    QT_QPA_PLATFORM = "wayland;xcb";
    GDK_BACKEND = "wayland,x11,*";
    SDL_VIDEODRIVER = "wayland";
    CLUTTER_BACKEND = "wayland";

    # For fixing invisible cursor
    WLR_NO_HARDWARE_CURSORS = "1";
  };

  # --- System Packages for Hyprland ---
  environment.systemPackages = with pkgs; [
    libsForQt5.qt5.qtwayland
    kdePackages.qtwayland
  ];
}
