{ pkgs, ... }:

{
    imports = [
        ./browsers.nix
        ./neovim.nix
        ./git.nix
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
