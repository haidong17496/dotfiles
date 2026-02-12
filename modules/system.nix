{
  config,
  pkgs,
  ...
}: {
  # --- Bootloader Configuration ---
  # Defaulting to systemd-boot for UEFI systems.
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # --- Networking ---
  networking.networkmanager.enable = true;

  # --- Timezone & Locale ---
  time.timeZone = "Asia/Ho_Chi_Minh";
  i18n.defaultLocale = "en_US.UTF-8";

  # --- Nix Configuration ---
  nix.settings.experimental-features = ["nix-command" "flakes"];

  # Optimize storage
  nix.settings.auto-optimise-store = true;

  # --- Core System Packages ---
  # Packages that should be available on EVERY hosts
  environment.systemPackages = with pkgs; [
    git
    wget
    curl
    bottom
    p7zip
    killall
  ];
}
