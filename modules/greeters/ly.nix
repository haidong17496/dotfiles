{pkgs, ...}: {
  systemd.services.display-manager.environment.XDG_CURRENT_DESKTOP = "X-NIXOS-SYSTEMD-AWARE";
  services.displayManager.ly.enable = true;
}
