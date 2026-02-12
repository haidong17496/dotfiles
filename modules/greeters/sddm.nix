{pkgs, ...}: {
  environment.systemPackages = with pkgs; [
    sddm-chili-theme
  ];

  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true;
      theme = "chili";
    };
  };
}
