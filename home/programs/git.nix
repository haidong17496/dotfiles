{ pkgs, ... }:

{
    programs.git = {
        enable = true;
        settings = {
            user.name = "nekoma";
            user.email = "pqh.one@gmail.com";
        };
    };
}
