{
  config,
  pkgs,
  ...
}: {
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
