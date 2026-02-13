{
  config,
  pkgs,
  ...
}: {
  imports = [
    #./hyprland
    ./niri
    ./launcher
    ./browser
    ./service/swaync
    ./editor/nvim
    ./guiApps.nix
    ./terminal.nix
    ./theme.nix
    ./direnv.nix
    ./git.nix
    ./media.nix
    ./recorder.nix
    ./nirishot.nix
    ./yazi.nix

    # --- Home Modules ---
    ../../modules/home/blueprint/x555uj.nix
  ];

  home.username = "nekoma";
  home.homeDirectory = "/home/nekoma";

  home.stateVersion = "25.11";
}
