{ pkgs, ... }:

{
    programs.direnv = {
        enable = true;
        enableZshIntegration = true; # Hooks into your Zsh
        nix-direnv.enable = true;    # Better caching (speeds up subsequent loads)
    };
}
