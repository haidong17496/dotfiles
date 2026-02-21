{pkgs, ...}: let
  wallpaper = ./../../../images/wallpaper.png;

  font_family = "JetBrainsMono Nerd Font Mono";

  # --- LAYOUT CONSTANTS ---
  font_size = 17;
  time_size = 90;

  code_base_x = -220;

  indent_1 = code_base_x + 40; # 40px indent
  indent_2 = code_base_x + 80;

  toString = x: builtins.toString x;
in {
  programs.hyprlock = {
    enable = true;

    settings = {
      general = {
        hide_cursor = true;
        no_fade_in = false;
        grace = 0;
        disable_loading_bar = true;
      };

      background = [
        {
          path = "${wallpaper}";
          blur_passes = 3;
          blur_size = 4;
          brightness = 0.5;
        }
      ];

      # --- INPUT FIELD ---
      input-field = [
        {
          size = "250, 40";
          position = "${toString (indent_1 + 10)}, -35";
          monitor = "";

          dots_center = false;
          dots_spacing = 0.2;
          dots_size = 0.8;
          fade_on_empty = false;

          inner_color = "rgba(0, 0, 0, 0)";
          outer_color = "rgba(0, 0, 0, 0)";
          font_color = "rgb(166, 227, 161)";
          placeholder_text = "";

          check_color = "rgb(137, 180, 250)";
          fail_color = "rgb(243, 139, 168)";

          halign = "center";
          valign = "center";
          zindex = 10;
        }
      ];

      label = [
        # 1. TIME
        {
          text = "cmd[update:1000] echo \"$(date +'%H:%M')\"";
          color = "rgb(205, 214, 244)";
          font_size = time_size;
          font_family = "${font_family} ExtraBold";

          shadow_passes = 2;
          shadow_size = 3;

          position = "0, 200";
          halign = "center";
          valign = "center";
        }

        # --- CODE BLOCK ---
        # 2. let date
        {
          text = "cmd[update:1000] echo \"<span foreground='##cba6f7'>let</span> date <span foreground='##89b4fa'>=</span> <span foreground='##a6e3a1'>\\\"$(date +'%A, %B %d')\\\"</span><span foreground='##89b4fa'>;</span>\"";
          font_size = font_size;
          font_family = "${font_family}";
          shadow_passes = 1;

          position = "${toString code_base_x}, 100";
          halign = "center";
          valign = "center";
        }

        # 3. let mantra
        {
          text = "<span foreground='##cba6f7'>let</span> mantra <span foreground='##89b4fa'>=</span> <span foreground='##a6e3a1'>\\\"Focus and Simplicity!\\\"</span><span foreground='##89b4fa'>;</span>";
          font_size = font_size;
          font_family = "${font_family}";
          shadow_passes = 1;

          position = "${toString code_base_x}, 70";
          halign = "center";
          valign = "center";
        }

        # 4. impl Developer
        {
          text = "<span foreground='##cba6f7'>impl</span> <span foreground='##fab387'>Developer</span> <span foreground='##cba6f7'>for</span> <span foreground='##89b4fa'>Nekoma</span> {";
          font_size = font_size;
          font_family = "${font_family}";
          shadow_passes = 1;

          position = "${toString code_base_x}, 30";
          halign = "center";
          valign = "center";
        }

        # 5. your_password prefix
        {
          text = "<span foreground='##fab387'>your_pass</span> <span foreground='##89b4fa'>=</span> <span foreground='##fab387'>Secret</span>::<span foreground='##89b4fa'>new</span>(<span foreground='##a6e3a1'>r##&quot;</span>";
          font_size = font_size;
          font_family = "${font_family}";
          shadow_passes = 1;

          # Indent 1
          position = "${toString indent_1}, -10";
          halign = "center";
          valign = "center";
        }

        # 6. CLOSING suffix
        {
          text = "<span foreground='##a6e3a1'>&quot;##</span>);";
          font_size = font_size;
          font_family = "${font_family}";
          shadow_passes = 1;

          position = "${toString indent_1}, -60";
          halign = "center";
          valign = "center";
        }

        # 7. Closing brace }
        {
          text = "}";
          font_size = font_size;
          font_family = "${font_family}";
          shadow_passes = 1;

          position = "${toString code_base_x}, -100";
          halign = "center";
          valign = "center";
        }
      ];
    };
  };
}
