{ config, pkgs, ... }:

{
    imports = [
        ./hardware-configuration.nix
        ../../modules/system.nix
        ../../modules/desktop.nix
    ];
    
    networking.hostName = "astral";
    networking.networkmanager.enable = true;

    users.users.nekoma = {
        isNormalUser = true;
        extraGroups = [ "networkmanager" "wheel" "video" "input" ];
        shell = pkgs.zsh;
    };

    nix.settings.experimental-features = [ "nix-command" "flakes" ];

    system.stateVersion = "25.11";

    services.xserver.videoDrivers = [ "nvidia" ];
    hardware.graphics.enable = true;
    hardware.nvidia = {
        modesetting.enable = true;
        open = false;
        nvidiaSettings = true;
        package = config.boot.kernelPackages.nvidiaPackages.legacy_470;

        prime = {
            offload = {
                enable = true;
                enableOffloadCmd = true;
            };
            intelBusId = "PCI:0:2:0";
            nvidiaBusId = "PCI:1:0:0";
        };
    };
}
