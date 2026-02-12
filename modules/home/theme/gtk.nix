{pkgs, ...}: {
  gtk = {
    enable = true;
  };

  # Ensure the pointer cursor is recognized by GTK and X11 apps
  home.pointerCursor = {
    gtk.enable = true;
    x11.enable = true;
  };
}
