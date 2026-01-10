{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hyprland/default.nix
    ./walker/default.nix
    ./shell/default.nix
    ./programs/default.nix
  ];

  home.packages = with pkgs; [
    papirus-icon-theme
  ];

  gtk = {
    enable = true;
    iconTheme = {
      name = "Papirus-Dark";
      package = pkgs.papirus-icon-theme;
    };
    theme = {
      name = "Catppuccin-Mocha-Standard-Blue-Dark";
      package = pkgs.catppuccin-gtk.override {
        accents = ["blue"];
        size = "standard";
        tweaks = ["rimless"];
        variant = "mocha";
      };
    };
    cursorTheme = {
      name = "Bibata-Modern-Ice";
      package = pkgs.bibata-cursors;
    };
  };

  home.pointerCursor = {
    gtk.enable = true;
    package = pkgs.bibata-cursors;
    name = "Bibata-Modern-Ice";
    size = 24;
  };

  home.username = "nekoma";
  home.homeDirectory = "/home/nekoma";

  home.stateVersion = "25.11";
}
