{pkgs, ...}: {
  imports = [
    ./hyprpaper.nix
    ./hyprlock.nix
    ./hypridle.nix
    ./hyprsunset.nix
    ./hyprshot.nix
  ];

  wayland.windowManager.hyprland = {
    enable = true;
    systemd.enable = true;

    extraConfig = ''
      ${builtins.readFile ./conf/monitor.conf}
      ${builtins.readFile ./conf/env.conf}
      ${builtins.readFile ./conf/autostart.conf}
      ${builtins.readFile ./conf/input.conf}
      ${builtins.readFile ./conf/theme.conf}
      ${builtins.readFile ./conf/keybinding.conf}
      ${builtins.readFile ./conf/windows.conf}
    '';
  };

  home.packages = with pkgs; [
    wl-clipboard
    libnotify
    swaynotificationcenter
    grim
    slurp
  ];
}
