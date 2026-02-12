{pkgs, ...}: {
  imports = [
    ./swaync
    ./nvim
    ./browser
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

    # CLI Tools
    bluetuith
    pulsemixer
    gpu-screen-recorder
    ffmpeg
    ripgrep
    fd
    jq
    bottom
    dragon-drop

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
