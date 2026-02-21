{
  config,
  pkgs,
  ...
}: {
  imports = [
    ./hypridle.nix
    ./hyprlock.nix
  ];
  home.packages = with pkgs; [
    wl-clipboard
    libnotify
    grim
    slurp
    swaybg
  ];

  xdg.configFile = {
    "niri/config.kdl".source = ./config.kdl;
    "niri/conf".source = ./conf;
  };
}
