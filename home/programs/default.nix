{pkgs, ...}: {
  imports = [
    ./nvim
    ./browser
    ./waybar
    ./git.nix
    ./yazi.nix
    ./bluetooth.nix
    ./direnv.nix
    ./media.nix
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
    ripgrep
    fd
    jq
    btop

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
