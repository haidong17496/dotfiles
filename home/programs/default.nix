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
    brightnessctl
    libnotify
    bluetuith
    pulsemixer
    ripgrep
    wlogout
    fd
    jq
    p7zip
    bottom
    grim
    slurp
  ];
}
