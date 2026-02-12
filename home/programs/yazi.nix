{pkgs, ...}: {
  programs.yazi = {
    enable = true;
    enableZshIntegration = true;

    settings = {
      manager = {
        show_hidden = false;
        sort_by = "alphabetical";
        sort_sensitive = false;
        sort_reverse = false;
        sort_dir_first = true;
        linemode = "none";
        show_symlink = true;
      };
    };

    keymap = {
      mgr.prepend_keymap = [
        {
          on = ["<C-d>"];
          # call xdragon:
          # -a: all files
          # -x: exit after drag
          # "$@": list selected files in Yazi
          run = "shell 'dragon-drop -a -x \"$@\"' --confirm";
          desc = "Dragon Drop selected files";
        }
      ];
    };
  };
}
