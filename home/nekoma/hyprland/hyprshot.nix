{pkgs, ...}: {
  programs.hyprshot = {
    enable = true;
    saveLocation = "$HOME/Pictures/screenshots";
  };
}
