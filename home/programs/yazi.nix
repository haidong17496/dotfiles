{ pkgs, ... }:

{
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
    };
}
