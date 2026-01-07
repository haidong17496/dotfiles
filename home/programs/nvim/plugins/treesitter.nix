{pkgs, ...}: {
  programs.nixvim = {
    plugins.treesitter = {
      enable = true;
      settings = {
        highlight.enable = true;
        indent.enable = true;
      };
      grammarPackages = [];
    };

    extraPlugins = with pkgs.vimPlugins.nvim-treesitter-parsers; [
      nix
      rust
      python
      lua
      bash
      markdown
      markdown_inline
      toml
      json
      yaml
      vim
      vimdoc
      regex
    ];
  };
}
