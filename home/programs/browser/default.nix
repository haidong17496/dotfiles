{
  pkgs,
  inputs,
  ...
}: {
  programs.firefox = {
    enable = true;
    profiles.default = {
      id = 0;
      name = "default";

      settings = {
        "browser.privatebrowsing.autostart" = true;
        "extensions.activeThemeID" = "firefox-compact-dark@mozilla.org";
        "toolkit.legacyUserProfileCustomizations.stylesheets" = true;
        "svg.context-properties.content.enabled" = true;
        "browser.download.useDownloadDir" = false;
        "datareporting.healthreport.uploadEnable" = false;
        "datareporting.usage.uploadEnabled" = false;
      };

      extensions.packages = with inputs.firefox-addons.packages.${pkgs.stdenv.hostPlatform.system}; [
        translate-web-pages
        ublock-origin
        vimium
      ];

      userChrome = builtins.readFile ./userChrome.css;
      userContent = builtins.readFile ./userContent.css;
    };
  };
}
