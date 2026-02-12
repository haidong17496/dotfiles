{pkgs, ...}: {
  imports = [
    ../browser/firefox.nix
    ../launcher/walker.nix
    ../prompt/starship.nix
    ../shell/zsh.nix
    ../statusbar/waybar.nix
    ../terminal/alacritty.nix
    ../theme/gtk.nix
    ../theme/presets/adwaita-dark.nix
  ];
}
