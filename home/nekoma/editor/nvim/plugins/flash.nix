{
  programs.nixvim = {
    plugins.flash = {
      enable = true;

      settings = {
        # Setup labels for the jump characters
        labels = "asdfghjklqwertyuiopzxcvbnmASDFGHJKLQWERTYUIOPZXCVBNM";

        search = {
          mode = "exact";
        };

        jump = {
          autojump = false;
        };
      };
    };

    keymaps = [
      {
        mode = ["n" "x" "o"];
        key = "s";
        action = "<cmd>lua require('flash').jump()<CR>";
        options = {
          desc = "Flash Jump";
        };
      }
      {
        mode = ["n" "x" "o"];
        key = "S";
        action = "<cmd>lua require('flash').treesitter()<CR>";
        options = {
          desc = "Flash Treesitter";
        };
      }
      {
        mode = "o";
        key = "r";
        action = "<cmd>lua require('flash').remote()<CR>";
        options = {
          desc = "Remote Flash";
        };
      }
      {
        mode = ["o" "x"];
        key = "R";
        action = "<cmd>lua require('flash').treesitter_search()<CR>";
        options = {
          desc = "Treesitter Search";
        };
      }
    ];
  };
}
