{pkgs, ...}: {
  imports = [
    ./hyprpaper.nix
    ./hyprlock.nix
    ./hypridle.nix
    ./hyprsunset.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    extraConfig = ''
      ${builtins.readFile ./modules/monitor.conf}
      ${builtins.readFile ./modules/env.conf}
      ${builtins.readFile ./modules/autostart.conf}
      ${builtins.readFile ./modules/input.conf}
      ${builtins.readFile ./modules/theme.conf}
      ${builtins.readFile ./modules/keybinding.conf}
      ${builtins.readFile ./modules/windows.conf}
    '';
  };
}
