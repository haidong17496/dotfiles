{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    # Include the results of the hardware scan.
    ./hardware-configuration.nix

    # --- System Modules ---
    ../../modules/system.nix
    ../../modules/fonts.nix
    ../../modules/audio.nix
    ../../modules/bluetooth.nix
    ../../modules/i18n.nix
    ../../modules/greeters/ly.nix

    # --- Hardware Specific (Nvidia 920M) ---
    ../../modules/nvidia/legacy470.nix

    # --- Window Manager ---
    ../../modules/wm/hyprland
  ];

  # --- Networking ---
  networking.hostName = "astral";

  # --- User Configuration ---
  users.users.nekoma = {
    isNormalUser = true;
    description = "Nekoma";
    extraGroups = ["networkmanager" "wheel" "video" "input" "audio"];
    shell = pkgs.zsh;
  };

  # --- External Storage ---
  systemd.tmpfiles.rules = [
    "d /mnt/backup 0755 nekoma users -"
  ];

  programs.zsh.enable = true;

  # --- System State ---
  system.stateVersion = "25.11";
}
