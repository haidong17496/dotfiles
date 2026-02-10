{pkgs, ...}: {
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        padding = {
          y = 8;
        };
      };
      font = {
        normal.family = "JetBrainsMono Nerd Font";
        normal.style = "Regular";
        size = 12.0;
      };
    };
  };
}
