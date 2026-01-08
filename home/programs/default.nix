{pkgs, ...}: {
  imports = [
    ./nvim
    ./browser
    ./git.nix
    ./yazi.nix
    ./bluetooth.nix
    ./direnv.nix
    ./island.nix
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
  ];
}
