{pkgs, ...}: {
  imports = [
    ./swaync
    ./nvim
    ./browser
    ./waybar
    ./git.nix
    ./yazi.nix
    ./bluetooth.nix
    ./direnv.nix
    ./media.nix
    ./recorder.nix
    ./easyEffects.nix
    ./tmux.nix
  ];

  home.packages = with pkgs; [
    # System Control
    brightnessctl
    wl-clipboard
    libnotify
    swaynotificationcenter
    polkit_gnome
    playerctl

    # CLI Tools
    bluetuith
    pulsemixer
    gpu-screen-recorder
    ripgrep
    fd
    jq
    bottom

    # Archives
    p7zip

    # Clipboard & Screenshot
    grim
    slurp

    # GUI
    obsidian
    zed-editor
  ];
}
