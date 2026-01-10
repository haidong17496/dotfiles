{pkgs, ...}: {
  programs.zathura = {
    enable = true;

    package = pkgs.zathura.override {
      plugins = [
        pkgs.zathuraPkgs.zathura_pdf_mupdf
        pkgs.zathuraPkgs.zathura_djvu
      ];
    };

    options = {
      default-bg = "#1e1e2e";
      default-fg = "#cdd6f4";
      statusbar-bg = "#313244";
      statusbar-fg = "#cdd6f4";
      inputbar-bg = "#313244";
      inputbar-fg = "#cdd6f4";
      notification-bg = "#313244";
      notification-fg = "#cdd6f4";
      notification-error-bg = "#f38ba8";
      notification-error-fg = "#cdd6f4";
      notification-warning-bg = "#fab387";
      notification-warning-fg = "#1e1e2e";
      highlight-color = "rgba(245, 194, 231, 0.5)";
      highlight-active-color = "rgba(245, 194, 231, 0.5)";
      completion-bg = "#313244";
      completion-fg = "#cdd6f4";
      completion-highlight-bg = "#585b70";
      completion-highlight-fg = "#cdd6f4";
      recolor-lightcolor = "#1e1e2e";
      recolor-darkcolor = "#cdd6f4";

      recolor = "true";
      selection-clipboard = "clipboard";
    };
  };

  # --- VIDEO PLAYER (MPV) ---
  programs.mpv = {
    enable = true;
    defaultProfiles = ["gpu-hq"];
    scripts = [pkgs.mpvScripts.mpris];

    config = {
      osc = "no";
      border = "no";

      hwdec = "auto-safe";
      vo = "gpu";
    };
  };

  # --- IMAGE VIEWER ---
  programs.imv = {
    enable = true;
  };
}
