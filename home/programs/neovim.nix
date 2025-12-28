{ pkgs, ... }:

{
    programs.neovim = {
        enable = true;
        defaultEditor = true;
        viAlias = true;
        vimAlias = true;

        extraPackages = with pkgs; [
            wl-clipboard
            xclip
        ];

        extraLuaConfig = builtins.readFile ./nvim/init.lua;
    };
}
