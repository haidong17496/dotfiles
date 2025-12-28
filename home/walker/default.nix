{ pkgs, ... }:

{
    services.walker = {
        enable = true;
        systemd.enable = true;
        
        settings = {
            placeholder = { text = "Search..."; };
        };

        theme = {
            style = builtins.readFile ./style.css;
        };
    };
}
