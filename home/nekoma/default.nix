{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./guiApp.nix
    ./hyprland
    ./launcher
    ./browser
    ./statusbar
    ./editor/nvim
    ./terminal.nix
    ./theme.nix
    ./direnv.nix
    ./easyeffects.nix
    ./git.nix
    ./media.nix
    ./recorder.nix
    ./yazi.nix
  ];

  home.username = "nekoma";
  home.homeDirectory = "/home/nekoma";

  home.stateVersion = "25.11";
}
