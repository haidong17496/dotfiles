{ inputs, pkgs, ... }:
{
    # 1. Import the module from the flake input
    imports = [ inputs.walker.homeManagerModules.default ];

    programs.walker = {
    enable = true;
    runAsService = true;

    config = {
      ui.fullscreen = false; # Set to true if you want the big overlay
      theme = "nkmTheme";    
      
      force_keyboard_focus = false;
      close_when_open = true;
      click_to_close = true;
      single_click_activation = true;
      
      # Search Settings
      exact_search_prefix = "'";
      global_argument_delimiter = "#";

      # 3. Providers Setup
      providers = {
        # ADDED 'calc' and 'runner' here as requested
        default = [ "desktopapplications" "calc" "runner" "websearch" ];
        empty = [ "desktopapplications" ];
        max_results = 50;

        # Prefix mappings (translated from your TOML)
        prefixes = [
          { prefix = ";"; provider = "providerlist"; }
          { prefix = ">"; provider = "runner"; }       # Run terminal commands
          { prefix = "/"; provider = "files"; }
          { prefix = "="; provider = "calc"; }         # Calculator
          { prefix = "@"; provider = "websearch"; }
          { prefix = ":"; provider = "clipboard"; }
          { prefix = "!"; provider = "todo"; }
        ];

        # Specific Provider Settings
        runner = {
          argument_delimiter = " ";
        };
        clipboard = {
          time_format = "%d.%m. - %H:%M";
        };
      };

      # 4. Keybinds
      keybinds = {
        close = [ "Escape" ];
        next = [ "Down" "ctrl j" ];
        previous = [ "Up" "ctrl k" ];
        quick_activate = [ "F1" "F2" "F3" ];
        toggle_exact = [ "ctrl e" ];
      };
    };

    # 5. Theme Configuration
    themes = {
      nkmTheme = {
        style = builtins.readFile ./style.css;
      };
    };
  };
}
