{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    ./caelestia.nix
    ./packages.nix
  ];

  home = {
    username = "nekoma";
    homeDirectory = "/home/nekoma";
    stateVersion = "25.11";
  };

  programs.home-manager.enable = true;
}
