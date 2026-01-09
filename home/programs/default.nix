{pkgs, ...}: {
  imports = [
    ./nvim
    ./browser
    ./eww
    ./git.nix
    ./yazi.nix
    ./bluetooth.nix
    ./direnv.nix
  ];

  home.packages = with pkgs; [
    # --- Eww Widget Dependencies ---
    eww
    socat # For Eww IPC
    jq # For parsing JSON (weather/lyrics)
    acpi # For battery status
    playerctl # For Media Player control
    pamixer # For Volume Slider logic
    brightnessctl # For Brightness Slider logic

    # --- System Utilities ---
    libnotify # For 'notify-send' (Popups)
    inotify-tools # For detecting file changes instantly
    bluetuith # TUI for Bluetooth
    ripgrep # Fast search
    fd # Fast find
    p7zip # Archives
    bottom # System monitor (btm)
    grim # Screenshots
    slurp # Area selection
    pulsemixer # Audio TUI
  ];
}
