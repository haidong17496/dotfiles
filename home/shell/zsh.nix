{pkgs, ...}: {
  programs.zsh = {
    enable = true;
    enableCompletion = true;
    autosuggestion.enable = true;
    syntaxHighlighting.enable = true;

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

    completionInit = ''
      zstyle ':completion:*' matcher-list 'm:{a-z}={A-Za-z}'
    '';

    shellAliases = {
      nrs = "sudo nixos-rebuild switch --flake ~/dotfiles#astral";
      ngc = "nix-collect-garbage -d";
      nrb = "sudo nixos-rebuild boot --flake ~/dotfiles#astral";
    };
  };
}
