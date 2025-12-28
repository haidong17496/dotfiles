{ config, pkgs, ... }:

{
    # Bootloader
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    # Locale & Time
    time.timeZone = "Asia/Ho_Chi_Minh";
    i18n.defaultLocale = "en_US.UTF-8";

    # Audio
    security.rtkit.enable = true;
    services.pipewire = {
        enable = true;
        alsa.enable = true;
        alsa.support32Bit = true;
        pulse.enable = true;
    };

    # Fonts
    fonts.packages = with pkgs; [
        nerd-fonts.jetbrains-mono
        noto-fonts
        noto-fonts-cjk-sans
        noto-fonts-color-emoji
    ];

    programs.zsh.enable = true;
    environment.systemPackages = with pkgs; [
        git
        wget
        curl
        pciutils
    ];
}
