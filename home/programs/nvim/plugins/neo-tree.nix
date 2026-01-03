{
  programs.nixvim = {
    plugins.neo-tree = {
      enable = true;

      settings = {
        close_if_last_window = true;

        window = {
          width = 30;
          auto_expand_width = false;
        };

        filesystem = {
          follow_current_file.enabled = true;
          use_libuv_file_watcher = true;
        };
      };
    };

    keymaps = [
      {
        mode = "n";
        key = "<leader>e";
        action = "<cmd>Neotree toggle<CR>";
        options.desc = "Toggle Explorer";
      }
    ];
  };
}
