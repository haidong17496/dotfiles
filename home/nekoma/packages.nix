{pkgs, ...}: {
  home.packages = with pkgs; [
    # terminal
    alacritty

    # TUI
    bluetuith

    # GUI
    firefox
  ];
}
