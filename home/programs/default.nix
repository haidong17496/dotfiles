{pkgs, ...}: {
  imports = [
    ./nvim
    ./browser
    ./waybar
    ./git.nix
    ./yazi.nix
    ./bluetooth.nix
    ./direnv.nix
  ];

  home.packages = with pkgs; [
    ripgrep
    fd
    jq
    p7zip
    bluetuith
    pulsemixer
    brightnessctl
    bottom
    grim
    slurp
  ];
}
