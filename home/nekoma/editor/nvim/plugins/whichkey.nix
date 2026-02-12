{
  programs.nixvim.plugins.which-key = {
    enable = true;

    settings = {
      spec = [
        {
          __unkeyed-1 = "<leader>f";
          group = "File/Find";
          icon = " ";
        }
        {
          __unkeyed-1 = "<leader>c";
          group = "Code";
          icon = " ";
        }
        {
          __unkeyed-1 = "<leader>d";
          group = "Debug/Diagnostics";
          icon = " ";
        }
        {
          __unkeyed-1 = "g";
          group = "Goto";
        }
      ];
    };
  };
}
