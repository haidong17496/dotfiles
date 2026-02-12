{
  pkgs,
  inputs,
  ...
}: {
  programs.firefox.profiles.default = {
    # --- SEARCH ENGINES (User Specific) ---
    search = {
      force = true;
      default = "Google";
      engines = {
        "ArchWiki" = {
          urls = [{template = "https://wiki.archlinux.org/index.php?search={searchTerms}";}];
          iconUpdateURL = "https://wiki.archlinux.org/favicon.ico";
          updateInterval = 24 * 60 * 60 * 1000; # Update every day
          definedAliases = ["!aw"];
        };

        "Nix Packages" = {
          urls = [
            {
              template = "https://search.nixos.org/packages";
              params = [
                {
                  name = "type";
                  value = "packages";
                }
                {
                  name = "query";
                  value = "{searchTerms}";
                }
              ];
            }
          ];
          icon = "${pkgs.nixos-icons}/share/icons/hicolor/scalable/apps/nix-snowflake.svg";
          definedAliases = ["!nix"];
        };

        "YouTube" = {
          urls = [{template = "https://www.youtube.com/results?search_query={searchTerms}";}];
          definedAliases = ["!yt"];
        };
      };
    };

    # --- UI & EXTENSIONS ---
    settings = {
      # --- GENERAL & UI ---
      "browser.privatebrowsing.autostart" = true;
      "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
      "svg.context-properties.content.enabled" = true;
      "browser.download.useDownloadDir" = false;

      # --- THEME (FORCE DARK MODE) ---
      "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
      "ui.systemUsesDarkTheme" = 1;
      "devtools.theme" = "dark";
      "layout.css.prefers-color-scheme.content-override" = 0;
    };

    extensions.packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
      translate-web-pages
      ublock-origin
      vimium
    ];

    userChrome = builtins.readFile ./userChrome.css;
    userContent = builtins.readFile ./userContent.css;
  };
}
