{ pkgs, ... }:

{
    programs.nixvim.plugins.treesitter = {
        enable = true;

        settings = {
            highlight.enable = true;
            indent.enable = true;
        };

        grammarPackages = with pkgs.vimPlugins.nvim-treesitter-parsers; [
            # Core
            nix
            rust
            python
            lua
            bash

            # Data
            markdown
            markdown_inline
            toml
            json
            yaml

            # Neovim Internal
            vim
            vimdoc
            regex
        ];
    };
}
