{pkgs, ...}: {
  programs.alacritty = {
    enable = true;
    settings = {
      window = {
        opacity = 0.95;
      };
      font = {
        normal.family = "JetBrainsMono Nerd Font";
        normal.style = "Regular";
        size = 12.0;
      };
    };
  };
}
