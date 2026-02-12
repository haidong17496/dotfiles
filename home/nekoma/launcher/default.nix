{pkgs, ...}: {
  programs.walker.config = {
    # UI Preference
    ui.fullscreen = false;
    theme = "nkmTheme";

    # Behavior (Focus, Click behavior)
    force_keyboard_focus = false;
    close_when_open = true;
    click_to_close = true;
    single_click_activation = true;

    # Keybinds
    keybinds = {
      close = ["Escape"];
      next = ["Down" "ctrl j"];
      previous = ["Up" "ctrl k"];
      quick_activate = ["F1" "F2" "F3"];
      toggle_exact = ["ctrl e"];
    };
  };

  # Load Theme
  programs.walker.themes = {
    nkmTheme = {
      style = builtins.readFile ./style.css;
    };
  };
}
