{ pkgs, ... }:

let
    wallpaper = ./../../images/wallpaper.png;
    font_family = "JetBrainsMono Nerd Font";
    
    # --- LAYOUT CONSTANTS ---
    font_size = 18;
    
    # LEVEL 0: Margin
    base_x = 420; 
    
    # LEVEL 1: Indent (Labels)
    indent_1 = base_x + 50;
    
    # LEVEL 2: Double Indent (Input Field)
    indent_2 = base_x + 100;
    
    toString = x: builtins.toString x;
in
{
    programs.hyprlock = {
        enable = true;
        
        settings = {
            general = {
                hide_cursor = true;
            };

            background = [
                {
                    path = "${wallpaper}";
                    blur_passes = 3;
                    blur_size = 5;
                    brightness = 0.4;
                }
            ];

            # --- INPUT FIELD (Level 2) ---
            input-field = [
                {
                    size = "300, ${toString (font_size * 2)}"; 
                    position = "${toString indent_2}, -10"; 
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
                    
                    halign = "left";
                    valign = "center";
                }
            ];

            label = [
                # 1. TIME (Level 0)
                {
                    text = "cmd[update:1000] echo \"<span foreground='##cba6f7'>let</span> time <span foreground='##89b4fa'>=</span> <span foreground='##a6e3a1'>\\\"$(date +'%H:%M')\\\"</span><span foreground='##89b4fa'>;</span>\"";
                    color = "rgb(205, 214, 244)";
                    font_size = font_size;
                    font_family = "${font_family} Bold";
                    position = "${toString base_x}, 140";
                    halign = "left";
                    valign = "center";
                }

                # 2. DATE (Level 0)
                {
                    text = "cmd[update:1000] echo \"<span foreground='##cba6f7'>let</span> date <span foreground='##89b4fa'>=</span> <span foreground='##a6e3a1'>\\\"$(date +'%A, %B %d')\\\"</span><span foreground='##89b4fa'>;</span>\"";
                    color = "rgb(205, 214, 244)";
                    font_size = font_size;
                    font_family = "${font_family} Bold";
                    position = "${toString base_x}, 110";
                    halign = "left";
                    valign = "center";
                }

                # 3. CLASS DEFINITION (Level 0)
                {
                    text = "<span foreground='##cba6f7'>impl</span> <span foreground='##fab387'>Developer</span> <span foreground='##cba6f7'>for</span> <span foreground='##89b4fa'>Nekoma</span> {";
                    color = "rgb(205, 214, 244)";
                    font_size = font_size;
                    font_family = "${font_family} Bold";
                    position = "${toString base_x}, 70";
                    halign = "left";
                    valign = "center";
                }

                # 4. WRAPPER OPEN (Level 1)
                {
                    text = "<span foreground='##fab387'>your_password</span> <span foreground='##89b4fa'>=</span> <span foreground='##fab387'>Secret</span>::<span foreground='##89b4fa'>new</span>(<span foreground='##a6e3a1'>r##&quot;</span>";
                    color = "rgb(205, 214, 244)";
                    font_size = font_size;
                    font_family = "${font_family} Bold";
                    position = "${toString indent_1}, 30"; 
                    halign = "left";
                    valign = "center";
                }

                # 5. WRAPPER CLOSE (Level 1)
                {
                    text = "<span foreground='##a6e3a1'>&quot;##</span>);";
                    color = "rgb(205, 214, 244)";
                    font_size = font_size;
                    font_family = "${font_family} Bold";
                    position = "${toString indent_1}, -50"; 
                    halign = "left";
                    valign = "center";
                }

                # 6. QUOTE (Level 1)
                {
                    text = "<span foreground='##f38ba8'>println!</span>(<span foreground='##a6e3a1'>&quot;Stay Hungry, Stay Foolish!&quot;</span>);";
                    color = "rgb(205, 214, 244)";
                    font_size = font_size;
                    font_family = "${font_family} Italic";
                    position = "${toString indent_1}, -90";
                    halign = "left";
                    valign = "center";
                }

                # 7. CLOSING BRACE (Level 0)
                {
                    text = "}";
                    color = "rgb(205, 214, 244)";
                    font_size = font_size;
                    font_family = "${font_family} Bold";
                    position = "${toString base_x}, -130";
                    halign = "left";
                    valign = "center";
                }
            ];
        };
    };
}
