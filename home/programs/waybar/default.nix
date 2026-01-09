{pkgs, ...}: {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = builtins.readFile ./style.css;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        height = 32; # Reduced slightly for a tighter look
        spacing = 0;
        margin-top = 0;
        margin-left = 0;
        margin-right = 0;
        margin-bottom = 0;

        # Only Left and Right modules
        modules-left = ["hyprland/workspaces"];
        modules-center = [];
        modules-right = ["tray" "clock"];

        "hyprland/workspaces" = {
          on-click = "activate";
          format = "{name}";
        };

        "clock" = {
          format = "{:%H:%M  %d/%m/%y}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          actions = {
            on-click-right = "mode";
          };
        };

        "tray" = {
          icon-size = 16;
          spacing = 10;
        };
      };
    };
  };
}
