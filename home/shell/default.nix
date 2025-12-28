{ pkgs, ... }:

{
    imports = [
        ./zsh.nix
        ./starship.nix
        ./alacritty.nix
    ];
}
