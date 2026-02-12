{
  programs.nixvim.plugins.markview = {
    enable = true;

    settings = {
      preview = {
        modes = ["n" "no" "c"];
        hybrid_modes = ["i"];

        callbacks = {
          on_enable.__raw = ''
            function (_, win)
                vim.wo[win].conceallevel = 2
                vim.wo[win].concealcursor = "nc"
            end
          '';
        };
      };
    };
  };
}
