{
  programs.nixvim.plugins.lsp = {
    enable = true;

    # Keymaps for LSP actions (Direct jumps/actions)
    keymaps = {
      silent = true;
      diagnostic = {
        "<leader>j" = "goto_next";
        "<leader>k" = "goto_prev";
      };

      lspBuf = {
        # Go to Definition (Instant jump)
        gd = "definition";

        # Go to Declaration (Header files / Traits)
        gD = "declaration";

        # Hover documentation
        K = "hover";

        # Rename: Support both Standard (F2) and Vim-style (<leader>rn)
        "<F2>" = "rename";
        "<leader>rn" = "rename";

        # Code Action (Context menu)
        "<leader>ca" = "code_action";
      };
    };

    servers = {
      # Nix
      nixd.enable = true;

      # Python
      basedpyright.enable = true;
    };
  };
}
