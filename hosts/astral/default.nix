{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hardware-configuration.nix
    ../../modules/system.nix
    ../../modules/desktop.nix
    ../../modules/nvidia.nix
  ];

  networking.hostName = "astral";
  networking.networkmanager.enable = true;

  users.users.nekoma = {
    isNormalUser = true;
    extraGroups = ["networkmanager" "wheel" "video" "input"];
    shell = pkgs.zsh;
  };

  nix.settings.experimental-features = ["nix-command" "flakes"];

  system.stateVersion = "25.11";
}
