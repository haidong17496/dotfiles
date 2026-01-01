{ pkgs, ... }:

{
    programs.zsh = {
        enable = true;
        enableCompletion = true;
        autosuggestion.enable = true;
        syntaxHighlighting.enable = true;
        prezto.caseSensitive = false;

        history = {
            size = 5000;
            saveNoDups = true;
            append = true;
            share = true;
            ignoreSpace = true;
            ignoreDups = true;
            ignoreAllDups = true;
        };

        historySubstringSearch = {
            searchUpKey = "^p";
            searchDownKey = "^n";
        };

        initContent = ''
            bindkey '^e' autosuggest-accept
        '';

        shellAliases = {
            nrs = "sudo nixos-rebuild switch --flake ~/dotfiles#astral";
            ncg = "nix-collect-garbage -d";
        };
    };
}
