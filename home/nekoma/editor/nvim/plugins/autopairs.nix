{
  programs.nixvim.plugins.nvim-autopairs = {
    enable = true;

    settings = {
      # Use treesitter to check for pairs (smarter)
      check_ts = true;

      # Don't autopair in these filetypes
      disable_filetype = ["TelescopePrompt" "vim"];
    };
  };
}
