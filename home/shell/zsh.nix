{ pkgs, ... }:

{
    programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;

        shellAliases = {
            nrs = "sudo nixos-rebuild switch --flake ~/dotfiles#astral";
            ncg = "nix-collect-garbage -d";
        };
    };
}
