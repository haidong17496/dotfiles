{pkgs, ...}: {
  programs.nixvim = {
    plugins.conform-nvim = {
      enable = true;

      settings = {
        format_on_save = {
          lsp_fallback = true;
          timeout_ms = 500;
        };

        formatters_by_ft = {
          python = ["black"];
          nix = ["alejandra"];
          "*" = ["trim_whitespace"];
        };
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>cf";
        action = "<cmd>lua require('conform').format({ lsp_fallback = true })<CR>";
        options = {
          silent = true;
          desc = "Format Buffer";
        };
      }
    ];
  };

  home.packages = with pkgs; [
    alejandra
    black
  ];
}
