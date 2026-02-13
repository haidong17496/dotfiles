{pkgs, ...}: {
  home.packages = with pkgs; [
    obsidian
    zed-editor
  ];

  services.easyeffects = {
    enable = true;
  };
}
