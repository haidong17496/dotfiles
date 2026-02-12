{pkgs, ...}: {
  home.packages = with pkgs; [
    obsidian
    zed-editor
  ];
}
