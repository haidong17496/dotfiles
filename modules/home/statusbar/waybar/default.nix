{pkgs, ...}: {
  programs.waybar = {
    enable = true;
    systemd.enable = true;
    style = ./style.css;

    settings = {
      mainBar = {
        layer = "top";
        position = "top";
        mod = "dock";
        exclusive = true;
        passthrough = false;
        gtk-layer-shell = true;
        height = 32;

        # Hyprland
        # modules-left = ["hyprland/workspaces" "hyprland/window"];
        # Niri
        modules-left = ["niri/workspaces" "niri/window"];
        modules-center = ["clock" "custom/notification"];
        modules-right = ["tray" "pulseaudio" "network" "battery"];

        "custom/notification" = {
          tooltip = false;
          format = "{icon}";
          format-icons = {
            notification = "<span foreground='red'><sup></sup></span>";
            none = "";
            dnd-notification = "<span foreground='red'><sup></sup></span>";
            dnd-none = "";
            inhibited-notification = "<span foreground='red'><sup></sup></span>";
            inhibited-none = "";
            dnd-inhibited-notification = "<span foreground='red'><sup></sup></span>";
            dnd-inhibited-none = "";
          };
          return-type = "json";
          exec-if = "which swaync-client";
          exec = "swaync-client -swb";
          on-click = "swaync-client -t -sw";
          on-click-right = "swaync-client -d -sw";
          escape = true;
        };

        /*
        "hyprland/workspaces" = {
          disable-scroll = true;
          all-outputs = false;
          on-click = "activate";
          format = "{name}";
        };

        "hyprland/window" = {
          format = "{title}";
          max-length = 35;
          separate-outputs = true;
        };
        */

        # --- Niri ---
        "niri/workspaces" = {
          format = "{icon}";
          format-icons = {
            active = "";
            default = "";
          };
        };

        "niri/window" = {
          format = "{title}";
          max-length = 35;
          separate-outputs = true;
        };

        "clock" = {
          format = "{:%H:%M}";
          format-alt = "{:%A, %B %d, %Y (%R)}";
          tooltip-format = "<tt><small>{calendar}</small></tt>";
          calendar = {
            mode = "year";
            mode-mon-col = 3;
            weeks-pos = "right";
            on-scroll = 1;
            format = {
              months = "<span color='#ffead3'><b>{}</b></span>";
              days = "<span color='#ecc6d9'><b>{}</b></span>";
              weeks = "<span color='#99ffdd'><b>W{}</b></span>";
              weekdays = "<span color='#ffcc66'><b>{}</b></span>";
              today = "<span color='#ff6699'><b><u>{}</u></b></span>";
            };
          };
          actions = {
            on-click-right = "mode";
            on-click-forward = "tz_up";
            on-click-backward = "tz_down";
            on-scroll-up = "shift_up";
            on-scroll-down = "shift_down";
          };
        };

        "pulseaudio" = {
          format = "{icon}  {volume}%";
          format-muted = " Muted";
          on-click-right = "pulsemixer --toggle-mute";
          on-click = "alacritty -e pulsemixer"; # User preferences
          scroll-step = 5;
          format-icons = {
            headphone = "";
            hands-free = "";
            headset = "";
            phone = "";
            portable = "";
            car = "";
            default = ["" "" ""];
          };
        };

        "network" = {
          format-wifi = "  {signalStrength}%";
          format-ethernet = "󰈀 Connected";
          tooltip = false;
          format-linked = "{ifname} (No IP)";
          format-disconnected = "Disconnected ⚠";
          on-click = "alacritty -e nmtui"; # User preferences
        };

        "battery" = {
          states = {
            good = 95;
            warning = 30;
            critical = 15;
          };
          format = "{icon} {capacity}%";
          format-charging = " {capacity}%";
          format-plugged = " {capacity}%";
          format-alt = "{time} {icon}";
          format-icons = ["" "" "" "" ""];
        };

        "tray" = {
          icon-size = 16;
          spacing = 10;
        };
      };
    };
  };
}
