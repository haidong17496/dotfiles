{pkgs, ...}: let
  wallpaper = ./../../../images/wallpaper.png;
in {
  services.hyprpaper = {
    enable = true;
    settings = {
      ipc = "on";
      preload = ["${wallpaper}"];
      wallpaper = [",${wallpaper}"];
    };
  };
}
