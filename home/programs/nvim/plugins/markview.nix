{
  programs.nixvim.plugins.markview = {
    enable = true;

    settings = {
      # Render in Normal, Operator-pending, and Command modes
      modes = ["n" "no" "c"];

      # Show raw text in Insert mode (so you can edit easily)
      hybrid_modes = ["i"];

      # Tune aesthetics
      callbacks = {
        on_enable.__raw = ''
          function (_, win)
              vim.wo[win].conceallevel = 2 -- Hide symbols like **
              vim.wo[win].concealcursor = "nc" -- Hide cursor in normal mode
          end
        '';
      };
    };
  };
}
