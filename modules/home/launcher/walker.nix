{
  inputs,
  pkgs,
  ...
}: {
  imports = [inputs.walker.homeManagerModules.default];

  programs.walker = {
    enable = true;
    runAsService = true;

    config = {
      # Search Settings
      exact_search_prefix = "'";
      global_argument_delimiter = "#";

      providers = {
        default = ["desktopapplications" "calc" "runner" "websearch"];
        empty = ["desktopapplications"];
        max_results = 50;

        # Prefix mappings
        prefixes = [
          {
            prefix = ";";
            provider = "providerlist";
          }
          {
            prefix = ">";
            provider = "runner";
          }
          {
            prefix = "/";
            provider = "files";
          }
          {
            prefix = "=";
            provider = "calc";
          }
          {
            prefix = "@";
            provider = "websearch";
          }
          {
            prefix = ":";
            provider = "clipboard";
          }
          {
            prefix = "!";
            provider = "todo";
          }
        ];

        runner = {argument_delimiter = " ";};
        clipboard = {time_format = "%d.%m. - %H:%M";};
      };
    };
  };
}
