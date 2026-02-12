{
  config,
  pkgs,
  inputs,
  ...
}: let
  caelestia-cli-bin = "${inputs.caelestia-cli.packages.${pkgs.system}.default}/bin/caelestia";
  caelestia-shell-bin = "${inputs.caelestia-shell.packages.${pkgs.system}.default}/bin/caelestia-shell";
in {
  home.packages = with pkgs; [
    inputs.caelestia-shell.packages.${pkgs.system}.default
    inputs.caelestia-cli.packages.${pkgs.system}.default

    # dependencies
    fish
    matugen
    swww
    socat
    material-symbols
    dart-sass
    libqalculate
    libcava
    aubio
    lm_sensors
    brightnessctl
    swappy # Screenshot editor
    cliphist # Clipboard history
    fuzzel # Emoji/Clipboard picker
    ddcutil # External monitor brightness
    app2unit # Process management for the shell
    gpu-screen-recorder # Recording functionality
  ];

  xdg.configFile."caelestia/shell".source = inputs.caelestia-shell;
  xdg.configFile."caelestia/cli".source = inputs.caelestia-cli;

  # --- Hyprland User-side Config ---
  wayland.windowManager.hyprland = {
    enable = true;
    settings = {
      # Autostart Caelestia components
      "exec-once" = [
        "${caelestia-cli-bin} daemon"
        "${caelestia-shell-bin}"
      ];

      bind = [
        "SUPER, R, exec, ${caelestia-cli-bin} launcher"
        "SUPER, N, exec, ${caelestia-cli-bin} notifications"
        "SUPER, C, exec, ${caelestia-cli-bin} control"
        "SUPER, B, exec, ${caelestia-cli-bin} bar"
      ];
    };
  };
  programs.fish.enable = true;
}
