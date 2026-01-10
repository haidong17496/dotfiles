{pkgs, ...}: {
  programs.waybar = {
    enable = true;
    style = ./style.css;
    settings = {
      mainBar = builtins.fromJSON (builtins.readFile ./config.jsonc);
    };
  };
}
