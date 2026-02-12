{pkgs, ...}: {
  # Terminal
  programs.alacritty.settings = {
    window = {
      opacity = 0.9;
      padding = {
        x = 8;
        y = 8;
      };
    };
    font = {
      normal.family = "JetBrainsMono Nerd Font";
      normal.style = "Regular";
      size = 12.0;
    };
  };

  # Prompt
  programs.starship.settings = {
    add_newline = false;
    character = {
      success_symbol = "[➜](bold green)";
      error_symbol = "[➜](bold red)";
    };
  };

  # Shell
  programs.zsh = {
    initContent = ''bindkey '^e' autosuggest-accept'';
    shellAliases = {
      nrs = "nh os switch ~/dotfiles";
      nrb = "nh os boot ~/dotfiles";
      ngc = "sudo nh clean all --keep 3";
      nlg = "nixos-rebuild list-generations";
    };
  };

  home.packages = with pkgs; [
    fd
    jq
    ripgrep
    bottom
    p7zip
    ffmpeg
    bluetuith
    pulsemixer
    gpu-screen-recorder
    dragon-drop
  ];
}
