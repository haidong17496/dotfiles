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
      nrs = "nh os switch ~/dotfiles";
      nrb = "nh os boot ~/dotfiles";
      ngc = "sudo nh clean all --keep 3";
      nlg = "nixos-rebuild list-generations";
    };
  };
}
