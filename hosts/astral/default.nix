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
    ../../modules/greeters/sddm.nix

    # --- Hardware Specific (Nvidia 920M) ---
    ../../modules/nvidia/legacy470.nix

    # --- Window Manager ---
    ../../modules/wm/hyprland/default.nix
  ];

  # --- Networking ---
  networking.hostName = "astral";

  # --- User Configuration ---
  users.users.nekoma = {
    isNormalUser = true;
    description = "Nekoma";
    extraGroups = ["networkmanager" "wheel" "video" "input" "audio"];

    # Setting Zsh as the default shell for this user on this host
    #shell = pkgs.zsh;
  };

  # --- Host Specific Packages ---
  environment.systemPackages = with pkgs; [
    zsh
  ];

  # --- System State ---
  system.stateVersion = "25.11";
}
